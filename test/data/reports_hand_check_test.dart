import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/demo/demo_seed.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/services/report_service.dart';

import '../helpers/test_data.dart';

/// Phase 7 "done when": report figures match a hand check of the seed.
/// The expected numbers here are summed directly from the raw lists with
/// plain loops, independent of ReportService.
void main() {
  for (final now in [
    testNow,
    DateTime(2026, 6, 3, 18),
    DateTime(2027, 4, 1, 11),
  ]) {
    test('this month on $now', () {
      final data = DemoSeed.build(now, sequentialIds('seed'));
      final first = DateTime(now.year, now.month);
      final next = DateTime(now.year, now.month + 1);
      bool inMonth(DateTime t) {
        final l = t.toLocal();
        return !l.isBefore(first) && l.isBefore(next);
      }

      var sales = 0;
      final byMethod = {for (final m in PaymentMethod.values) m: 0};
      for (final p in data.payments) {
        if (!p.isVoid && inMonth(p.receivedAt)) {
          sales += p.amountPaise;
          byMethod[p.method] = byMethod[p.method]! + p.amountPaise;
        }
      }
      var expenses = 0;
      for (final e in data.expenses) {
        if (inMonth(e.spentOn)) expenses += e.amountPaise;
      }
      var bills = 0;
      final serviceTotals = <String, int>{};
      for (final i in data.invoices) {
        if (i.status == InvoiceStatus.void_ || i.finalisedAt == null) continue;
        if (!inMonth(i.finalisedAt!)) continue;
        bills++;
        for (final item in i.items) {
          if (item.type == InvoiceItemType.service) {
            serviceTotals[item.name] =
                (serviceTotals[item.name] ?? 0) + item.lineTotalPaise;
          }
        }
      }
      final topName =
          (serviceTotals.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first
              .key;

      final report = ReportService.build(
        range: ReportService.rangeFor(ReportPeriod.thisMonth, now),
        payments: data.payments,
        invoices: data.invoices,
        expenses: data.expenses,
      );

      expect(sales, greaterThan(0), reason: 'the seed has sales this month');
      expect(report.salesPaise, sales);
      expect(report.expensesPaise, expenses);
      expect(report.netProfitEstimatePaise, sales - expenses);
      expect(report.billCount, bills);
      expect(report.paymentMethods, byMethod);
      expect(report.topServices.first.name, topName);
      expect(report.dailySales.fold(0, (s, d) => s + d.amountPaise), sales);
    });
  }
}
