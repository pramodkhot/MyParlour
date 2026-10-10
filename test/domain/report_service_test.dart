import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/date_range.dart';
import 'package:myparlour/domain/models/expense.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/services/report_service.dart';

Payment pay(
  String id,
  int amount,
  PaymentMethod method,
  DateTime at, {
  bool isVoid = false,
}) => Payment(
  id: id,
  parlourId: 'p',
  invoiceId: 'i',
  amountPaise: amount,
  method: method,
  receivedAt: at,
  isVoid: isVoid,
);

InvoiceItem item(
  String refId,
  String name,
  int lineTotal, {
  InvoiceItemType type = InvoiceItemType.service,
}) => InvoiceItem(
  id: '$refId-line',
  type: type,
  refId: refId,
  name: name,
  unitPricePaise: lineTotal,
  qty: 1,
  taxRateBp: 0,
  lineTotalPaise: lineTotal,
);

Invoice bill(
  String id,
  InvoiceStatus status,
  DateTime? finalisedAt,
  List<InvoiceItem> items,
) {
  final total = items.fold(0, (s, i) => s + i.lineTotalPaise);
  return Invoice(
    id: id,
    parlourId: 'p',
    status: status,
    items: items,
    subtotalPaise: total,
    discountPaise: 0,
    taxablePaise: total,
    taxPaise: 0,
    totalPaise: total,
    paidPaise: 0,
    balancePaise: total,
    createdAt: finalisedAt ?? DateTime(2026, 5, 5),
    finalisedAt: finalisedAt,
  );
}

Expense spend(String id, int amount, DateTime day) => Expense(
  id: id,
  parlourId: 'p',
  category: 'Rent',
  amountPaise: amount,
  spentOn: day,
);

void main() {
  final now = DateTime(2026, 5, 14, 16, 12); // Thursday

  group('periods', () {
    test('today', () {
      expect(
        ReportService.rangeFor(ReportPeriod.today, now),
        DateRange(DateTime(2026, 5, 14), DateTime(2026, 5, 15)),
      );
    });

    test('this week runs Monday to Sunday', () {
      final expected = DateRange(DateTime(2026, 5, 11), DateTime(2026, 5, 18));
      expect(ReportService.rangeFor(ReportPeriod.thisWeek, now), expected);
      expect(
        ReportService.rangeFor(ReportPeriod.thisWeek, DateTime(2026, 5, 17, 9)),
        expected,
      );
      expect(
        ReportService.rangeFor(ReportPeriod.thisWeek, DateTime(2026, 5, 11)),
        expected,
      );
    });

    test('this month', () {
      expect(
        ReportService.rangeFor(ReportPeriod.thisMonth, now),
        DateRange(DateTime(2026, 5), DateTime(2026, 6)),
      );
      expect(
        ReportService.rangeFor(ReportPeriod.thisMonth, DateTime(2026, 12, 31)),
        DateRange(DateTime(2026, 12), DateTime(2027)),
      );
    });

    test('custom range includes both days, in either order', () {
      final expected = DateRange(DateTime(2026, 5, 1), DateTime(2026, 5, 8));
      expect(
        ReportService.rangeFor(
          ReportPeriod.custom,
          now,
          customFrom: DateTime(2026, 5, 1),
          customTo: DateTime(2026, 5, 7),
        ),
        expected,
      );
      expect(
        ReportService.rangeFor(
          ReportPeriod.custom,
          now,
          customFrom: DateTime(2026, 5, 7, 18),
          customTo: DateTime(2026, 5, 1),
        ),
        expected,
      );
    });
  });

  group('figures for a fixed dataset (this month)', () {
    final range = ReportService.rangeFor(ReportPeriod.thisMonth, now);

    final payments = [
      pay('p1', 100000, PaymentMethod.cash, DateTime(2026, 5, 14, 10)),
      pay('p2', 50000, PaymentMethod.upi, DateTime(2026, 5, 2, 12)),
      pay('p3', 20000, PaymentMethod.card, DateTime(2026, 4, 30, 23)),
      pay('p4', 30000, PaymentMethod.upi, DateTime(2026, 5, 10), isVoid: true),
      pay('p5', 40000, PaymentMethod.upi, DateTime(2026, 6, 1)),
    ];

    final invoices = [
      bill('i1', InvoiceStatus.paid, DateTime(2026, 5, 14, 11), [
        item('haircut', 'Haircut', 50000),
        item('smooth', 'Smoothening', 250000),
      ]),
      bill('i2', InvoiceStatus.partiallyPaid, DateTime(2026, 5, 2, 12), [
        item('haircut', 'Haircut', 50000),
        item('serum', 'Hair Serum', 45000, type: InvoiceItemType.product),
      ]),
      bill('i3', InvoiceStatus.void_, DateTime(2026, 5, 3), [
        item('facial', 'Facial', 120000),
      ]),
      bill('i4', InvoiceStatus.draft, null, [item('facial', 'Facial', 120000)]),
      bill('i5', InvoiceStatus.paid, DateTime(2026, 4, 30, 18), [
        item('facial', 'Facial', 120000),
      ]),
    ];

    final expenses = [
      spend('e1', 1500000, DateTime(2026, 5, 1)),
      spend('e2', 20000, DateTime(2026, 5, 31)),
      spend('e3', 50000, DateTime(2026, 4, 30)),
    ];

    final summary = ReportService.build(
      range: range,
      payments: payments,
      invoices: invoices,
      expenses: expenses,
    );

    test('sales = non-void payments received in the range', () {
      expect(summary.salesPaise, 150000);
    });

    test('bills = finalised in the range, excluding void and drafts', () {
      expect(summary.billCount, 2);
    });

    test('expenses dated in the range', () {
      expect(summary.expensesPaise, 1520000);
    });

    test('net profit estimate = sales − expenses', () {
      expect(summary.netProfitEstimatePaise, 150000 - 1520000);
    });

    test('daily sales cover every day of the range', () {
      expect(summary.dailySales.length, 31);
      expect(summary.dailySales[13].day, DateTime(2026, 5, 14));
      expect(summary.dailySales[13].amountPaise, 100000);
      expect(summary.dailySales[1].amountPaise, 50000);
      expect(
        summary.dailySales.fold(0, (s, d) => s + d.amountPaise),
        summary.salesPaise,
      );
    });

    test('payment methods', () {
      expect(summary.paymentMethods[PaymentMethod.cash], 100000);
      expect(summary.paymentMethods[PaymentMethod.upi], 50000);
      expect(summary.paymentMethods[PaymentMethod.card], 0);
      expect(summary.paymentMethods[PaymentMethod.other], 0);
    });

    test('top services ranked by revenue with share %', () {
      expect(summary.topServices.map((s) => s.name), [
        'Smoothening',
        'Haircut',
      ]);
      expect(summary.topServices.map((s) => s.sharePercent), [71, 29]);
      expect(summary.topServices[1].count, 2);
      expect(summary.topServices[1].amountPaise, 100000);
    });

    test('empty range is empty', () {
      final empty = ReportService.build(
        range: DateRange.day(DateTime(2026, 3, 1)),
        payments: payments,
        invoices: invoices,
        expenses: expenses,
      );
      expect(empty.isEmpty, isTrue);
      expect(empty.topServices, isEmpty);
    });
  });
}
