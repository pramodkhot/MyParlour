import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/customer.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/models/product.dart';
import 'package:myparlour/domain/models/value_types.dart';
import 'package:myparlour/domain/services/dashboard_service.dart';

import '../helpers/test_data.dart';

Payment pay(String id, int amount, DateTime at) => Payment(
  id: id,
  parlourId: 'p',
  invoiceId: 'i',
  amountPaise: amount,
  method: PaymentMethod.upi,
  receivedAt: at,
);

Invoice bill(String id, InvoiceStatus status, int balance) => Invoice(
  id: id,
  parlourId: 'p',
  status: status,
  items: const [],
  subtotalPaise: 100000,
  discountPaise: 0,
  taxablePaise: 100000,
  taxPaise: 0,
  totalPaise: 100000,
  paidPaise: 100000 - balance,
  balancePaise: balance,
  createdAt: DateTime(2026, 5, 1),
);

Customer customer(String id, {bool active = true, DayMonth? birthday}) =>
    Customer(
      id: id,
      parlourId: 'p',
      name: id,
      phone: '9000000000',
      birthday: birthday,
      isActive: active,
      createdAt: DateTime.utc(2026),
    );

Product product(String name, int qty, int alert, {bool active = true}) =>
    Product(
      id: name,
      parlourId: 'p',
      name: name,
      unit: ProductUnit.pcs,
      stockQty: qty,
      lowStockAt: alert,
      isActive: active,
    );

void main() {
  final now = DateTime(2026, 5, 14, 16, 12);
  DateTime t(int day, int h, [int m = 0]) => DateTime(2026, 5, day, h, m);

  final summary = DashboardService.build(
    now: now,
    payments: [
      pay('today1', 100000, t(14, 11)),
      pay('today2', 70000, t(14, 15)),
      pay('yesterday', 200000, t(13, 12)),
    ],
    invoices: [
      bill('due', InvoiceStatus.finalised, 50000),
      bill('part', InvoiceStatus.partiallyPaid, 30000),
      bill('paid', InvoiceStatus.paid, 0),
      bill('void', InvoiceStatus.void_, 100000),
      bill('draft', InvoiceStatus.draft, 100000),
    ],
    appointments: [
      testAppointment(
        id: 'done',
        start: t(14, 10),
        status: AppointmentStatus.completed,
      ),
      testAppointment(
        id: 'late',
        start: t(14, 11),
        status: AppointmentStatus.booked,
      ),
      testAppointment(
        id: 'in',
        start: t(14, 15, 30),
        status: AppointmentStatus.checkedIn,
      ),
      testAppointment(id: 'next', start: t(14, 17)),
      testAppointment(
        id: 'cancelled',
        start: t(14, 18),
        status: AppointmentStatus.cancelled,
      ),
      testAppointment(id: 'tomorrow', start: t(15, 10)),
      testAppointment(id: 'later', start: t(16, 10)),
    ],
    customers: [
      customer('a', birthday: const DayMonth(14, 5)),
      customer('b'),
      customer('c'),
      customer('gone', active: false, birthday: const DayMonth(14, 5)),
    ],
    products: [
      product('Hair Serum', 2, 3),
      product('Hair Colour', 0, 2),
      product('Shampoo', 15, 5),
      product('Old Gel', 0, 2, active: false),
    ],
  );

  test("today's sales and change vs yesterday", () {
    expect(summary.todaySalesPaise, 170000);
    expect(summary.yesterdaySalesPaise, 200000);
    expect(summary.salesChangePercent, -15);
  });

  test('no % change when yesterday had no sales', () {
    final s = DashboardService.build(
      now: now,
      payments: [pay('x', 100, t(14, 10))],
      invoices: const [],
      appointments: const [],
      customers: const [],
      products: const [],
    );
    expect(s.salesChangePercent, isNull);
  });

  test("today's appointments exclude cancelled; still to come = booked", () {
    expect(summary.todayAppointmentCount, 4);
    expect(summary.stillToComeCount, 2);
  });

  test(
    'next appointments: checked in or not yet over, earliest first, max 3',
    () {
      expect(summary.nextAppointments.map((a) => a.id), [
        'in',
        'next',
        'tomorrow',
      ]);
    },
  );

  test('pending payments = balances of open bills', () {
    expect(summary.pendingPaise, 80000);
    expect(summary.pendingBillCount, 2);
  });

  test('active customers', () {
    expect(summary.activeCustomerCount, 3);
  });

  test('low stock = active products at or below alert, lowest first', () {
    expect(summary.lowStock.map((p) => p.name), ['Hair Colour', 'Hair Serum']);
  });

  test('birthdays today (active customers only) raise an alert', () {
    expect(summary.birthdaysToday.map((c) => c.id), ['a']);
    expect(summary.hasAlerts, isTrue);
  });
}
