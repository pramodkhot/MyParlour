import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/date_range.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/services/customer_stats.dart';
import 'package:myparlour/domain/services/staff_stats.dart';

import '../helpers/test_data.dart';

Invoice bill(
  String id, {
  String? appointmentId,
  InvoiceStatus status = InvoiceStatus.paid,
  int total = 50000,
  DateTime? at,
  List<InvoiceItem> items = const [],
}) => Invoice(
  id: id,
  parlourId: 'p',
  invoiceNo: 'BBP/2026-27/$id',
  customerId: 'cust-priya',
  appointmentId: appointmentId,
  status: status,
  items: items,
  subtotalPaise: total,
  discountPaise: 0,
  taxablePaise: total,
  taxPaise: 0,
  totalPaise: total,
  paidPaise: 0,
  balancePaise: total,
  createdAt: at ?? DateTime(2026, 5, 10),
  finalisedAt: at ?? DateTime(2026, 5, 10),
);

InvoiceItem line(String staffId, int total, {int qty = 1}) => InvoiceItem(
  id: 'l-$staffId-$total',
  type: InvoiceItemType.service,
  refId: 'svc',
  name: 'Haircut',
  unitPricePaise: total,
  qty: qty,
  taxRateBp: 0,
  lineTotalPaise: total,
  staffId: staffId,
);

Payment pay(String invoiceId, int amount, {bool isVoid = false}) => Payment(
  id: 'p-$invoiceId-$amount',
  parlourId: 'p',
  invoiceId: invoiceId,
  amountPaise: amount,
  method: PaymentMethod.cash,
  receivedAt: DateTime(2026, 5, 10),
  isVoid: isVoid,
);

void main() {
  group('customer history', () {
    final done = testAppointment(
      id: 'a1',
      start: DateTime(2026, 5, 1, 10),
      status: AppointmentStatus.completed,
    );
    final cancelled = testAppointment(
      id: 'a2',
      start: DateTime(2026, 5, 3, 10),
      status: AppointmentStatus.cancelled,
    );

    test('merges appointments and bills, newest first', () {
      final history = CustomerStats.history(
        appointments: [done, cancelled],
        invoices: [
          bill('b1', appointmentId: 'a1', total: 70000),
          bill('b2', at: DateTime(2026, 5, 5)), // walk-in style bill
          bill('b3', status: InvoiceStatus.void_, at: DateTime(2026, 5, 6)),
        ],
      );
      expect(history.map((e) => e.at), [
        DateTime(2026, 5, 5),
        DateTime(2026, 5, 3, 10),
        DateTime(2026, 5, 1, 10),
      ]);
      // The billed appointment shows the bill total, not the booking price.
      expect(history.last.amountPaise, 70000);
      expect(history.last.invoice?.id, 'b1');
      // Cancelled appointment without a bill shows the booked price.
      expect(history[1].invoice, isNull);
      expect(history[1].amountPaise, cancelled.totalPricePaise);
    });

    test('visits count completed appointments only', () {
      expect(CustomerStats.visits([done, cancelled]), 1);
    });

    test('total spent = non-void payments on non-void bills', () {
      expect(
        CustomerStats.totalSpentPaise(
          invoices: [
            bill('b1'),
            bill('b2'),
            bill('b3', status: InvoiceStatus.void_),
          ],
          payments: [
            pay('b1', 30000),
            pay('b2', 20000),
            pay('b2', 5000, isVoid: true),
            pay('b3', 99999),
          ],
        ),
        50000,
      );
    });
  });

  test('staff month stats count their service lines on finalised bills', () {
    final may = DateRange(DateTime(2026, 5), DateTime(2026, 6));
    final stats = StaffStats.forRange(
      staffId: 'anita',
      range: may,
      invoices: [
        bill('b1', items: [line('anita', 50000), line('riya', 80000)]),
        bill('b2', items: [line('anita', 25000, qty: 2)]),
        bill('void', status: InvoiceStatus.void_, items: [line('anita', 1)]),
        bill('april', at: DateTime(2026, 4, 30), items: [line('anita', 1)]),
      ],
    );
    expect(stats.servicesDone, 3);
    expect(stats.billedPaise, 75000);
  });
}
