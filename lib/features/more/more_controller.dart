import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/date_range.dart';

/// Numbers shown on the right of each row on the More screen.
class MoreSummary {
  const MoreSummary({
    required this.parlourName,
    required this.customers,
    required this.activeStaff,
    required this.services,
    required this.lowStock,
    required this.monthExpensesPaise,
  });

  final String parlourName;
  final int customers;
  final int activeStaff;
  final int services;

  /// Active products at or below their alert level.
  final int lowStock;
  final int monthExpensesPaise;
}

final moreSummaryProvider = FutureProvider.autoDispose<MoreSummary>((
  ref,
) async {
  ref.watch(dataVersionProvider);
  final now = ref.watch(clockProvider)();
  final products = await ref.watch(productRepositoryProvider).list();
  final expenses = await ref
      .watch(expenseRepositoryProvider)
      .listInRange(
        DateRange(
          DateTime(now.year, now.month),
          DateTime(now.year, now.month + 1),
        ),
      );
  return MoreSummary(
    parlourName: (await ref.watch(parlourRepositoryProvider).get()).name,
    customers: (await ref.watch(customerRepositoryProvider).list()).length,
    activeStaff: (await ref.watch(staffRepositoryProvider).list()).length,
    services: (await ref.watch(serviceRepositoryProvider).list()).length,
    lowStock: products.where((p) => p.needsRestock).length,
    monthExpensesPaise: expenses.fold(0, (sum, e) => sum + e.amountPaise),
  );
});
