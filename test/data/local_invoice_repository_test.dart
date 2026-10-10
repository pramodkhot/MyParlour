import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/local/local_invoice_repository.dart';
import 'package:myparlour/data/local/local_payment_repository.dart';
import 'package:myparlour/data/local/local_product_repository.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/domain/errors.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/models/stock_movement.dart';
import 'package:myparlour/domain/repositories/repositories.dart';
import 'package:myparlour/domain/services/invoice_calculator.dart';

import '../helpers/test_data.dart';

void main() {
  late LocalStore store;
  late LocalInvoiceRepository invoices;
  late LocalProductRepository products;
  late LocalPaymentRepository payments;

  setUp(() async {
    store = await openTestStore();
    final ids = sequentialIds();
    invoices = LocalInvoiceRepository(store, newId: ids);
    products = LocalProductRepository(store, newId: ids);
    payments = LocalPaymentRepository(store);
  });
  tearDown(() => deleteTestStore(store));

  BillDraft draft({
    String id = 'bill-1',
    List<BillLine>? lines,
    BillDiscount discount = const BillDiscount.none(),
    String? appointmentId,
  }) => BillDraft(
    id: id,
    customerId: priya.id,
    appointmentId: appointmentId,
    lines: lines ?? [serviceLine(haircut), serviceLine(smoothening)],
    discount: discount,
  );

  PaymentInput payment(String id, int amount, {String bill = 'bill-1'}) =>
      PaymentInput(
        id: id,
        invoiceId: bill,
        amountPaise: amount,
        method: PaymentMethod.cash,
      );

  group('bill with discount', () {
    test('totals correctly and gets a number', () async {
      final bill = await invoices.finalise(
        draft(discount: const BillDiscount.amount(30000)),
      );
      expect(bill.subtotalPaise, 300000);
      expect(bill.discountPaise, 30000);
      expect(bill.totalPaise, 270000);
      expect(bill.balancePaise, 270000);
      expect(bill.status, InvoiceStatus.finalised);
      expect(bill.invoiceNo, 'BBP/2026-27/0001');
    });

    test('invoice serials go up and never repeat', () async {
      final a = await invoices.finalise(draft(id: 'a'));
      final b = await invoices.finalise(draft(id: 'b'));
      await invoices.voidInvoice('a');
      final c = await invoices.finalise(draft(id: 'c'));
      expect(
        [a.invoiceNo, b.invoiceNo, c.invoiceNo],
        ['BBP/2026-27/0001', 'BBP/2026-27/0002', 'BBP/2026-27/0003'],
      );
    });

    test('a draft has no number and can be edited, then finalised', () async {
      final d = await invoices.saveDraft(draft(lines: [serviceLine(haircut)]));
      expect(d.invoiceNo, isNull);
      expect(d.status, InvoiceStatus.draft);
      final f = await invoices.finalise(draft());
      expect(f.id, d.id);
      expect(f.totalPaise, 300000);
      expect(await invoices.list(), hasLength(1));
    });

    test('GST is added when enabled in settings', () async {
      await store.transact((data) {
        data.parlour = data.parlour.copyWith(taxEnabled: true);
      });
      final bill = await invoices.finalise(
        draft(lines: [serviceLine(haircut)]),
      );
      expect(bill.taxPaise, 9000);
      expect(bill.totalPaise, 59000);
      expect(bill.taxEnabled, isTrue);
    });
  });

  group('payments', () {
    test('two partial payments close the bill', () async {
      await invoices.finalise(draft());
      var bill = await invoices.recordPayment(payment('p1', 100000));
      expect(bill.status, InvoiceStatus.partiallyPaid);
      expect(bill.paidPaise, 100000);
      expect(bill.balancePaise, 200000);

      bill = await invoices.recordPayment(payment('p2', 200000));
      expect(bill.status, InvoiceStatus.paid);
      expect(bill.balancePaise, 0);
      expect(await payments.listForInvoice('bill-1'), hasLength(2));
    });

    test('double tap with the same payment id records nothing extra', () async {
      await invoices.finalise(draft());
      await Future.wait([
        invoices.recordPayment(payment('p1', 100000)),
        invoices.recordPayment(payment('p1', 100000)),
      ]);
      final bill = await invoices.getById('bill-1');
      expect(bill!.paidPaise, 100000);
      expect(await payments.listForInvoice('bill-1'), hasLength(1));
    });

    test('double tap on finalise creates one bill and one number', () async {
      await Future.wait([
        invoices.finalise(draft()),
        invoices.finalise(draft()),
      ]);
      expect(await invoices.list(), hasLength(1));
      expect(store.data.invoiceSerials.values.single, 1);
    });

    test('cannot pay more than the balance or ₹0', () async {
      await invoices.finalise(draft());
      expect(
        () => invoices.recordPayment(payment('p1', 300001)),
        throwsA(isA<ValidationException>()),
      );
      expect(
        () => invoices.recordPayment(payment('p2', 0)),
        throwsA(isA<ValidationException>()),
      );
      expect((await invoices.getById('bill-1'))!.paidPaise, 0);
    });

    test('cannot pay a draft', () async {
      await invoices.saveDraft(draft());
      expect(
        () => invoices.recordPayment(payment('p1', 100)),
        throwsA(isA<ValidationException>()),
      );
    });

    test('a ₹0 bill is paid at once', () async {
      final bill = await invoices.finalise(
        draft(discount: const BillDiscount.percent(10000)),
      );
      expect(bill.totalPaise, 0);
      expect(bill.status, InvoiceStatus.paid);
    });
  });

  group('stock', () {
    test('selling a product reduces stock with a sale movement', () async {
      await invoices.finalise(
        draft(lines: [serviceLine(haircut), productLine(serum)]),
      );
      expect((await products.getById(serum.id))!.stockQty, 1);
      final moves = await products.movements(serum.id);
      expect(moves.single.reason, StockReason.sale);
      expect(moves.single.qtyChange, -1);
      expect(moves.single.invoiceId, 'bill-1');
    });

    test('stock never goes negative; the whole bill is rejected', () async {
      await expectLater(
        invoices.finalise(draft(lines: [productLine(serum, qty: 3)])),
        throwsA(isA<InsufficientStockException>()),
      );
      expect((await products.getById(serum.id))!.stockQty, 2);
      expect(await invoices.list(), isEmpty);
      expect(store.data.invoiceSerials, isEmpty);
    });

    test('voiding a bill restores stock and voids its payments', () async {
      await invoices.finalise(draft(lines: [productLine(serum, qty: 2)]));
      await invoices.recordPayment(payment('p1', 50000));
      expect((await products.getById(serum.id))!.stockQty, 0);

      final voided = await invoices.voidInvoice('bill-1');
      expect(voided.status, InvoiceStatus.void_);
      expect((await products.getById(serum.id))!.stockQty, 2);
      final reasons = (await products.movements(serum.id)).map((m) => m.reason);
      expect(reasons, contains(StockReason.voidReversal));
      expect((await payments.listForInvoice('bill-1')).single.isVoid, isTrue);

      // Voiding twice changes nothing.
      await invoices.voidInvoice('bill-1');
      expect((await products.getById(serum.id))!.stockQty, 2);
    });

    test('manual adjustment cannot make stock negative', () async {
      expect(
        () => products.adjustStock(
          serum.id,
          qtyChange: -5,
          reason: StockReason.damaged,
        ),
        throwsA(isA<InsufficientStockException>()),
      );
      final p = await products.adjustStock(
        serum.id,
        qtyChange: 10,
        reason: StockReason.purchase,
        note: 'Restock',
      );
      expect(p.stockQty, 12);
    });
  });

  group('one bill per appointment', () {
    test('a second bill for the same appointment is refused', () async {
      await invoices.finalise(draft(id: 'a', appointmentId: 'appt-1'));
      expect(
        () => invoices.finalise(draft(id: 'b', appointmentId: 'appt-1')),
        throwsA(isA<ValidationException>()),
      );
      expect((await invoices.findByAppointment('appt-1'))!.id, 'a');
    });

    test('after voiding, the appointment can be billed again', () async {
      await invoices.finalise(draft(id: 'a', appointmentId: 'appt-1'));
      await invoices.voidInvoice('a');
      final b = await invoices.finalise(
        draft(id: 'b', appointmentId: 'appt-1'),
      );
      expect((await invoices.findByAppointment('appt-1'))!.id, b.id);
    });
  });
}
