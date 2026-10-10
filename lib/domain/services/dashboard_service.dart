import '../models/appointment.dart';
import '../models/customer.dart';
import '../models/date_range.dart';
import '../models/invoice.dart';
import '../models/payment.dart';
import '../models/product.dart';
import 'report_service.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.todaySalesPaise,
    required this.yesterdaySalesPaise,
    required this.todayAppointmentCount,
    required this.stillToComeCount,
    required this.pendingPaise,
    required this.pendingBillCount,
    required this.activeCustomerCount,
    required this.nextAppointments,
    required this.lowStock,
    required this.birthdaysToday,
  });

  final int todaySalesPaise;
  final int yesterdaySalesPaise;

  /// Today's appointments, excluding cancelled ones.
  final int todayAppointmentCount;

  /// Today's appointments still in "booked" status.
  final int stillToComeCount;
  final int pendingPaise;
  final int pendingBillCount;
  final int activeCustomerCount;

  /// Up to 3 booked or checked-in appointments from now, earliest first.
  final List<Appointment> nextAppointments;

  /// Active products at or below their alert level, lowest stock first.
  final List<Product> lowStock;
  final List<Customer> birthdaysToday;

  /// Whole-percent change vs yesterday; null when yesterday had no sales.
  int? get salesChangePercent {
    if (yesterdaySalesPaise == 0) return null;
    final diff = todaySalesPaise - yesterdaySalesPaise;
    final magnitude =
        (diff.abs() * 200 + yesterdaySalesPaise) ~/ (yesterdaySalesPaise * 2);
    return diff < 0 ? -magnitude : magnitude;
  }

  bool get hasAlerts => lowStock.isNotEmpty || birthdaysToday.isNotEmpty;
}

/// Dashboard figures (spec Section 6).
abstract final class DashboardService {
  static DashboardSummary build({
    required DateTime now,
    required Iterable<Payment> payments,
    required Iterable<Invoice> invoices,
    required Iterable<Appointment> appointments,
    required Iterable<Customer> customers,
    required Iterable<Product> products,
  }) {
    final today = DateRange.day(now);
    final yesterdayStart = DateTime(
      today.start.year,
      today.start.month,
      today.start.day - 1,
    );
    final yesterday = DateRange.day(yesterdayStart);

    final todays = appointments
        .where(
          (a) =>
              today.contains(a.startsAt) &&
              a.status != AppointmentStatus.cancelled,
        )
        .toList();

    final open = invoices.where((i) => i.isOpen).toList();

    final upcoming =
        appointments
            .where(
              (a) =>
                  (a.status == AppointmentStatus.booked ||
                      a.status == AppointmentStatus.checkedIn) &&
                  (a.status == AppointmentStatus.checkedIn ||
                      !a.endsAt.isBefore(now)),
            )
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    final lowStock =
        products.where((p) => p.isActive && p.needsRestock).toList()
          ..sort((a, b) {
            final byQty = a.stockQty.compareTo(b.stockQty);
            return byQty != 0 ? byQty : a.name.compareTo(b.name);
          });

    final todayLocal = now.toLocal();
    return DashboardSummary(
      todaySalesPaise: ReportService.salesIn(today, payments),
      yesterdaySalesPaise: ReportService.salesIn(yesterday, payments),
      todayAppointmentCount: todays.length,
      stillToComeCount: todays
          .where((a) => a.status == AppointmentStatus.booked)
          .length,
      pendingPaise: open.fold(0, (sum, i) => sum + i.balancePaise),
      pendingBillCount: open.length,
      activeCustomerCount: customers.where((c) => c.isActive).length,
      nextAppointments: upcoming.take(3).toList(),
      lowStock: lowStock,
      birthdaysToday: customers
          .where(
            (c) => c.isActive && (c.birthday?.matches(todayLocal) ?? false),
          )
          .toList(),
    );
  }
}
