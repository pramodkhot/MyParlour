import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/money.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/discard_changes_scope.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/field_label.dart';
import '../../core/widgets/more_details.dart';
import '../../core/widgets/text_prompt.dart';
import '../../domain/errors.dart';
import '../../domain/models/service_item.dart';
import 'services_controller.dart';

const _durationChoices = [15, 30, 45, 60, 90, 120];
const _gstChoices = [0, 500, 1200, 1800, 2800];

/// S16 form — add or edit a service. [serviceId] null means "add".
class ServiceFormScreen extends ConsumerWidget {
  const ServiceFormScreen({super.key, this.serviceId});

  final String? serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(allServicesProvider);
    final id = serviceId;
    return switch (all) {
      AsyncValue(:final value?) =>
        id != null && !value.any((s) => s.id == id)
            ? const _NotFound()
            : _ServiceForm(
                initial: id == null
                    ? null
                    : value.firstWhere((s) => s.id == id),
                categories: serviceCategories(value),
              ),
      AsyncValue(:final error?) => _NotFound(error: error),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _ServiceForm extends ConsumerStatefulWidget {
  const _ServiceForm({required this.initial, required this.categories});

  final ServiceItem? initial;
  final List<String> categories;

  @override
  ConsumerState<_ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends ConsumerState<_ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late final _price = TextEditingController(
    text: widget.initial == null
        ? ''
        : Money.format(
            widget.initial!.pricePaise,
          ).replaceAll('₹', '').replaceAll(',', ''),
  );
  late final _description = TextEditingController(
    text: widget.initial?.description ?? '',
  );
  late final _customMinutes = TextEditingController(
    text: _isCustom(widget.initial?.durationMin)
        ? '${widget.initial!.durationMin}'
        : '',
  );
  late final List<String> _categories = [...widget.categories];
  late String? _category = widget.initial?.category;
  late int? _duration = widget.initial == null
      ? null
      : (_isCustom(widget.initial!.durationMin)
            ? -1
            : widget.initial!.durationMin);
  late int? _taxRateBp = widget.initial?.taxRateBp;
  late int? _initialTaxRateBp = widget.initial?.taxRateBp;
  bool _saving = false;
  String? _chipError;

  static bool _isCustom(int? minutes) =>
      minutes != null && !_durationChoices.contains(minutes);

  bool get _isEdit => widget.initial != null;

  int? get _minutes =>
      _duration == -1 ? int.tryParse(_customMinutes.text.trim()) : _duration;

  bool get _isDirty {
    final s = widget.initial;
    return _name.text.trim() != (s?.name ?? '') ||
        Money.parseRupees(_price.text) != s?.pricePaise ||
        _category != s?.category ||
        _minutes != s?.durationMin ||
        _description.text.trim() != (s?.description ?? '') ||
        _taxRateBp != _initialTaxRateBp;
  }

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _price, _description, _customMinutes]) {
      c.addListener(() => setState(() {}));
    }
    if (_taxRateBp == null) {
      ref.read(serviceActionsProvider).defaultTaxRateBp().then((bp) {
        if (mounted && _taxRateBp == null) {
          setState(() => _taxRateBp = _initialTaxRateBp = bp);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _price, _description, _customMinutes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addCategory() async {
    final name = await showTextPrompt(
      context,
      title: 'New category',
      confirmLabel: 'Add',
      hint: 'e.g. Bridal',
    );
    if (name == null || !mounted) return;
    setState(() {
      if (!_categories.contains(name)) _categories.add(name);
      _category = name;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final fieldsOk = _formKey.currentState?.validate() ?? false;
    final chipError = _category == null
        ? 'Choose a category.'
        : (_minutes == null || _minutes! <= 0)
        ? 'Choose how long the service takes.'
        : null;
    setState(() => _chipError = chipError);
    if (!fieldsOk || chipError != null) return;

    setState(() => _saving = true);
    final actions = ref.read(serviceActionsProvider);
    final old = widget.initial;
    try {
      await actions.save(
        ServiceItem(
          id: old?.id ?? actions.newId(),
          parlourId: old?.parlourId ?? '',
          name: _name.text.trim(),
          category: _category!,
          pricePaise: Money.parseRupees(_price.text)!,
          durationMin: _minutes!,
          taxRateBp: _taxRateBp ?? 1800,
          description: _description.text.trim().isEmpty
              ? null
              : _description.text.trim(),
          isActive: old?.isActive ?? true,
        ),
      );
      if (!mounted) return;
      showMessage(context, _isEdit ? 'Service updated' : 'Service added');
      Navigator.of(context).pop();
    } on DomainException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggleActive() async {
    final s = widget.initial!;
    if (s.isActive) {
      final ok = await ConfirmDialog.show(
        context,
        title: 'Deactivate ${s.name}?',
        message:
            'It will no longer be offered for new bookings or bills. '
            'Past appointments and bills keep it.',
        confirmLabel: 'Deactivate',
        destructive: true,
      );
      if (!ok) return;
    }
    await ref
        .read(serviceActionsProvider)
        .setActive(s.id, isActive: !s.isActive);
    if (!mounted) return;
    showMessage(
      context,
      s.isActive ? 'Service deactivated' : 'Service reactivated',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DiscardChangesScope(
      isDirty: _isDirty && !_saving,
      child: Scaffold(
        appBar: AppTopBar(title: _isEdit ? 'Edit service' : 'Add service'),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.sm,
              Space.xl,
              Space.xxl,
            ),
            children: [
              AppTextField(
                label: 'Service name',
                isRequired: true,
                controller: _name,
                hint: 'e.g. Haircut',
                textCapitalization: TextCapitalization.words,
                autofocus: !_isEdit,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter the service name.'
                    : null,
              ),
              Gap.h16,
              const FieldLabel('Category', required: true),
              Gap.h8,
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  ChoiceChips<String>(
                    options: [for (final c in _categories) ChoiceOption(c, c)],
                    selected: _category,
                    onSelected: (c) => setState(() => _category = c),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New category'),
                    labelStyle: AppText.chip.copyWith(color: AppColors.primary),
                    onPressed: _addCategory,
                    shape: const StadiumBorder(
                      side: BorderSide(color: AppColors.border),
                    ),
                    backgroundColor: AppColors.surface,
                  ),
                ],
              ),
              Gap.h16,
              AppTextField(
                label: 'Price',
                isRequired: true,
                controller: _price,
                prefixText: '₹ ',
                hint: '500',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (v) => Money.parseRupees(v ?? '') == null
                    ? 'Enter the price in rupees.'
                    : null,
              ),
              Gap.h16,
              const FieldLabel('Duration', required: true),
              Gap.h8,
              ChoiceChips<int>(
                options: [
                  for (final m in _durationChoices)
                    ChoiceOption(m, m < 60 ? '$m min' : _hours(m)),
                  const ChoiceOption(-1, 'Custom'),
                ],
                selected: _duration,
                onSelected: (m) => setState(() => _duration = m),
              ),
              if (_duration == -1) ...[
                Gap.h12,
                AppTextField(
                  label: 'Minutes',
                  isRequired: true,
                  controller: _customMinutes,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hint: 'e.g. 75',
                  validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0
                      ? 'Enter the minutes.'
                      : null,
                ),
              ],
              if (_chipError != null) ...[
                Gap.h8,
                Text(
                  _chipError!,
                  style: AppText.caption.copyWith(color: AppColors.error),
                ),
              ],
              Gap.h8,
              MoreDetails(
                initiallyOpen: widget.initial?.description != null,
                children: [
                  AppTextField(
                    label: 'Description',
                    controller: _description,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('GST rate'),
                      Gap.h8,
                      ChoiceChips<int>(
                        options: [
                          for (final bp in _gstChoices)
                            ChoiceOption(bp, '${bp ~/ 100}%'),
                        ],
                        selected: _taxRateBp,
                        onSelected: (bp) => setState(() => _taxRateBp = bp),
                      ),
                      Gap.h4,
                      const Text(
                        'Used only when GST is turned on in Settings.',
                        style: AppText.caption,
                      ),
                    ],
                  ),
                ],
              ),
              if (_isEdit) ...[
                Gap.h24,
                Center(
                  child: TextButton.icon(
                    onPressed: _toggleActive,
                    style: TextButton.styleFrom(
                      foregroundColor: widget.initial!.isActive
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                    icon: Icon(
                      widget.initial!.isActive
                          ? Icons.block_rounded
                          : Icons.check_circle_outline_rounded,
                    ),
                    label: Text(
                      widget.initial!.isActive
                          ? 'Deactivate service'
                          : 'Reactivate service',
                    ),
                  ),
                ),
              ],
            ],
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
              label: 'Save service',
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }

  static String _hours(int m) =>
      m % 60 == 0 ? '${m ~/ 60} h' : '${m ~/ 60} h ${m % 60}';
}

class _NotFound extends StatelessWidget {
  const _NotFound({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Service'),
      body: Center(
        child: EmptyState(
          icon: Icons.content_cut_rounded,
          message: error == null
              ? 'This service no longer exists.'
              : 'Could not load this service. $error',
        ),
      ),
    );
  }
}
