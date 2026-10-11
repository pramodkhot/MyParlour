import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/discard_changes_scope.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/field_label.dart';
import '../../core/widgets/picker_field.dart';
import '../../domain/errors.dart';
import '../../domain/models/parlour.dart';
import '../../domain/models/value_types.dart';
import 'settings_controller.dart';

/// Which part of the parlour settings a form edits.
enum SettingsSection { profile, hours, billing }

/// Loads the parlour and shows the form for [section].
class SettingsFormScreen extends ConsumerWidget {
  const SettingsFormScreen({super.key, required this.section});

  final SettingsSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parlour = ref.watch(parlourProvider).value;
    if (parlour == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return switch (section) {
      SettingsSection.profile => _ProfileForm(parlour: parlour),
      SettingsSection.hours => _HoursForm(parlour: parlour),
      SettingsSection.billing => _BillingForm(parlour: parlour),
    };
  }
}

/// Shared layout: scrolling fields, a Save button, the discard prompt.
class _FormFrame extends StatelessWidget {
  const _FormFrame({
    required this.title,
    required this.formKey,
    required this.isDirty,
    required this.saving,
    required this.onSave,
    required this.children,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final bool isDirty;
  final bool saving;
  final VoidCallback onSave;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DiscardChangesScope(
      isDirty: isDirty && !saving,
      child: Scaffold(
        appBar: AppTopBar(title: title),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.sm,
              Space.xl,
              Space.xxl,
            ),
            children: children,
          ),
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
              label: context.l10n.commonSaveChanges,
              loading: saving,
              onPressed: onSave,
            ),
          ),
        ),
      ),
    );
  }
}

/// Saves [next] and closes the form, or shows the problem.
Future<void> _saveParlour(
  BuildContext context,
  WidgetRef ref,
  Parlour next,
  void Function(bool) setSaving,
) async {
  setSaving(true);
  try {
    await ref.read(settingsActionsProvider).saveParlour(next);
    if (!context.mounted) return;
    showMessage(context, context.l10n.settingsSaved);
    Navigator.of(context).pop();
  } on DomainException catch (e) {
    if (context.mounted) showMessage(context, context.errorText(e));
  } finally {
    if (context.mounted) setSaving(false);
  }
}

/// A full copy of [p] with any of the given fields replaced. Unlike
/// `copyWith`, optional text fields can be cleared (pass '').
Parlour _with(
  Parlour p, {
  String? name,
  String? ownerName,
  String? phone,
  String? area,
  String? address,
  List<int>? openDays,
  ClockTime? openTime,
  ClockTime? closeTime,
  int? slotMinutes,
  String? invoicePrefix,
  bool? taxEnabled,
  String? gstin,
  int? defaultTaxRateBp,
  bool? pricesIncludeTax,
  String? receiptFooter,
}) {
  String? opt(String? v, String? old) {
    if (v == null) return old;
    final t = v.trim();
    return t.isEmpty ? null : t;
  }

  return Parlour(
    id: p.id,
    name: name?.trim() ?? p.name,
    ownerName: ownerName?.trim() ?? p.ownerName,
    phone: phone?.trim() ?? p.phone,
    area: area?.trim() ?? p.area,
    address: opt(address, p.address),
    logoPath: p.logoPath,
    currency: p.currency,
    openDays: openDays ?? p.openDays,
    openTime: openTime ?? p.openTime,
    closeTime: closeTime ?? p.closeTime,
    slotMinutes: slotMinutes ?? p.slotMinutes,
    invoicePrefix: invoicePrefix?.trim().toUpperCase() ?? p.invoicePrefix,
    taxEnabled: taxEnabled ?? p.taxEnabled,
    defaultTaxRateBp: defaultTaxRateBp ?? p.defaultTaxRateBp,
    pricesIncludeTax: pricesIncludeTax ?? p.pricesIncludeTax,
    gstin: opt(gstin, p.gstin)?.toUpperCase(),
    receiptFooter: receiptFooter?.trim() ?? p.receiptFooter,
  );
}

/// [message] when [v] is empty.
String? _required(String? v, String message) =>
    (v == null || v.trim().isEmpty) ? message : null;

// ------------------------------------------------------------------ profile

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.parlour});

  final Parlour parlour;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final Parlour _p = widget.parlour;
  late final _name = TextEditingController(text: _p.name);
  late final _owner = TextEditingController(text: _p.ownerName);
  late final _phone = TextEditingController(text: _p.phone);
  late final _area = TextEditingController(text: _p.area);
  late final _address = TextEditingController(text: _p.address ?? '');
  bool _saving = false;

  List<TextEditingController> get _all => [
    _name,
    _owner,
    _phone,
    _area,
    _address,
  ];

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _dirty =>
      _name.text.trim() != _p.name ||
      _owner.text.trim() != _p.ownerName ||
      _phone.text.trim() != _p.phone ||
      _area.text.trim() != _p.area ||
      _address.text.trim() != (_p.address ?? '');

  void _save() {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    _saveParlour(
      context,
      ref,
      _with(
        _p,
        name: _name.text,
        ownerName: _owner.text,
        phone: _phone.text,
        area: _area.text,
        address: _address.text,
      ),
      (v) => setState(() => _saving = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _FormFrame(
      title: l10n.settingsProfile,
      formKey: _formKey,
      isDirty: _dirty,
      saving: _saving,
      onSave: _save,
      children: [
        AppTextField(
          label: l10n.settingsParlourName,
          isRequired: true,
          controller: _name,
          icon: Icons.storefront_outlined,
          textCapitalization: TextCapitalization.words,
          validator: (v) => _required(v, l10n.settingsEnterParlourName),
        ),
        Gap.h16,
        AppTextField(
          label: l10n.settingsOwnerName,
          isRequired: true,
          controller: _owner,
          icon: Icons.person_outline_rounded,
          textCapitalization: TextCapitalization.words,
          validator: (v) => _required(v, l10n.settingsEnterOwnerName),
        ),
        Gap.h16,
        AppTextField(
          label: l10n.settingsPhone,
          isRequired: true,
          controller: _phone,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) => _required(v, l10n.settingsEnterPhone),
        ),
        Gap.h16,
        AppTextField(
          label: l10n.settingsArea,
          isRequired: true,
          controller: _area,
          icon: Icons.place_outlined,
          hint: l10n.settingsAreaHint,
          textCapitalization: TextCapitalization.words,
          validator: (v) => _required(v, l10n.settingsEnterArea),
        ),
        Gap.h16,
        AppTextField(
          label: l10n.settingsAddress,
          controller: _address,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        Gap.h8,
        Text(l10n.settingsProfileNote, style: AppText.caption),
      ],
    );
  }
}

// -------------------------------------------------------------------- hours

class _HoursForm extends ConsumerStatefulWidget {
  const _HoursForm({required this.parlour});

  final Parlour parlour;

  @override
  ConsumerState<_HoursForm> createState() => _HoursFormState();
}

class _HoursFormState extends ConsumerState<_HoursForm> {
  final _formKey = GlobalKey<FormState>();
  late final Parlour _p = widget.parlour;
  late Set<int> _days = _p.openDays.toSet();
  late ClockTime _open = _p.openTime;
  late ClockTime _close = _p.closeTime;
  late int _slot = _p.slotMinutes;
  bool _saving = false;
  String? _error;

  bool get _dirty =>
      !(_days.length == _p.openDays.length && _days.containsAll(_p.openDays)) ||
      _open != _p.openTime ||
      _close != _p.closeTime ||
      _slot != _p.slotMinutes;

  Future<void> _pick({required bool open}) async {
    final current = open ? _open : _close;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (picked == null) return;
    setState(() {
      final t = ClockTime(picked.hour, picked.minute);
      if (open) {
        _open = t;
      } else {
        _close = t;
      }
    });
  }

  void _save() {
    final l10n = context.l10n;
    final error = _days.isEmpty
        ? l10n.settingsNoOpenDay
        : _close.compareTo(_open) <= 0
        ? l10n.settingsCloseBeforeOpen
        : null;
    setState(() => _error = error);
    if (_saving || error != null) return;
    _saveParlour(
      context,
      ref,
      _with(
        _p,
        openDays: _days.toList()..sort(),
        openTime: _open,
        closeTime: _close,
        slotMinutes: _slot,
      ),
      (v) => setState(() => _saving = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final day = DateTime(2024);
    return _FormFrame(
      title: l10n.settingsBusinessHours,
      formKey: _formKey,
      isDirty: _dirty,
      saving: _saving,
      onSave: _save,
      children: [
        FieldLabel(l10n.settingsOpenDays, required: true),
        Gap.h8,
        MultiChoiceChips<int>(
          options: [
            for (var d = 1; d <= 7; d++)
              ChoiceOption(d, Dates.weekdayShort(DateTime(2024, 1, d))),
          ],
          selected: _days,
          onChanged: (d) => setState(() => _days = d),
        ),
        Gap.h20,
        Row(
          children: [
            Expanded(
              child: PickerField(
                label: l10n.settingsOpens,
                isRequired: true,
                icon: Icons.schedule_rounded,
                hint: l10n.settingsOpeningTime,
                value: Dates.time(_open.on(day)),
                onTap: () => _pick(open: true),
              ),
            ),
            Gap.w12,
            Expanded(
              child: PickerField(
                label: l10n.settingsCloses,
                isRequired: true,
                icon: Icons.schedule_rounded,
                hint: l10n.settingsClosingTime,
                value: Dates.time(_close.on(day)),
                onTap: () => _pick(open: false),
              ),
            ),
          ],
        ),
        Gap.h20,
        FieldLabel(l10n.settingsBookingSlots, required: true),
        Gap.h8,
        ChoiceChips<int>(
          options: [
            for (final m in const [15, 30, 45, 60])
              ChoiceOption(m, l10n.commonMinutes(m)),
          ],
          selected: _slot,
          onSelected: (m) => setState(() => _slot = m),
        ),
        Gap.h8,
        Text(l10n.settingsSlotsNote, style: AppText.caption),
        if (_error != null) ...[
          Gap.h12,
          Text(
            _error!,
            style: AppText.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

// ------------------------------------------------------------------ billing

class _BillingForm extends ConsumerStatefulWidget {
  const _BillingForm({required this.parlour});

  final Parlour parlour;

  @override
  ConsumerState<_BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends ConsumerState<_BillingForm> {
  final _formKey = GlobalKey<FormState>();
  late final Parlour _p = widget.parlour;
  late final _prefix = TextEditingController(text: _p.invoicePrefix);
  late final _gstin = TextEditingController(text: _p.gstin ?? '');
  late final _footer = TextEditingController(text: _p.receiptFooter);
  late bool _tax = _p.taxEnabled;
  late bool _inclusive = _p.pricesIncludeTax;
  late int _rate = _p.defaultTaxRateBp;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_prefix, _gstin, _footer]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_prefix, _gstin, _footer]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _dirty =>
      _prefix.text.trim().toUpperCase() != _p.invoicePrefix ||
      _gstin.text.trim().toUpperCase() != (_p.gstin ?? '') ||
      _footer.text.trim() != _p.receiptFooter ||
      _tax != _p.taxEnabled ||
      _inclusive != _p.pricesIncludeTax ||
      _rate != _p.defaultTaxRateBp;

  void _save() {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    _saveParlour(
      context,
      ref,
      _with(
        _p,
        invoicePrefix: _prefix.text,
        taxEnabled: _tax,
        gstin: _gstin.text,
        defaultTaxRateBp: _rate,
        pricesIncludeTax: _inclusive,
        receiptFooter: _footer.text,
      ),
      (v) => setState(() => _saving = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prefix = _prefix.text.trim().isEmpty
        ? 'BBP'
        : _prefix.text.trim().toUpperCase();
    return _FormFrame(
      title: l10n.settingsBillingTax,
      formKey: _formKey,
      isDirty: _dirty,
      saving: _saving,
      onSave: _save,
      children: [
        AppTextField(
          label: l10n.settingsInvoicePrefix,
          isRequired: true,
          controller: _prefix,
          hint: l10n.settingsPrefixHint,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (v) => _required(v, l10n.settingsEnterPrefix),
        ),
        Gap.h4,
        Text(
          l10n.settingsNumberingNote('$prefix/2026-27/0001'),
          style: AppText.caption,
        ),
        Gap.h16,
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsChargeGst),
          subtitle: Text(l10n.settingsChargeGstHint),
          value: _tax,
          onChanged: (v) => setState(() => _tax = v),
        ),
        if (_tax) ...[
          AppTextField(
            label: l10n.settingsGstin,
            controller: _gstin,
            hint: l10n.settingsGstinHint,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [LengthLimitingTextInputFormatter(15)],
            validator: (v) {
              final t = v?.trim() ?? '';
              if (t.isEmpty) return null;
              return RegExp(r'^[0-9A-Za-z]{15}$').hasMatch(t)
                  ? null
                  : l10n.settingsGstinInvalid;
            },
          ),
          Gap.h4,
          Text(l10n.settingsGstinNote, style: AppText.caption),
          Gap.h16,
          FieldLabel(l10n.settingsDefaultGstRate, required: true),
          Gap.h8,
          ChoiceChips<int>(
            options: [
              for (final bp in const [500, 1200, 1800, 2800])
                ChoiceOption(bp, '${bp ~/ 100}%'),
            ],
            selected: _rate,
            onSelected: (bp) => setState(() => _rate = bp),
          ),
          Gap.h8,
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsPricesIncludeGst),
            subtitle: Text(l10n.settingsPricesIncludeGstHint),
            value: _inclusive,
            onChanged: (v) => setState(() => _inclusive = v),
          ),
        ],
        Gap.h16,
        AppTextField(
          label: l10n.settingsReceiptFooter,
          isRequired: true,
          controller: _footer,
          textCapitalization: TextCapitalization.sentences,
          validator: (v) => _required(v, l10n.settingsEnterFooter),
        ),
      ],
    );
  }
}
