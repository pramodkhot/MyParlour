import '../models/date_range.dart';
import '../models/expense.dart';
import '../models/invoice.dart';
import '../models/payment.dart';

enum ReportPeriod { today, thisWeek, thisMonth, custom }

class DailyAmount {
  const DailyAmount(this.day, this.amountPaise);

  final DateTime day;
  final int amountPaise;
}

class ServiceShare {
  const ServiceShare({
    required this.name,
    required this.count,
    required this.amountPaise,
    required this.sharePercent,
  });

  final String name;

  /// Number of times sold (sum of quantities).
  final int count;
  final int amountPaise;

  /// Share of all service revenue in the range, 0–100, rounded.
  final int sharePercent;
}

class ReportSummary {
  const ReportSummary({
    required this.range,
    required this.salesPaise,
    required this.expensesPaise,
    required this.billCount,
    required this.dailySales,
    required this.topServices,
    required this.paymentMethods,
  });

  final DateRange range;

  /// Money actually collected: non-void payments received in the range.
  final int salesPaise;
  final int expensesPaise;

  /// Bills finalised in the range, excluding void.
  final int billCount;
  final List<DailyAmount> dailySales;
  final List<ServiceShare> topServices;
  final Map<PaymentMethod, int> paymentMethods;

  /// Sales − expenses. Always shown as an estimate.
  int get netProfitEstimatePaise => salesPaise - expensesPaise;

  bool get isEmpty => salesPaise == 0 && expensesPaise == 0 && billCount == 0;
}

/// Report figures (spec Section 6). Pure functions over plain lists so the
/// same code works with local or cloud data.
abstract final class ReportService {
  /// The date range for [period] around [now]. Weeks start on Monday.
  /// For [ReportPeriod.custom], pass [customFrom] and [customTo] (inclusive
  /// calendar days).
  static DateRange rangeFor(
    ReportPeriod period,
    DateTime now, {
    DateTime? customFrom,
    DateTime? customTo,
  }) {
    final today = DateRange.startOfDay(now);
    switch (period) {
      case ReportPeriod.today:
        return DateRange.day(today);
      case ReportPeriod.thisWeek:
        final monday = DateTime(
          today.year,
          today.month,
          today.day - (today.weekday - DateTime.monday),
        );
        return DateRange.days(
          monday,
          DateTime(monday.year, monday.month, monday.day + 6),
        );
      case ReportPeriod.thisMonth:
        return DateRange(
          DateTime(today.year, today.month),
          DateTime(today.year, today.month + 1),
        );
      case ReportPeriod.custom:
        if (customFrom == null || customTo == null) {
          throw ArgumentError('A custom range needs both dates.');
        }
        return customTo.isBefore(customFrom)
            ? DateRange.days(customTo, customFrom)
            : DateRange.days(customFrom, customTo);
    }
  }

  /// Sales per hour of [day] from [fromHour] up to (not including)
  /// [toHour], for the "Today" chart. Payments outside those hours are
  /// added to the first or last hour so the total still matches.
  static List<(int hour, int paise)> hourlySales(
    DateTime day,
    Iterable<Payment> payments, {
    int fromHour = 10,
    int toHour = 20,
  }) {
    final range = DateRange.day(day);
    final byHour = {for (var h = fromHour; h < toHour; h++) h: 0};
    for (final p in payments) {
      if (p.isVoid || !range.contains(p.receivedAt)) continue;
      final h = p.receivedAt.toLocal().hour.clamp(fromHour, toHour - 1);
      byHour[h] = byHour[h]! + p.amountPaise;
    }
    return [for (final e in byHour.entries) (e.key, e.value)];
  }

  static int salesIn(DateRange range, Iterable<Payment> payments) => payments
      .where((p) => !p.isVoid && range.contains(p.receivedAt))
      .fold(0, (sum, p) => sum + p.amountPaise);

  static List<Invoice> billsIn(DateRange range, Iterable<Invoice> invoices) =>
      invoices
          .where(
            (i) =>
                !i.isVoid &&
                !i.isDraft &&
                i.finalisedAt != null &&
                range.contains(i.finalisedAt!),
          )
          .toList();

  static int expensesIn(DateRange range, Iterable<Expense> expenses) => expenses
      .where((e) => range.contains(e.spentOn))
      .fold(0, (sum, e) => sum + e.amountPaise);

  static ReportSummary build({
    required DateRange range,
    required Iterable<Payment> payments,
    required Iterable<Invoice> invoices,
    required Iterable<Expense> expenses,
    int topServiceLimit = 5,
  }) {
    final inRange = payments
        .where((p) => !p.isVoid && range.contains(p.receivedAt))
        .toList();
    final bills = billsIn(range, invoices);

    final byDay = <DateTime, int>{for (final day in range.days) day: 0};
    final byMethod = <PaymentMethod, int>{
      for (final method in PaymentMethod.values) method: 0,
    };
    for (final p in inRange) {
      final day = DateRange.startOfDay(p.receivedAt);
      byDay[day] = (byDay[day] ?? 0) + p.amountPaise;
      byMethod[p.method] = byMethod[p.method]! + p.amountPaise;
    }

    return ReportSummary(
      range: range,
      salesPaise: inRange.fold(0, (sum, p) => sum + p.amountPaise),
      expensesPaise: expensesIn(range, expenses),
      billCount: bills.length,
      dailySales: [
        for (final entry in byDay.entries) DailyAmount(entry.key, entry.value),
      ],
      topServices: topServices(bills, limit: topServiceLimit),
      paymentMethods: byMethod,
    );
  }

  /// Service lines across [bills], grouped by service and ranked by
  /// revenue. Share % is of all service revenue in those bills.
  static List<ServiceShare> topServices(
    Iterable<Invoice> bills, {
    int limit = 5,
  }) {
    final amounts = <String, int>{};
    final counts = <String, int>{};
    final names = <String, String>{};
    for (final bill in bills) {
      for (final item in bill.items) {
        if (item.type != InvoiceItemType.service) continue;
        amounts[item.refId] = (amounts[item.refId] ?? 0) + item.lineTotalPaise;
        counts[item.refId] = (counts[item.refId] ?? 0) + item.qty;
        names[item.refId] = item.name;
      }
    }
    final total = amounts.values.fold(0, (a, b) => a + b);
    final ids = amounts.keys.toList()
      ..sort((a, b) {
        final byAmount = amounts[b]!.compareTo(amounts[a]!);
        return byAmount != 0 ? byAmount : names[a]!.compareTo(names[b]!);
      });
    return [
      for (final id in ids.take(limit))
        ServiceShare(
          name: names[id]!,
          count: counts[id]!,
          amountPaise: amounts[id]!,
          sharePercent: total == 0
              ? 0
              : (amounts[id]! * 200 + total) ~/ (total * 2),
        ),
    ];
  }
}
