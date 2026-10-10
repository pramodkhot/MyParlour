import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/phone.dart';
import '../../data/providers.dart';
import '../../domain/models/customer.dart';
import '../../domain/services/customer_stats.dart';

/// List view options on the Customers screen.
enum CustomerView { recentVisit, az, inactive }

class CustomerRow {
  const CustomerRow({required this.customer, required this.visits});

  final Customer customer;
  final int visits;
}

/// All customers (active and inactive) with their visit counts.
final customerRowsProvider = FutureProvider.autoDispose<List<CustomerRow>>((
  ref,
) async {
  ref.watch(dataVersionProvider);
  final customers = await ref
      .watch(customerRepositoryProvider)
      .list(includeInactive: true);
  final visits = await ref
      .watch(appointmentRepositoryProvider)
      .completedVisitCounts();
  return [
    for (final c in customers)
      CustomerRow(customer: c, visits: visits[c.id] ?? 0),
  ];
});

/// Search by name or phone, then sort. "Inactive" shows only deactivated
/// customers; the other views show only active ones.
List<CustomerRow> filterCustomers(
  List<CustomerRow> rows, {
  required String query,
  required CustomerView view,
}) {
  final q = query.trim().toLowerCase();
  final digits = PhoneNumber.searchDigits(q);
  final wantActive = view != CustomerView.inactive;

  final result = rows.where((row) {
    final c = row.customer;
    if (c.isActive != wantActive) return false;
    if (q.isEmpty) return true;
    if (c.name.toLowerCase().contains(q)) return true;
    if (digits.isNotEmpty) {
      final phone =
          PhoneNumber.normalise(c.phone) ??
          c.phone.replaceAll(RegExp(r'\D'), '');
      return phone.contains(digits);
    }
    return false;
  }).toList();

  int byName(CustomerRow a, CustomerRow b) =>
      a.customer.name.toLowerCase().compareTo(b.customer.name.toLowerCase());

  if (view == CustomerView.recentVisit) {
    result.sort((a, b) {
      final av = a.customer.lastVisitAt;
      final bv = b.customer.lastVisitAt;
      if (av == null && bv == null) return byName(a, b);
      if (av == null) return 1;
      if (bv == null) return -1;
      final cmp = bv.compareTo(av);
      return cmp != 0 ? cmp : byName(a, b);
    });
  } else {
    result.sort(byName);
  }
  return result;
}

class CustomerDetail {
  const CustomerDetail({
    required this.customer,
    required this.history,
    required this.visits,
    required this.totalSpentPaise,
  });

  final Customer customer;
  final List<HistoryEntry> history;
  final int visits;
  final int totalSpentPaise;
}

final customerDetailProvider = FutureProvider.autoDispose
    .family<CustomerDetail?, String>((ref, id) async {
      ref.watch(dataVersionProvider);
      final customer = await ref.watch(customerRepositoryProvider).getById(id);
      if (customer == null) return null;
      final appointments = await ref
          .watch(appointmentRepositoryProvider)
          .listForCustomer(id);
      final invoices = await ref
          .watch(invoiceRepositoryProvider)
          .listForCustomer(id);
      final paymentRepo = ref.watch(paymentRepositoryProvider);
      final payments = [
        for (final i in invoices) ...await paymentRepo.listForInvoice(i.id),
      ];
      return CustomerDetail(
        customer: customer,
        history: CustomerStats.history(
          appointments: appointments,
          invoices: invoices,
        ),
        visits: CustomerStats.visits(appointments),
        totalSpentPaise: CustomerStats.totalSpentPaise(
          invoices: invoices,
          payments: payments,
        ),
      );
    });

/// Writes for the customer screens.
class CustomerActions {
  CustomerActions(this._ref);

  final Ref _ref;

  String newId() => _ref.read(idGeneratorProvider)();
  DateTime now() => _ref.read(clockProvider)();

  Future<Customer> save(Customer customer) =>
      _ref.read(customerRepositoryProvider).save(customer);

  Future<void> setActive(String id, {required bool isActive}) =>
      _ref.read(customerRepositoryProvider).setActive(id, isActive: isActive);

  Future<Customer?> findDuplicate(String phone, {String? excludeId}) => _ref
      .read(customerRepositoryProvider)
      .findDuplicate(phone, excludeId: excludeId);

  Future<Customer> updateNotes(Customer customer, String notes) {
    final trimmed = notes.trim();
    return save(
      Customer(
        id: customer.id,
        parlourId: customer.parlourId,
        name: customer.name,
        phone: customer.phone,
        email: customer.email,
        birthday: customer.birthday,
        anniversary: customer.anniversary,
        notes: trimmed.isEmpty ? null : trimmed,
        isActive: customer.isActive,
        createdAt: customer.createdAt,
        lastVisitAt: customer.lastVisitAt,
      ),
    );
  }
}

final customerActionsProvider = Provider<CustomerActions>(CustomerActions.new);
