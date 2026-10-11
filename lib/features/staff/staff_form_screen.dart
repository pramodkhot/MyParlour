import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/phone.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/discard_changes_scope.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/field_label.dart';
import '../../core/widgets/picker_field.dart';
import '../../domain/errors.dart';
import '../../domain/models/staff.dart';
import '../../domain/models/value_types.dart';
import 'staff_controller.dart';

/// S12 form — add or edit a staff member. [staffId] null means "add".
class StaffFormScreen extends ConsumerWidget {
  const StaffFormScreen({super.key, this.staffId});

  final String? staffId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(staffFormDataProvider);
    final id = staffId;
    final existing = id == null ? null : ref.watch(staffDetailProvider(id));
    if (form is AsyncError || existing is AsyncError) {
      return _Message(context.l10n.staffFormLoadError);
    }
    if (!form.hasValue || (existing != null && !existing.hasValue)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (existing != null && existing.value == null) {
      return _Message(context.l10n.staffNotFound);
    }
    return _StaffForm(data: form.value!, initial: existing?.value?.staff);
  }
}

class _StaffForm extends ConsumerStatefulWidget {
  const _StaffForm({required this.data, this.initial});

  final StaffFormData data;
  final Staff? initial;

  @override
  ConsumerState<_StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends ConsumerState<_StaffForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late final String _initialPhone = widget.initial == null
      ? ''
      : PhoneNumber.display(widget.initial!.phone);
  late final _phone = TextEditingController(text: _initialPhone);

  late String _role = widget.initial?.roleTitle ?? 'Beautician';
  late Set<String> _services =
      widget.initial?.serviceIds.toSet() ??
      {for (final s in widget.data.services) s.id};
  late Set<int> _days =
      (widget.initial?.workingDays ?? widget.data.parlour.openDays).toSet();
  late ClockTime _start =
      widget.initial?.startTime ?? widget.data.parlour.openTime;
  late ClockTime _end =
      widget.initial?.endTime ?? widget.data.parlour.closeTime;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.initial != null;

  bool get _isDirty {
    final s = widget.initial;
    final p = widget.data.parlour;
    return _name.text.trim() != (s?.name ?? '') ||
        _phone.text.trim() != _initialPhone ||
        _role != (s?.roleTitle ?? 'Beautician') ||
        !_sameSet(
          _services,
          s?.serviceIds.toSet() ?? {for (final x in widget.data.services) x.id},
        ) ||
        !_sameSet(_days, (s?.workingDays ?? p.openDays).toSet()) ||
        _start != (s?.startTime ?? p.openTime) ||
        _end != (s?.endTime ?? p.closeTime);
  }

  static bool _sameSet<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
    _phone.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool start}) async {
    final current = start ? _start : _end;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (picked == null) return;
    setState(() {
      final value = ClockTime(picked.hour, picked.minute);
      if (start) {
        _start = value;
      } else {
        _end = value;
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final fieldsOk = _formKey.currentState?.validate() ?? false;
    final l10n = context.l10n;
    final error = _days.isEmpty
        ? l10n.staffNoWorkingDay
        : _end.compareTo(_start) <= 0
        ? l10n.errAppointmentEndBeforeStart
        : null;
    setState(() => _error = error);
    if (!fieldsOk || error != null) return;

    setState(() => _saving = true);
    final actions = ref.read(staffActionsProvider);
    final old = widget.initial;
    try {
      await actions.save(
        Staff(
          id: old?.id ?? actions.newId(),
          parlourId: old?.parlourId ?? '',
          name: _name.text.trim(),
          phone: PhoneNumber.display(_phone.text),
          roleTitle: _role,
          serviceIds: [
            for (final s in widget.data.services)
              if (_services.contains(s.id)) s.id,
            // Keep inactive services that were already assigned.
            ...?old?.serviceIds.where(
              (id) => !widget.data.services.any((s) => s.id == id),
            ),
          ],
          workingDays: _days.toList()..sort(),
          startTime: _start,
          endTime: _end,
          isActive: old?.isActive ?? true,
        ),
      );
      if (!mounted) return;
      showMessage(context, _isEdit ? l10n.staffUpdated : l10n.staffAdded);
      Navigator.of(context).pop();
    } on DomainException catch (e) {
      if (mounted) showMessage(context, context.errorText(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.data.services;
    final l10n = context.l10n;
    final day = widget.data.parlour.openTime.on(DateTime(2024));
    final allTicked = services.every((s) => _services.contains(s.id));

    return DiscardChangesScope(
      isDirty: _isDirty && !_saving,
      child: Scaffold(
        appBar: AppTopBar(title: _isEdit ? l10n.staffEdit : l10n.staffAdd),
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
                label: l10n.staffFieldName,
                isRequired: true,
                controller: _name,
                icon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                autofocus: !_isEdit,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.errStaffNameRequired
                    : null,
              ),
              Gap.h16,
              AppTextField(
                label: l10n.staffFieldMobile,
                isRequired: true,
                controller: _phone,
                icon: Icons.phone_outlined,
                prefixText: '+91 ',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (v) => PhoneNumber.isValidMobile(v ?? '')
                    ? null
                    : l10n.staffMobileInvalid,
              ),
              Gap.h16,
              FieldLabel(l10n.staffRole),
              Gap.h8,
              ChoiceChips<String>(
                options: [
                  for (final r in staffRoles) ChoiceOption(r, l10n.builtIn(r)),
                ],
                selected: _role,
                onSelected: (r) => setState(() => _role = r),
              ),
              Gap.h20,
              Row(
                children: [
                  Expanded(child: FieldLabel(l10n.staffServicesTheyDo)),
                  TextButton(
                    onPressed: () => setState(
                      () => _services = allTicked
                          ? {}
                          : {for (final s in services) s.id},
                    ),
                    child: Text(
                      allTicked ? l10n.staffClearAll : l10n.staffTickAll,
                    ),
                  ),
                ],
              ),
              AppCard(
                padding: EdgeInsets.zero,
                showShadow: false,
                child: Column(
                  children: [
                    for (final s in services)
                      CheckboxListTile(
                        value: _services.contains(s.id),
                        onChanged: (v) => setState(() {
                          if (v ?? false) {
                            _services.add(s.id);
                          } else {
                            _services.remove(s.id);
                          }
                        }),
                        title: Text(s.name, style: AppText.body),
                        subtitle: Text(
                          l10n.builtIn(s.category),
                          style: AppText.caption,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      ),
                  ],
                ),
              ),
              Gap.h20,
              FieldLabel(l10n.staffWorkingDays, required: true),
              Gap.h8,
              MultiChoiceChips<int>(
                options: [
                  for (var d = 1; d <= 7; d++)
                    ChoiceOption(d, Dates.weekdayShort(DateTime(2024, 1, d))),
                ],
                selected: _days,
                onChanged: (d) => setState(() => _days = d),
              ),
              Gap.h16,
              Row(
                children: [
                  Expanded(
                    child: PickerField(
                      label: l10n.staffStarts,
                      isRequired: true,
                      icon: Icons.schedule_rounded,
                      hint: l10n.staffStartHint,
                      value: Dates.time(_start.on(day)),
                      onTap: () => _pickTime(start: true),
                    ),
                  ),
                  Gap.w12,
                  Expanded(
                    child: PickerField(
                      label: l10n.staffEnds,
                      isRequired: true,
                      icon: Icons.schedule_rounded,
                      hint: l10n.staffEndHint,
                      value: Dates.time(_end.on(day)),
                      onTap: () => _pickTime(start: false),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                Gap.h8,
                Text(
                  _error!,
                  style: AppText.caption.copyWith(color: AppColors.error),
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
              label: _isEdit ? l10n.commonSaveChanges : l10n.staffSave,
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: context.l10n.staffTitle),
      body: Center(
        child: EmptyState(icon: Icons.badge_outlined, message: message),
      ),
    );
  }
}
