import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/parlour.dart';
import '../../domain/services/dashboard_service.dart';

/// Everything the Dashboard shows, loaded through the repositories.
class DashboardData {
  const DashboardData({
    required this.now,
    required this.parlour,
    required this.summary,
    required this.customerNames,
    required this.staffNames,
  });

  final DateTime now;
  final Parlour parlour;
  final DashboardSummary summary;
  final Map<String, String> customerNames;
  final Map<String, String> staffNames;

  /// "Priya Sharma" or "Walk-in · Kiran".
  String clientName(Appointment a) => a.customerId == null
      ? 'Walk-in · ${a.walkInName ?? 'Guest'}'
      : customerNames[a.customerId] ?? 'Customer';

  String stylistName(Appointment a) => staffNames[a.staffId] ?? 'Stylist';
}

final dashboardProvider = FutureProvider.autoDispose<DashboardData>((
  ref,
) async {
  ref.watch(dataVersionProvider);
  final now = ref.watch(clockProvider)();
  final today = DateRange.day(now);
  final yesterday = DateTime(
    today.start.year,
    today.start.month,
    today.start.day - 1,
  );
  final monthAhead = DateTime(
    today.start.year,
    today.start.month,
    today.start.day + 31,
  );

  final parlour = await ref.watch(parlourRepositoryProvider).get();
  final payments = await ref
      .watch(paymentRepositoryProvider)
      .listInRange(DateRange(yesterday, today.end));
  final invoices = await ref.watch(invoiceRepositoryProvider).list();
  final appointments = await ref
      .watch(appointmentRepositoryProvider)
      .listInRange(DateRange(today.start, monthAhead));
  final customers = await ref
      .watch(customerRepositoryProvider)
      .list(includeInactive: true);
  final products = await ref.watch(productRepositoryProvider).list();
  final staff = await ref
      .watch(staffRepositoryProvider)
      .list(includeInactive: true);

  return DashboardData(
    now: now,
    parlour: parlour,
    summary: DashboardService.build(
      now: now,
      payments: payments,
      invoices: invoices,
      appointments: appointments,
      customers: customers,
      products: products,
    ),
    customerNames: {for (final c in customers) c.id: c.name},
    staffNames: {for (final s in staff) s.id: s.name},
  );
});
