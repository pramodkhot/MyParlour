import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/phone.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/day_month_picker.dart';
import '../../core/widgets/discard_changes_scope.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/more_details.dart';
import '../../core/widgets/picker_field.dart';
import '../../domain/errors.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/value_types.dart';
import 'customers_controller.dart';

/// S8 — Add or edit a customer. [customerId] null means "add".
class CustomerFormScreen extends ConsumerWidget {
  const CustomerFormScreen({super.key, this.customerId});

  final String? customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = customerId;
    if (id == null) return const CustomerForm();
    return switch (ref.watch(customerDetailProvider(id))) {
      AsyncValue(:final value?) => CustomerForm(initial: value.customer),
      AsyncValue(hasValue: true) => const _NotFound(),
      AsyncValue(:final error?) => _NotFound(error: error),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

/// The form itself. Pops with the saved [Customer]. When [asSheet] is
/// true it is shown inside a bottom sheet (from New appointment) and has
/// no "Save & book" button.
class CustomerForm extends ConsumerStatefulWidget {
  const CustomerForm({super.key, this.initial, this.asSheet = false});

  final Customer? initial;
  final bool asSheet;

  @override
  ConsumerState<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends ConsumerState<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late final String _initialPhone = widget.initial == null
      ? ''
      : PhoneNumber.display(widget.initial!.phone);
  late final _phone = TextEditingController(text: _initialPhone);
  late final _email = TextEditingController(text: widget.initial?.email ?? '');
  late final _notes = TextEditingController(text: widget.initial?.notes ?? '');
  late DayMonth? _birthday = widget.initial?.birthday;
  late DayMonth? _anniversary = widget.initial?.anniversary;

  Customer? _duplicate;
  Timer? _debounce;
  bool _saving = false;

  bool get _isEdit => widget.initial != null;

  bool get _isDirty {
    final c = widget.initial;
    return _name.text.trim() != (c?.name ?? '') ||
        _phone.text.trim() != _initialPhone ||
        _email.text.trim() != (c?.email ?? '') ||
        _notes.text.trim() != (c?.notes ?? '') ||
        _birthday != c?.birthday ||
        _anniversary != c?.anniversary;
  }

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _email, _notes]) {
      c.addListener(_changed);
    }
    _phone.addListener(_phoneChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in [_name, _phone, _email, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  void _changed() => setState(() {});

  void _phoneChanged() {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _checkDuplicate);
  }

  Future<void> _checkDuplicate() async {
    final text = _phone.text;
    final duplicate = PhoneNumber.normalise(text) == null
        ? null
        : await ref
              .read(customerActionsProvider)
              .findDuplicate(text, excludeId: widget.initial?.id);
    if (mounted && text == _phone.text) setState(() => _duplicate = duplicate);
  }

  Future<void> _pickBirthday() async {
    final picked = await showDayMonthPicker(
      context,
      title: 'Birthday',
      initial: _birthday,
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _pickAnniversary() async {
    final picked = await showDayMonthPicker(
      context,
      title: 'Anniversary',
      initial: _anniversary,
    );
    if (picked != null) setState(() => _anniversary = picked);
  }

  Future<void> _save({bool thenBook = false}) async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final actions = ref.read(customerActionsProvider);
    final old = widget.initial;
    String? blank(String s) => s.trim().isEmpty ? null : s.trim();
    try {
      final saved = await actions.save(
        Customer(
          id: old?.id ?? actions.newId(),
          parlourId: old?.parlourId ?? '',
          name: _name.text.trim(),
          phone: PhoneNumber.display(_phone.text),
          email: blank(_email.text),
          birthday: _birthday,
          anniversary: _anniversary,
          notes: blank(_notes.text),
          isActive: old?.isActive ?? true,
          createdAt: old?.createdAt ?? actions.now(),
          lastVisitAt: old?.lastVisitAt,
        ),
      );
      if (!mounted) return;
      showMessage(context, _isEdit ? 'Customer updated' : 'Customer saved');
      if (thenBook) {
        context.go(Routes.appointments);
      } else {
        Navigator.of(context).pop(saved);
      }
    } on DomainException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
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
            label: 'Name',
            isRequired: true,
            controller: _name,
            icon: Icons.person_outline_rounded,
            hint: 'e.g. Priya Sharma',
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofocus: !_isEdit,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Enter the customer’s name.'
                : null,
          ),
          Gap.h16,
          AppTextField(
            label: 'Mobile number',
            isRequired: true,
            controller: _phone,
            icon: Icons.phone_outlined,
            prefixText: '+91 ',
            hint: '98765 43210',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Enter the mobile number.';
              }
              if (!PhoneNumber.isValidMobile(v)) {
                return 'Enter a 10-digit mobile number.';
              }
              return null;
            },
          ),
          if (_duplicate != null) ...[
            Gap.h8,
            _DuplicateBanner(
              customer: _duplicate!,
              onOpen: () => context.push(Routes.customer(_duplicate!.id)),
            ),
          ],
          Gap.h16,
          PickerField(
            label: 'Birthday',
            icon: Icons.cake_outlined,
            hint: 'Day and month',
            value: _birthday == null ? null : formatDayMonth(_birthday!),
            onTap: _pickBirthday,
            onClear: () => setState(() => _birthday = null),
          ),
          Gap.h16,
          AppTextField(
            label: 'Notes',
            controller: _notes,
            hint: 'e.g. Prefers less heat in smoothening',
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          Gap.h8,
          MoreDetails(
            initiallyOpen:
                widget.initial?.email != null ||
                widget.initial?.anniversary != null,
            children: [
              AppTextField(
                label: 'Email',
                controller: _email,
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return null;
                  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
                      ? null
                      : 'Enter a valid email address.';
                },
              ),
              PickerField(
                label: 'Anniversary',
                icon: Icons.favorite_border_rounded,
                hint: 'Day and month',
                value: _anniversary == null
                    ? null
                    : formatDayMonth(_anniversary!),
                onTap: _pickAnniversary,
                onClear: () => setState(() => _anniversary = null),
              ),
            ],
          ),
        ],
      ),
    );

    final buttons = Padding(
      padding: const EdgeInsets.fromLTRB(
        Space.xl,
        Space.sm,
        Space.xl,
        Space.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: 'Save customer',
            loading: _saving,
            onPressed: _save,
          ),
          if (!widget.asSheet && !_isEdit) ...[
            Gap.h12,
            SecondaryButton(
              label: 'Save & book appointment',
              onPressed: _saving ? null : () => _save(thenBook: true),
            ),
          ],
        ],
      ),
    );

    return DiscardChangesScope(
      isDirty: _isDirty && !_saving,
      child: Scaffold(
        appBar: AppTopBar(title: _isEdit ? 'Edit customer' : 'Add customer'),
        body: form,
        bottomNavigationBar: SafeArea(child: buttons),
      ),
    );
  }
}

class _DuplicateBanner extends StatelessWidget {
  const _DuplicateBanner({required this.customer, required this.onOpen});

  final Customer customer;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: Space.md),
      decoration: const BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: Radii.controlAll,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warning,
            size: 20,
          ),
          Gap.w8,
          Expanded(
            child: Text(
              'Already saved as ${customer.name}',
              style: AppText.body.copyWith(
                color: AppColors.warning,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: onOpen,
            style: TextButton.styleFrom(foregroundColor: AppColors.warning),
            child: const Text('Open'),
          ),
        ],
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
      appBar: const AppTopBar(title: 'Customer'),
      body: Center(
        child: EmptyState(
          icon: Icons.person_off_outlined,
          message: error == null
              ? 'This customer no longer exists.'
              : 'Could not load this customer. $error',
        ),
      ),
    );
  }
}
