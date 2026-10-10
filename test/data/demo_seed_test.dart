import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/demo/demo_seed.dart';
import 'package:myparlour/data/local/store_data.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/date_range.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/services/appointment_rules.dart';
import 'package:myparlour/domain/services/dashboard_service.dart';
import 'package:myparlour/domain/services/invoice_calculator.dart';
import 'package:myparlour/domain/services/invoice_rules.dart';
import 'package:myparlour/domain/services/report_service.dart';

import '../helpers/test_data.dart';

void main() {
  // Run the checks for several "today"s, including a Sunday, a month's
  // first day and the first day of a financial year.
  final days = [
    testNow,
    DateTime(2026, 5, 17, 9), // Sunday
    DateTime(2026, 6, 1, 19, 30),
    DateTime(2027, 4, 1, 11),
  ];

  for (final now in days) {
    group('seed for $now', () {
      final data = DemoSeed.build(now, sequentialIds('seed'));
      final today = DateRange.day(now);

      List<Appointment> where(bool Function(Appointment a) test) =>
          data.appointments.where(test).toList();

      test('parlour, services, staff, customers, products', () {
        expect(data.parlour.name, 'Beauty Bliss Parlour');
        expect(data.parlour.ownerName, 'Kavita');
        expect(data.parlour.taxEnabled, isFalse);
        expect(data.services, hasLength(10));
        expect(data.services.map((s) => s.category).toSet(), {
          'Hair',
          'Skin',
          'Nails',
          'Waxing',
        });
        expect(data.staff.map((s) => s.name), [
          'Anita',
          'Riya',
          'Meena',
          'Pooja',
        ]);
        expect(data.staff.where((s) => !s.isActive).single.name, 'Pooja');
        expect(data.customers, hasLength(14));
        expect(
          data.customers.map((c) => c.phone.replaceAll(' ', '')).toSet(),
          hasLength(14),
        );
      });

      test('today: 2 completed and billed, 1 checked in, 3 booked', () {
        final todays = where((a) => today.contains(a.startsAt));
        int count(AppointmentStatus s) =>
            todays.where((a) => a.status == s).length;
        expect(todays, hasLength(6));
        expect(count(AppointmentStatus.completed), 2);
        expect(count(AppointmentStatus.checkedIn), 1);
        expect(count(AppointmentStatus.booked), 3);
        for (final a in todays.where(
          (a) => a.status == AppointmentStatus.completed,
        )) {
          expect(
            data.invoices.where((i) => i.appointmentId == a.id),
            hasLength(1),
          );
        }
      });

      test('next 7 days: 8 booked, none on Sunday', () {
        final next = where(
          (a) =>
              !a.startsAt.isBefore(today.end) &&
              a.startsAt.isBefore(today.end.add(const Duration(days: 7))),
        );
        expect(next, hasLength(8));
        expect(next.every((a) => a.status == AppointmentStatus.booked), isTrue);
        expect(next.any((a) => a.startsAt.weekday == DateTime.sunday), isFalse);
      });

      test('past 30 days: 40 completed, 2 cancelled, 1 no-show', () {
        final past = where((a) => a.startsAt.isBefore(today.start));
        int count(AppointmentStatus s) =>
            past.where((a) => a.status == s).length;
        expect(count(AppointmentStatus.completed), 40);
        expect(count(AppointmentStatus.cancelled), 2);
        expect(count(AppointmentStatus.noShow), 1);
        expect(
          past.every(
            (a) => !a.startsAt.isBefore(
              DateTime(now.year, now.month, now.day - 30),
            ),
          ),
          isTrue,
        );
      });

      test('no stylist is double-booked', () {
        final active = where((a) => AppointmentRules.blocksTime(a.status));
        for (final a in active) {
          final clashes = AppointmentRules.clashes(
            staffId: a.staffId,
            start: a.startsAt,
            end: a.endsAt,
            existing: active,
            excludeId: a.id,
          );
          expect(clashes, isEmpty, reason: '${a.startsAt}');
        }
      });

      test('one bill per completed appointment, maths consistent', () {
        final completed = where((a) => a.status == AppointmentStatus.completed);
        expect(data.invoices, hasLength(completed.length));
        for (final invoice in data.invoices) {
          final recalculated = InvoiceCalculator.calculate(
            items: invoice.items,
            discount: BillDiscount.of(
              invoice.discountType,
              invoice.discountValue,
            ),
            taxEnabled: false,
          );
          expect(invoice.totalPaise, recalculated.totalPaise);
          final paid = InvoiceRules.paidPaise(
            data.payments.where((p) => p.invoiceId == invoice.id),
          );
          expect(invoice.paidPaise, paid);
          expect(invoice.balancePaise, invoice.totalPaise - paid);
          expect(
            invoice.status,
            InvoiceRules.statusFor(
              totalPaise: invoice.totalPaise,
              paidPaise: paid,
            ),
          );
          expect(invoice.invoiceNo, startsWith('BBP/'));
        }
        expect(
          data.invoices.map((i) => i.invoiceNo).toSet(),
          hasLength(data.invoices.length),
        );
      });

      test('3 partly paid bills with ₹2,150 pending', () {
        final open = data.invoices.where((i) => i.isOpen).toList();
        expect(open, hasLength(3));
        expect(
          open.every((i) => i.status == InvoiceStatus.partiallyPaid),
          isTrue,
        );
        expect(open.fold(0, (s, i) => s + i.balancePaise), 215000);
      });

      test('payment methods are mostly UPI, then cash, then card', () {
        int count(PaymentMethod m) =>
            data.payments.where((p) => p.method == m).length;
        expect(
          count(PaymentMethod.upi),
          greaterThan(count(PaymentMethod.cash)),
        );
        expect(
          count(PaymentMethod.cash),
          greaterThan(count(PaymentMethod.card)),
        );
        expect(count(PaymentMethod.card), greaterThan(0));
      });

      test('products end at the spec stock levels', () {
        final stock = {for (final p in data.products) p.name: p.stockQty};
        expect(stock, {
          'Hair Serum': 2,
          'Face Cream': 3,
          'Shampoo': 15,
          'Conditioner': 8,
          'Hair Colour': 0,
          'Wax Strips': 40,
          'Nail Polish': 12,
          'Face Wash': 6,
        });
        for (final p in data.products) {
          final net = data.stockMovements
              .where((m) => m.productId == p.id)
              .fold(0, (s, m) => s + m.qtyChange);
          expect(net, p.stockQty, reason: p.name);
        }
      });

      test('expenses in the last 30 days', () {
        expect(data.expenses, hasLength(12));
        expect(
          data.expenses.where((e) => e.category == 'Salary'),
          hasLength(3),
        );
        expect(
          data.expenses.where((e) => e.category == 'Tea/Snacks'),
          hasLength(6),
        );
      });

      test('reports and dashboard have data', () {
        final month = ReportService.build(
          range: ReportService.rangeFor(ReportPeriod.thisMonth, now),
          payments: data.payments,
          invoices: data.invoices,
          expenses: data.expenses,
        );
        expect(month.salesPaise, greaterThan(0));
        expect(month.billCount, greaterThanOrEqualTo(2));
        expect(month.topServices, isNotEmpty);

        final dash = DashboardService.build(
          now: now,
          payments: data.payments,
          invoices: data.invoices,
          appointments: data.appointments,
          customers: data.customers,
          products: data.products,
        );
        expect(dash.todaySalesPaise, greaterThan(0));
        expect(dash.todayAppointmentCount, 6);
        expect(dash.pendingPaise, 215000);
        expect(dash.pendingBillCount, 3);
        expect(dash.activeCustomerCount, 14);
        expect(dash.lowStock.map((p) => p.name), [
          'Hair Colour',
          'Hair Serum',
          'Face Cream',
        ]);
        expect(dash.birthdaysToday.map((c) => c.name), ['Pooja Mehta']);
      });

      test('survives a JSON round-trip', () {
        final text = jsonEncode(data.toJson());
        final back = StoreData.fromJson(
          jsonDecode(text) as Map<String, Object?>,
        );
        expect(jsonEncode(back.toJson()), text);
      });
    });
  }
}
