import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/money_text.dart';
import '../../data/providers.dart';
import '../../domain/models/expense.dart';
import 'expenses_controller.dart';

/// S17 — Expenses for a month, grouped by date.
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  late DateTime _month = () {
    final now = ref.read(clockProvider)();
    return DateTime(now.year, now.month);
  }();

  void _shift(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));

  void _add() => context.push(Routes.newExpense);

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(monthExpensesProvider(_month));
    final list = expenses.value ?? const <Expense>[];
    final total = list.fold(0, (sum, e) => sum + e.amountPaise);
    final now = ref.watch(clockProvider)();
    final isCurrentMonth = _month.year == now.year && _month.month == now.month;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.expensesTitle,
        actions: [
          IconButton(
            tooltip: l10n.expensesAdd,
            onPressed: _add,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.expensesAdd,
        onPressed: _add,
        child: const Icon(Icons.add_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.xs,
          Space.screen,
          96,
        ),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.expensesPreviousMonth,
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  Dates.monthYear(_month),
                  textAlign: TextAlign.center,
                  style: AppText.sectionTitle,
                ),
              ),
              IconButton(
                tooltip: l10n.expensesNextMonth,
                onPressed: isCurrentMonth ? null : () => _shift(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          Gap.h8,
          Container(
            padding: const EdgeInsets.all(Space.lg),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: Radii.cardAll,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.expensesTotalSpent,
                    style: AppText.body.copyWith(color: Colors.white),
                  ),
                ),
                Text(
                  Money.format(total),
                  style: AppText.bigNumber.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Gap.h16,
          if (expenses.isLoading && !expenses.hasValue)
            const Center(child: CircularProgressIndicator())
          else if (list.isEmpty)
            EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              message: l10n.expensesEmpty,
              actionLabel: l10n.expensesAdd,
              onAction: _add,
            )
          else
            for (final (day, items) in groupByDay(list)) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.xs,
                  Space.sm,
                  0,
                  Space.sm,
                ),
                child: Text(Dates.weekdayDayMonth(day), style: AppText.label),
              ),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0)
                        const Divider(indent: Space.lg, endIndent: Space.lg),
                      _ExpenseRow(expense: items[i]),
                    ],
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final e = expense;
    return InkWell(
      onTap: () => context.push(Routes.editExpense(e.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: Space.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.builtIn(e.category), style: AppText.bodyStrong),
                  Text(
                    [
                      if (e.method case final m?) l10n.paymentMethod(m),
                      ?e.note,
                    ].join(' · '),
                    style: AppText.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            MoneyText(e.amountPaise),
          ],
        ),
      ),
    );
  }
}
