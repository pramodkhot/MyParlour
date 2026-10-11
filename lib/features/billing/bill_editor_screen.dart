import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/l10n/l10n.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/money.dart';
import '../../core/format/phone.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/discard_changes_scope.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/field_label.dart';
import '../../core/widgets/text_prompt.dart';
import '../../domain/errors.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/invoice.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/invoice_calculator.dart';
import '../appointments/widgets/customer_picker.dart';
import 'billing_controller.dart';
import 'widgets/bill_line_tile.dart';
import 'widgets/item_picker_sheet.dart';
import 'widgets/totals_card.dart';

/// S9 — Create a bill (new, from an appointment, or continuing a draft).
class BillEditorScreen extends ConsumerWidget {
  const BillEditorScreen({super.key, required this.args});

  final BillEditorArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(billEditorDataProvider(args))) {
      AsyncValue(:final value?) when value.existingBillForAppointment != null =>
        _Message(
          'This appointment already has a bill.',
          actionLabel: 'Open bill',
          onAction: () => context.pushReplacement(
            Routes.bill(value.existingBillForAppointment!.id),
          ),
        ),
      AsyncValue(:final value?)
          when args.draftId != null &&
              (value.draft == null || !value.draft!.isDraft) =>
        _Message(
          'This bill is no longer a draft.',
          actionLabel: 'Open bill',
          onAction: () => context.pushReplacement(Routes.bill(args.draftId!)),
        ),
      AsyncValue(:final value?) => _Editor(data: value),
      AsyncValue(:final error?) => _Message('Could not open the bill. $error'),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Editor extends ConsumerStatefulWidget {
  const _Editor({required this.data});

  final BillEditorData data;

  @override
  ConsumerState<_Editor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<_Editor> {
  // Chosen once: saving or finalising twice updates the same bill.
  late final String _billId =
      widget.data.draft?.id ?? ref.read(billingActionsProvider).newId();

  late Customer? _customer = widget.data.presetCustomer;
  late String? _walkInName =
      widget.data.draft?.walkInName ?? widget.data.appointment?.walkInName;
  late List<BillLine> _lines = _initialLines();
  late DiscountType _discountType = switch (widget.data.draft?.discountType) {
    DiscountType.percent => DiscountType.percent,
    _ => DiscountType.amount,
  };
  late final _discount = TextEditingController(text: _initialDiscountText());
  bool _busy = false;
  bool _touched = false;

  List<BillLine> _initialLines() {
    final draft = widget.data.draft;
    if (draft != null) return billLinesOf(draft);
    final a = widget.data.appointment;
    if (a == null) return [];
    final menu = {for (final s in widget.data.services) s.id: s};
    return [
      for (final s in a.services)
        BillLine(
          type: InvoiceItemType.service,
          refId: s.serviceId,
          name: s.name,
          unitPricePaise: s.pricePaise,
          qty: 1,
          taxRateBp:
              menu[s.serviceId]?.taxRateBp ??
              widget.data.parlour.defaultTaxRateBp,
          staffId: a.staffId,
        ),
    ];
  }

  String _initialDiscountText() {
    final d = widget.data.draft;
    if (d == null || d.discountType == DiscountType.none) return '';
    // Percent is stored in basis points (1250 = 12.5%), which formats the
    // same way as paise (₹12.50), so both use Money.
    return Money.format(
      d.discountValue,
    ).replaceAll('₹', '').replaceAll(',', '');
  }

  @override
  void initState() {
    super.initState();
    _discount.addListener(() => setState(() => _touched = true));
  }

  @override
  void dispose() {
    _discount.dispose();
    super.dispose();
  }

  BillDiscount get _billDiscount {
    final value = Money.parseRupees(_discount.text);
    if (value == null || value == 0) return const BillDiscount.none();
    return BillDiscount.of(_discountType, value);
  }

  String? get _discountInputError {
    final text = _discount.text.trim();
    if (text.isEmpty) return null;
    if (Money.parseRupees(text) == null) return 'Enter a number.';
    return null;
  }

  BillDraft _draft() => BillDraft(
    id: _billId,
    customerId: _customer?.id,
    walkInName: _customer == null ? _walkInName : null,
    appointmentId: widget.data.appointment?.id,
    lines: _lines,
    discount: _billDiscount,
  );

  String? _stylist(String? staffId) => staffId == null
      ? null
      : widget.data.staff.where((s) => s.id == staffId).firstOrNull?.name;

  int _maxQty(BillLine line) {
    if (line.type != InvoiceItemType.product) return 99;
    final p = widget.data.products.where((p) => p.id == line.refId).firstOrNull;
    return (p?.stockQty ?? 99).clamp(1, 99);
  }

  Future<void> _changeClient() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.people_alt_outlined),
              title: const Text('Choose a saved customer'),
              onTap: () => Navigator.of(context).pop('customer'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk_rounded),
              title: const Text('Walk-in customer'),
              onTap: () => Navigator.of(context).pop('walkin'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == 'customer') {
      final c = await showCustomerPicker(
        context,
        customers: widget.data.customers,
      );
      if (c != null) {
        setState(() {
          _customer = c;
          _touched = true;
        });
      }
    } else {
      final name = await showTextPrompt(
        context,
        title: 'Walk-in name',
        confirmLabel: 'Done',
        hint: 'e.g. Kiran',
      );
      setState(() {
        _customer = null;
        _walkInName = name;
        _touched = true;
      });
    }
  }

  Future<void> _addItem() async {
    final line = await showItemPicker(
      context,
      services: widget.data.services,
      products: widget.data.products,
      defaultTaxRateBp: widget.data.parlour.defaultTaxRateBp,
      staffId: widget.data.appointment?.staffId,
    );
    if (line == null) return;
    setState(() {
      _touched = true;
      final i = _lines.indexWhere(
        (l) => l.type == line.type && l.refId == line.refId,
      );
      if (i == -1) {
        _lines = [..._lines, line];
      } else {
        final next = (_lines[i].qty + 1).clamp(1, _maxQty(_lines[i]));
        _lines = [..._lines]..[i] = _lines[i].withQty(next);
      }
    });
  }

  bool _validate() {
    if (_lines.isEmpty) {
      showMessage(context, 'Add at least one service or product.');
      return false;
    }
    if (_discountInputError != null) {
      showMessage(context, 'Check the discount.');
      return false;
    }
    return true;
  }

  Future<void> _saveDraft() async {
    if (_busy || !_validate()) return;
    setState(() => _busy = true);
    try {
      await ref.read(billingActionsProvider).saveDraft(_draft());
      if (!mounted) return;
      showMessage(context, 'Draft saved');
      Navigator.of(context).pop();
    } on DomainException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _proceed() async {
    if (_busy || !_validate()) return;
    setState(() => _busy = true);
    try {
      final bill = await ref.read(billingActionsProvider).finalise(_draft());
      if (!mounted) return;
      if (bill.status == InvoiceStatus.paid) {
        showMessage(context, '${bill.invoiceNo} saved. Nothing to pay.');
        context.go(Routes.bill(bill.id));
      } else {
        context.go(Routes.payBill(bill.id));
      }
    } on DomainException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.data.parlour;
    final totals = InvoiceCalculator.calculate(
      items: [
        for (var i = 0; i < _lines.length; i++) _lines[i].toPreviewItem(i),
      ],
      discount: _billDiscount,
      taxEnabled: p.taxEnabled,
      pricesIncludeTax: p.pricesIncludeTax,
    );
    final discountRule = InvoiceCalculator.discountError(
      _billDiscount,
      totals.subtotalPaise,
    );
    final discountError =
        _discountInputError ??
        (discountRule == null ? null : context.l10n.error(discountRule));

    final clientName =
        _customer?.name ??
        (_walkInName == null || _walkInName!.isEmpty
            ? 'Walk-in customer'
            : 'Walk-in · $_walkInName');

    return DiscardChangesScope(
      isDirty: _touched && !_busy,
      child: Scaffold(
        appBar: AppTopBar(
          title: 'Create bill',
          subtitle: widget.data.draft == null ? null : 'Draft',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            Space.screen,
            Space.sm,
            Space.screen,
            Space.xxl,
          ),
          children: [
            const FieldLabel('Customer', required: true),
            Gap.h8,
            Container(
              padding: const EdgeInsets.only(left: Space.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: Radii.controlAll,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  AvatarInitials(name: _customer?.name ?? 'W', size: 36),
                  Gap.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(clientName, style: AppText.bodyStrong),
                        if (_customer != null)
                          Text(
                            PhoneNumber.display(_customer!.phone),
                            style: AppText.caption,
                          ),
                      ],
                    ),
                  ),
                  if (widget.data.appointment == null)
                    TextButton(
                      onPressed: _changeClient,
                      child: const Text('Change'),
                    ),
                ],
              ),
            ),
            Gap.h20,
            const FieldLabel('Items', required: true),
            Gap.h8,
            for (var i = 0; i < _lines.length; i++) ...[
              BillLineTile(
                key: ValueKey('${_lines[i].type.name}-${_lines[i].refId}'),
                line: _lines[i],
                stylistName: _stylist(_lines[i].staffId),
                maxQty: _maxQty(_lines[i]),
                onQty: (q) => setState(() {
                  _touched = true;
                  _lines = [..._lines]..[i] = _lines[i].withQty(q);
                }),
                onRemove: () => setState(() {
                  _touched = true;
                  _lines = [..._lines]..removeAt(i);
                }),
              ),
              Gap.h8,
            ],
            if (_lines.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(left: Space.xs, bottom: Space.xs),
                child: Text(
                  'Swipe a line left to remove it.',
                  style: AppText.caption,
                ),
              ),
            OutlinedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add service or product'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppColors.border),
                textStyle: AppText.link,
              ),
            ),
            Gap.h20,
            const FieldLabel('Discount'),
            Gap.h8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<DiscountType>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: DiscountType.amount, label: Text('₹')),
                    ButtonSegment(
                      value: DiscountType.percent,
                      label: Text('%'),
                    ),
                  ],
                  selected: {_discountType},
                  onSelectionChanged: (s) => setState(() {
                    _discountType = s.first;
                    _touched = true;
                  }),
                ),
                Gap.w12,
                Expanded(
                  child: TextField(
                    controller: _discount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    style: AppText.body,
                    decoration: InputDecoration(
                      hintText: _discountType == DiscountType.percent
                          ? 'e.g. 10'
                          : 'e.g. 300',
                      suffixText: _discountType == DiscountType.percent
                          ? '%'
                          : null,
                      prefixText: _discountType == DiscountType.amount
                          ? '₹ '
                          : null,
                      errorText: discountError,
                    ),
                  ),
                ),
              ],
            ),
            Gap.h20,
            TotalsCard(
              subtotalPaise: totals.subtotalPaise,
              discountPaise: totals.discountPaise,
              taxPaise: totals.taxPaise,
              totalPaise: totals.totalPaise,
              showTax: p.taxEnabled,
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              Space.sm,
              Space.screen,
              Space.lg,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: SecondaryButton(
                    label: 'Save draft',
                    onPressed: _busy ? null : _saveDraft,
                  ),
                ),
                Gap.w12,
                Expanded(
                  child: PrimaryButton(
                    label: 'Proceed to payment',
                    loading: _busy,
                    onPressed: discountError == null ? _proceed : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.message, {this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Bill'),
      body: Center(
        child: EmptyState(
          icon: Icons.receipt_long_outlined,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      ),
    );
  }
}
