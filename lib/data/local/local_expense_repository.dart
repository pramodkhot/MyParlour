import '../../domain/errors.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/expense.dart';
import '../../domain/repositories/repositories.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalExpenseRepository implements ExpenseRepository {
  LocalExpenseRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<Expense>> listInRange(DateRange range) async =>
      _store.data.expenses.where((e) => range.contains(e.spentOn)).toList()
        ..sort((a, b) => b.spentOn.compareTo(a.spentOn));

  @override
  Future<Expense?> getById(String id) async =>
      findById(_store.data.expenses, id, (e) => e.id);

  @override
  Future<Expense> save(Expense expense) => _store.transact((data) {
    if (expense.amountPaise <= 0) {
      throw const ValidationException('Enter an amount more than ₹0.');
    }
    if (expense.category.trim().isEmpty) {
      throw const ValidationException('Choose a category.');
    }
    final saved = expense.copyWith(parlourId: data.parlour.id);
    upsertById(data.expenses, saved, (e) => e.id);
    return saved;
  });

  /// Expenses are not referenced by other records, so they can be deleted.
  @override
  Future<void> delete(String id) => _store.transact((data) {
    data.expenses.removeWhere((e) => e.id == id);
  });
}
