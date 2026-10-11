import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myparlour/core/platform/receipt_actions.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/models/stock_movement.dart';

import '../helpers/pump_app.dart';

class MockReceiptActions extends Mock implements ReceiptActions {}

void main() {
  late MockReceiptActions receipts;

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    receipts = MockReceiptActions();
    when(
      () => receipts.share(
        any(),
        fileName: any(named: 'fileName'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => receipts.print(any(), fileName: any(named: 'fileName')),
    ).thenAnswer((_) async => false);
    when(
      () => receipts.download(any(), fileName: any(named: 'fileName')),
    ).thenAnswer((_) async => true);
  });

  Future<LocalStore> start(WidgetTester tester) async {
    usePhoneScreen(tester);
    final store = await pumpDemoApp(
      tester,
      overrides: [receiptActionsProvider.overrideWithValue(receipts)],
    );
    await enterApp(tester);
    return store;
  }

  Future<void> settle(WidgetTester tester) async {
    // Receipt PDFs load fonts and build outside the fake clock.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> addItem(WidgetTester tester, String tab, String name) async {
    await tester.ensureVisible(find.text('Add service or product'));
    await tester.tap(find.text('Add service or product'));
    await tester.pumpAndSettle();
    if (tab == 'Products') {
      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text(name).last);
    await tester.pumpAndSettle();
  }

  Future<void> setAmount(WidgetTester tester, String rupees) =>
      typeInto(tester, 'Amount received', rupees);

  testWidgets(
    'bill with discount; two partial payments close it; stock drops',
    (tester) async {
      final store = await start(tester);
      final invoicesBefore = store.data.invoices.length;

      await tester.tap(navItem('Billing'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New bill'));
      await tester.pumpAndSettle();

      // Customer: Kavya Nair.
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose a saved customer'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'kav');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kavya Nair'));
      await tester.pumpAndSettle();

      // Haircut ₹500 + Hair Serum ₹450, 10% off → ₹855.
      await addItem(tester, 'Services', 'Haircut');
      await addItem(tester, 'Products', 'Hair Serum');
      await tester.enterText(
        find
            .descendant(of: find.byType(Row), matching: find.byType(TextField))
            .last,
        '10',
      );
      await tester.tap(find.text('%'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Subtotal'));
      expect(find.text('₹950'), findsOneWidget);
      expect(find.text('− ₹95'), findsOneWidget);
      expect(find.text('₹855'), findsOneWidget);

      // Double tap on Proceed creates one bill.
      await tester.tap(find.text('Proceed to payment'));
      await tester.tap(find.text('Proceed to payment'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(store.data.invoices.length, invoicesBefore + 1);
      final bill = store.data.invoices.last;
      expect(bill.totalPaise, 85500);
      expect(bill.discountPaise, 9500);
      expect(bill.status, InvoiceStatus.finalised);

      // Product sold: stock 2 → 1 with a sale movement.
      final serum = store.data.products.firstWhere(
        (p) => p.name == 'Hair Serum',
      );
      expect(serum.stockQty, 1);
      expect(
        store.data.stockMovements.where(
          (m) => m.invoiceId == bill.id && m.reason == StockReason.sale,
        ),
        hasLength(1),
      );

      // First payment: ₹500 cash (amount prefilled with the balance).
      expect(find.text('Confirm ₹855'), findsOneWidget);
      await setAmount(tester, '500');
      expect(find.textContaining('₹355 will still be due'), findsOneWidget);
      await tester.tap(find.text('Confirm ₹500'));
      await tester.tap(find.text('Confirm ₹500'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Payment recorded'), findsOneWidget);
      expect(find.textContaining('₹500 by Cash'), findsOneWidget);
      expect(find.text('Partially paid'), findsOneWidget);
      expect(
        store.data.payments.where((p) => p.invoiceId == bill.id),
        hasLength(1),
      );

      // Close → bill → Record payment for the rest by UPI.
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Record payment'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm ₹355'), findsOneWidget);
      await tester.tap(find.text('UPI'));
      await tester.pumpAndSettle();
      expect(
        find.text('Records the payment; the app does not verify UPI.'),
        findsOneWidget,
      );
      await typeInto(tester, 'UPI ref', '482193');
      await tester.tap(find.text('Confirm ₹355'));
      await tester.pumpAndSettle();
      expect(find.text('Payment recorded'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);

      final paid = store.data.invoices.firstWhere((i) => i.id == bill.id);
      expect(paid.status, InvoiceStatus.paid);
      expect(paid.balancePaise, 0);
      final payments = store.data.payments.where((p) => p.invoiceId == bill.id);
      expect(payments.map((p) => p.method), [
        PaymentMethod.cash,
        PaymentMethod.upi,
      ]);
      expect(payments.last.reference, '482193');

      // Receipt actions.
      await tester.tap(find.text('Share receipt on WhatsApp'));
      await settle(tester);
      verify(
        () => receipts.share(
          any(),
          fileName: 'Receipt-${paid.invoiceNo!.replaceAll('/', '-')}.pdf',
          text: any(named: 'text'),
        ),
      ).called(1);
      await tester.tap(find.text('Print receipt'));
      await settle(tester);
      expect(
        find.text('Could not open printing on this phone.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('cannot pay more than the balance', (tester) async {
    final store = await start(tester);
    final open = store.data.invoices.firstWhere((i) => i.isOpen);
    await tester.tap(find.text('3 bills due'));
    await tester.pumpAndSettle();
    expect(selectedTab(tester), 2);
    await tester.tap(find.text(open.invoiceNo!));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Record payment'));
    await tester.pumpAndSettle();
    await setAmount(tester, '99999');
    expect(find.text('Amount is more than the balance due.'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets('bill from a completed appointment', (tester) async {
    final store = await start(tester);
    await tester.tap(navItem('Appointments'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sneha Patil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create bill'));
    await tester.pumpAndSettle();

    expect(selectedTab(tester), 2);
    expect(find.text('Sneha Patil'), findsOneWidget);
    expect(find.text('Manicure'), findsOneWidget);
    expect(find.text('Stylist: Meena'), findsNWidgets(2));
    await tester.ensureVisible(find.text('Total'));
    expect(find.text('₹1,300'), findsNWidgets(2)); // subtotal and total

    await tester.tap(find.text('Proceed to payment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm ₹1,300'));
    await tester.pumpAndSettle();
    expect(find.text('Payment recorded'), findsOneWidget);

    final sneha = store.data.customers.firstWhere(
      (c) => c.name == 'Sneha Patil',
    );
    final appt = store.data.appointments.firstWhere(
      (a) =>
          a.customerId == sneha.id && a.status == AppointmentStatus.completed,
    );
    final bill = store.data.invoices.singleWhere(
      (i) => i.appointmentId == appt.id,
    );
    expect(bill.status, InvoiceStatus.paid);
    expect(bill.items.every((i) => i.staffId == appt.staffId), isTrue);
  });

  testWidgets('save a draft, find it in open bills, finish it later', (
    tester,
  ) async {
    final store = await start(tester);
    await tester.tap(navItem('Billing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New bill'));
    await tester.pumpAndSettle();
    await addItem(tester, 'Services', 'Threading');
    await tester.tap(find.text('Save draft'));
    await tester.pumpAndSettle();

    final draft = store.data.invoices.singleWhere((i) => i.isDraft);
    expect(draft.invoiceNo, isNull);
    expect(draft.walkInName, 'Walk-in');
    expect(find.text('Draft bill'), findsOneWidget);

    await tester.tap(find.text('Draft bill'));
    await tester.pumpAndSettle();
    expect(find.text('Threading'), findsOneWidget);
    await tester.tap(find.text('Proceed to payment'));
    await tester.pumpAndSettle();
    final finished = store.data.invoices.firstWhere((i) => i.id == draft.id);
    expect(finished.invoiceNo, startsWith('BBP/'));
    expect(find.text('Confirm ₹50'), findsOneWidget);
  });

  testWidgets('void a bill puts products back and voids payments', (
    tester,
  ) async {
    final store = await start(tester);
    final sold = store.data.stockMovements.firstWhere(
      (m) => m.reason == StockReason.sale,
    );
    final bill = store.data.invoices.firstWhere((i) => i.id == sold.invoiceId);
    final product = store.data.products.firstWhere(
      (p) => p.id == sold.productId,
    );

    await tester.tap(navItem('Billing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All bills'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(bill.invoiceNo!),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(bill.invoiceNo!));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Void bill'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Void bill').last);
    await tester.pumpAndSettle();

    expect(
      store.data.invoices.firstWhere((i) => i.id == bill.id).status,
      InvoiceStatus.void_,
    );
    expect(
      store.data.products.firstWhere((p) => p.id == product.id).stockQty,
      product.stockQty - sold.qtyChange,
    );
    expect(
      store.data.payments
          .where((p) => p.invoiceId == bill.id)
          .every((p) => p.isVoid),
      isTrue,
    );
    expect(find.textContaining('This bill is void.'), findsOneWidget);
  });
}
