import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
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
import '../../core/widgets/picker_field.dart';
import '../../domain/errors.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/payment.dart';
import '../billing/payment_method_ui.dart';
import 'expenses_controller.dart';

/// S17 form — add or edit an expense. [expenseId] null means "add".
class ExpenseFormScreen extends ConsumerWidget {
  const ExpenseFormScreen({super.key, this.expenseId});

  final String? expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = expenseId;
    if (id == null) return const _ExpenseForm();
    final expense = ref.watch(expenseByIdProvider(id));
    if (expense.value != null) return _ExpenseForm(initial: expense.value);
    return Scaffold(
      appBar: AppTopBar(title: context.l10n.expensesExpense),
      body: Center(
        child: expense.isLoading
            ? const CircularProgressIndicator()
            : EmptyState(
                icon: Icons.account_balance_wallet_outlined,
                message: context.l10n.expensesNotFound,
              ),
      ),
    );
  }
}

class _ExpenseForm extends ConsumerStatefulWidget {
  const _ExpenseForm({this.initial});

  final Expense? initial;

  @override
  ConsumerState<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<_ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final Expense? _e = widget.initial;
  late final _amount = TextEditingController(
    text: _e == null
        ? ''
        : Money.format(_e.amountPaise).replaceAll('₹', '').replaceAll(',', ''),
  );
  late final _note = TextEditingController(text: _e?.note ?? '');
  late String? _category = _e?.category;
  late DateTime _date =
      _e?.spentOn ??
      DateRange.startOfDay(ref.read(expenseActionsProvider).now());
  late PaymentMethod? _method = _e == null ? PaymentMethod.cash : _e.method;
  bool _saving = false;
  bool _submitted = false;

  bool get _isEdit => _e != null;

  bool get _isDirty =>
      (_isEdit
          ? Money.parseRupees(_amount.text) != _e!.amountPaise
          : _amount.text.trim().isNotEmpty) ||
      _category != _e?.category ||
      _note.text.trim() != (_e?.note ?? '') ||
      (_isEdit && (_date != _e!.spentOn || _method != _e.method));

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
    _note.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateRange.startOfDay(ref.read(expenseActionsProvider).now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(today.year - 2),
      lastDate: today,
    );
    if (picked != null) setState(() => _date = DateRange.startOfDay(picked));
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false) || _category == null) {
      return;
    }
    setState(() => _saving = true);
    final actions = ref.read(expenseActionsProvider);
    final note = _note.text.trim();
    try {
      await actions.save(
        Expense(
          id: _e?.id ?? actions.newId(),
          parlourId: _e?.parlourId ?? '',
          category: _category!,
          amountPaise: Money.parseRupees(_amount.text)!,
          spentOn: _date,
          method: _method,
          note: note.isEmpty ? null : note,
        ),
      );
      if (!mounted) return;
      showMessage(
        context,
        _isEdit ? context.l10n.expensesUpdated : context.l10n.expensesAdded,
      );
      Navigator.of(context).pop();
    } on DomainException catch (e) {
      if (mounted) showMessage(context, context.errorText(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final ok = await ConfirmDialog.show(
      context,
      title: l10n.expensesDeleteTitle,
      message: l10n.expensesDeleteMessage(
        l10n.builtIn(_e!.category),
        Money.format(_e.amountPaise),
      ),
      confirmLabel: l10n.commonDelete,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(expenseActionsProvider).delete(_e.id);
    if (!mounted) return;
    showMessage(context, context.l10n.expensesDeleted);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DiscardChangesScope(
      isDirty: _isDirty && !_saving,
      child: Scaffold(
        appBar: AppTopBar(
          title: _isEdit ? l10n.expensesEdit : l10n.expensesAdd,
          actions: [
            if (_isEdit)
              IconButton(
                tooltip: l10n.expensesDelete,
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
          ],
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
              FieldLabel(l10n.expensesAmount, required: true),
              Gap.h8,
              TextFormField(
                controller: _amount,
                autofocus: !_isEdit,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                style: AppText.bigNumber.copyWith(fontSize: 28),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: AppText.bigNumber.copyWith(
                    fontSize: 28,
                    color: AppColors.textMuted,
                  ),
                  hintText: '0',
                ),
                validator: (v) {
                  final paise = Money.parseRupees(v ?? '');
                  if (paise == null) return l10n.expensesEnterAmount;
                  if (paise <= 0) return l10n.errAmountZero;
                  return null;
                },
              ),
              Gap.h20,
              FieldLabel(l10n.expensesCategory, required: true),
              Gap.h8,
              ChoiceChips<String>(
                options: [
                  for (final c in expenseCategories)
                    ChoiceOption(c, l10n.builtIn(c)),
                  if (_category != null &&
                      !expenseCategories.contains(_category))
                    ChoiceOption(_category!, _category!),
                ],
                selected: _category,
                onSelected: (c) => setState(() => _category = c),
              ),
              if (_submitted && _category == null)
                Padding(
                  padding: const EdgeInsets.only(top: Space.xs),
                  child: Text(
                    l10n.errCategoryRequired,
                    style: AppText.caption.copyWith(color: AppColors.error),
                  ),
                ),
              Gap.h20,
              PickerField(
                label: l10n.expensesDate,
                isRequired: true,
                icon: Icons.calendar_today_outlined,
                hint: l10n.expensesChooseDate,
                value: Dates.weekdayDayMonthYear(_date),
                onTap: _pickDate,
              ),
              Gap.h20,
              FieldLabel(l10n.expensesPaidBy),
              Gap.h8,
              ChoiceChips<PaymentMethod>(
                options: [
                  for (final m in PaymentMethod.values)
                    ChoiceOption(m, l10n.paymentMethod(m), icon: m.icon),
                ],
                selected: _method,
                onSelected: (m) => setState(() => _method = m),
              ),
              Gap.h20,
              AppTextField(
                label: l10n.expensesNote,
                controller: _note,
                hint: l10n.expensesNoteHint,
                textCapitalization: TextCapitalization.sentences,
              ),
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
              label: l10n.expensesSave,
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }
}
