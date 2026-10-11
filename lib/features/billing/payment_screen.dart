import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/money.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/field_label.dart';
import '../../domain/errors.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/payment.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/invoice_rules.dart';
import 'billing_controller.dart';
import 'payment_method_ui.dart';

/// S10 — Record a payment against a bill.
class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key, required this.billId});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(billDetailProvider(billId))) {
      AsyncValue(:final value?) when !value.invoice.isOpen => _Message(
        value.invoice.isVoid
            ? 'This bill is void.'
            : value.invoice.isDraft
            ? 'Finish the bill before taking payment.'
            : 'This bill is fully paid.',
        billId: billId,
      ),
      AsyncValue(:final value?) => _PaymentForm(invoice: value.invoice),
      AsyncValue(hasValue: true) => _Message(
        'This bill no longer exists.',
        billId: billId,
      ),
      AsyncValue(:final error?) => _Message(
        'Could not load this bill. $error',
        billId: billId,
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _PaymentForm extends ConsumerStatefulWidget {
  const _PaymentForm({required this.invoice});

  final Invoice invoice;

  @override
  ConsumerState<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends ConsumerState<_PaymentForm> {
  // One id per screen visit: tapping Confirm twice cannot pay twice.
  late final String _paymentId = ref.read(billingActionsProvider).newId();
  // The balance when the screen opened (the bill updates after saving).
  late final int _balance = widget.invoice.balancePaise;
  late final _amount = TextEditingController(
    text: Money.format(_balance).replaceAll('₹', '').replaceAll(',', ''),
  );
  final _reference = TextEditingController();
  final _note = TextEditingController();
  PaymentMethod _method = PaymentMethod.cash;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in [_amount, _reference, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _amountPaise => Money.parseRupees(_amount.text);

  String? get _error {
    final paise = _amountPaise;
    if (paise == null) return 'Enter the amount received.';
    return InvoiceRules.paymentError(
      amountPaise: paise,
      balancePaise: _balance,
      method: _method,
    );
  }

  Future<void> _confirm() async {
    if (_saving || _error != null) return;
    setState(() => _saving = true);
    // Saving refreshes the bill; once fully paid this form is replaced, so
    // keep the router to move on to the success screen afterwards.
    final router = GoRouter.of(context);
    try {
      await ref
          .read(billingActionsProvider)
          .recordPayment(
            PaymentInput(
              id: _paymentId,
              invoiceId: widget.invoice.id,
              amountPaise: _amountPaise!,
              method: _method,
              reference: _reference.text,
              note: _note.text,
            ),
          );
      router.pushReplacement(Routes.paymentDone(widget.invoice.id, _paymentId));
    } on DomainException catch (e) {
      if (mounted) {
        showMessage(context, e.message);
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bill = widget.invoice;
    final paise = _amountPaise;
    final error = _error;
    final caption = paise == null || error != null
        ? null
        : paise == _balance
        ? 'Full balance'
        : 'Partial · ${Money.format(_balance - paise)} will still be due';

    return Scaffold(
      appBar: AppTopBar(title: 'Payment', subtitle: bill.invoiceNo),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.xl,
          Space.sm,
          Space.xl,
          Space.xxl,
        ),
        children: [
          AppCard(
            child: Column(
              children: [
                _AmountRow('Bill total', bill.totalPaise),
                _AmountRow('Already received', bill.paidPaise),
                const Divider(height: Space.xl),
                _AmountRow('Balance due', _balance, strong: true),
              ],
            ),
          ),
          Gap.h20,
          const FieldLabel('Payment method', required: true),
          Gap.h8,
          ChoiceChips<PaymentMethod>(
            options: [
              for (final m in PaymentMethod.values)
                ChoiceOption(m, m.label, icon: m.icon),
            ],
            selected: _method,
            onSelected: (m) => setState(() => _method = m),
          ),
          if (_method == PaymentMethod.upi) ...[
            Gap.h8,
            const Text(
              'Records the payment; the app does not verify UPI.',
              style: AppText.caption,
            ),
          ],
          Gap.h20,
          AppTextField(
            label: 'Amount received',
            isRequired: true,
            controller: _amount,
            prefixText: '₹ ',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
          Gap.h4,
          Text(
            error ?? caption ?? '',
            style: AppText.caption.copyWith(
              color: error != null ? AppColors.error : AppColors.textMuted,
            ),
          ),
          Gap.h16,
          AppTextField(
            label: _method.referenceLabel,
            controller: _reference,
            keyboardType: _method == PaymentMethod.card
                ? TextInputType.number
                : TextInputType.text,
            maxLength: _method == PaymentMethod.card ? 4 : 40,
          ),
          Gap.h16,
          AppTextField(
            label: 'Note',
            controller: _note,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.xl,
            Space.sm,
            Space.xl,
            Space.lg,
          ),
          child: PrimaryButton(
            label: paise == null || error != null
                ? 'Confirm'
                : 'Confirm ${Money.format(paise)}',
            loading: _saving,
            onPressed: error == null ? _confirm : null,
          ),
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow(this.label, this.paise, {this.strong = false});

  final String label;
  final int paise;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong
        ? AppText.bodyStrong.copyWith(fontSize: 18)
        : AppText.body;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(Money.format(paise), style: style),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.message, {required this.billId});

  final String message;
  final String billId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Payment'),
      body: Center(
        child: EmptyState(
          icon: Icons.receipt_long_outlined,
          message: message,
          actionLabel: 'Open bill',
          onAction: () => context.pushReplacement(Routes.bill(billId)),
        ),
      ),
    );
  }
}
