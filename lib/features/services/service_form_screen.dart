import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/money.dart';
import '../../core/l10n/l10n.dart';
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
      title: context.l10n.servicesNewCategory,
      confirmLabel: context.l10n.commonAdd,
      hint: context.l10n.servicesNewCategoryHint,
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
    final l10n = context.l10n;
    final chipError = _category == null
        ? l10n.errCategoryRequired
        : (_minutes == null || _minutes! <= 0)
        ? l10n.errServiceDurationRequired
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
      showMessage(context, _isEdit ? l10n.servicesUpdated : l10n.servicesAdded);
      Navigator.of(context).pop();
    } on DomainException catch (e) {
      if (mounted) showMessage(context, context.errorText(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggleActive() async {
    final s = widget.initial!;
    final l10n = context.l10n;
    if (s.isActive) {
      final ok = await ConfirmDialog.show(
        context,
        title: l10n.servicesDeactivateTitle(s.name),
        message: l10n.servicesDeactivateMessage,
        confirmLabel: l10n.commonDeactivate,
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
      s.isActive ? l10n.servicesDeactivated : l10n.servicesReactivated,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DiscardChangesScope(
      isDirty: _isDirty && !_saving,
      child: Scaffold(
        appBar: AppTopBar(
          title: _isEdit ? l10n.servicesEdit : l10n.servicesAdd,
        ),
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
                label: l10n.servicesFieldName,
                isRequired: true,
                controller: _name,
                hint: l10n.servicesNameHint,
                textCapitalization: TextCapitalization.words,
                autofocus: !_isEdit,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.errServiceNameRequired
                    : null,
              ),
              Gap.h16,
              FieldLabel(l10n.servicesCategory, required: true),
              Gap.h8,
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  ChoiceChips<String>(
                    options: [
                      for (final c in _categories)
                        ChoiceOption(c, l10n.builtIn(c)),
                    ],
                    selected: _category,
                    onSelected: (c) => setState(() => _category = c),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.servicesNewCategory),
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
                label: l10n.servicesPrice,
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
                    ? l10n.servicesPriceInvalid
                    : null,
              ),
              Gap.h16,
              FieldLabel(l10n.servicesDuration, required: true),
              Gap.h8,
              ChoiceChips<int>(
                options: [
                  for (final m in _durationChoices)
                    ChoiceOption(m, l10n.duration(m)),
                  ChoiceOption(-1, l10n.servicesCustomDuration),
                ],
                selected: _duration,
                onSelected: (m) => setState(() => _duration = m),
              ),
              if (_duration == -1) ...[
                Gap.h12,
                AppTextField(
                  label: l10n.servicesMinutes,
                  isRequired: true,
                  controller: _customMinutes,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hint: l10n.servicesMinutesHint,
                  validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0
                      ? l10n.servicesMinutesRequired
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
                    label: l10n.servicesDescription,
                    controller: _description,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel(l10n.servicesGstRate),
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
                      Text(l10n.servicesGstNote, style: AppText.caption),
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
                          ? l10n.servicesDeactivate
                          : l10n.servicesReactivate,
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
              label: l10n.servicesSave,
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: context.l10n.servicesService),
      body: Center(
        child: EmptyState(
          icon: Icons.content_cut_rounded,
          message: error == null
              ? context.l10n.servicesNotFound
              : context.l10n.servicesLoadOneError('$error'),
        ),
      ),
    );
  }
}
