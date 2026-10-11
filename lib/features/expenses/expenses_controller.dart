import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/expense.dart';

const expenseCategories = [
  'Rent',
  'Salary',
  'Products',
  'Electricity',
  'Tea/Snacks',
  'Other',
];

/// Expenses in the calendar month starting [monthStart], newest first.
final monthExpensesProvider = FutureProvider.autoDispose
    .family<List<Expense>, DateTime>((ref, monthStart) async {
      ref.watch(dataVersionProvider);
      return ref
          .watch(expenseRepositoryProvider)
          .listInRange(
            DateRange(
              monthStart,
              DateTime(monthStart.year, monthStart.month + 1),
            ),
          );
    });

/// [expenses] grouped by day, newest day first.
List<(DateTime, List<Expense>)> groupByDay(List<Expense> expenses) {
  final byDay = <DateTime, List<Expense>>{};
  for (final e in expenses) {
    byDay.putIfAbsent(DateRange.startOfDay(e.spentOn), () => []).add(e);
  }
  final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
  return [for (final d in days) (d, byDay[d]!)];
}

/// One expense by id (for editing).
final expenseByIdProvider = FutureProvider.autoDispose.family<Expense?, String>(
  (ref, id) => ref.watch(expenseRepositoryProvider).getById(id),
);

class ExpenseActions {
  ExpenseActions(this._ref);

  final Ref _ref;

  String newId() => _ref.read(idGeneratorProvider)();
  DateTime now() => _ref.read(clockProvider)();

  Future<Expense> save(Expense expense) =>
      _ref.read(expenseRepositoryProvider).save(expense);

  Future<void> delete(String id) =>
      _ref.read(expenseRepositoryProvider).delete(id);
}

final expenseActionsProvider = Provider<ExpenseActions>(ExpenseActions.new);
