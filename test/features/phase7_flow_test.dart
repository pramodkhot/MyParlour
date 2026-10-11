import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/core/format/money.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/domain/models/date_range.dart';
import 'package:myparlour/domain/models/stock_movement.dart';
import 'package:myparlour/domain/services/report_service.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_data.dart';

void main() {
  Future<LocalStore> start(WidgetTester tester) async {
    usePhoneScreen(tester);
    final store = await pumpDemoApp(tester);
    await enterApp(tester);
    return store;
  }

  Finder inList(String text) =>
      find.descendant(of: find.byType(ListView), matching: find.text(text));

  group('More', () {
    testWidgets('rows show live figures', (tester) async {
      await start(tester);
      await tester.tap(navItem('More'));
      await tester.pumpAndSettle();
      expect(find.text('Beauty Bliss Parlour · Owner'), findsOneWidget);
      expect(find.text('14 customers'), findsOneWidget);
      expect(find.text('3 active'), findsOneWidget);
      expect(find.text('10 services'), findsOneWidget);
      expect(find.text('3 low'), findsOneWidget);
    });
  });

  group('Inventory', () {
    testWidgets('tabs, Restock link, stock in and count correction', (
      tester,
    ) async {
      final store = await start(tester);

      // Dashboard "Restock" opens the Low stock tab.
      await scrollAndTap(tester, find.text('Restock'));
      expect(find.text('All items (8)'), findsOneWidget);
      expect(find.text('Low stock (2)'), findsOneWidget);
      expect(find.text('Out of stock (1)'), findsOneWidget);
      expect(find.text('Hair Serum'), findsOneWidget);
      expect(find.text('Shampoo'), findsNothing);

      await tester.tap(find.text('Hair Serum'));
      await tester.pumpAndSettle();
      expect(find.text('Stock history'), findsOneWidget);

      // Stock in 5 → 7.
      await tester.tap(find.text('Adjust stock'));
      await tester.pumpAndSettle();
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byTooltip('Increase'));
        await tester.pump();
      }
      expect(find.text('New stock: 7 pcs'), findsOneWidget);
      await typeInto(tester, 'Note', 'Supplier delivery');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      await clearMessages(tester);
      final serum = store.data.products.firstWhere(
        (p) => p.name == 'Hair Serum',
      );
      expect(serum.stockQty, 7);
      expect(find.text('Supplier delivery'), findsNothing); // part of a line
      expect(find.textContaining('Supplier delivery'), findsOneWidget);

      // Count correction to 6 → change −1.
      await tester.tap(find.text('Adjust stock'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Count correction'));
      await tester.pump();
      await tester.tap(find.byTooltip('Decrease'));
      await tester.pump();
      expect(find.text('New stock: 6 pcs'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      final moves = store.data.stockMovements
          .where((m) => m.productId == serum.id)
          .toList();
      expect(moves.last.reason, StockReason.correction);
      expect(moves.last.qtyChange, -1);
      expect(
        store.data.products.firstWhere((p) => p.id == serum.id).stockQty,
        6,
      );
    });

    testWidgets('adding a product records its opening stock', (tester) async {
      final store = await start(tester);
      await openMoreSection(tester, 'Inventory');
      await tester.tap(find.byTooltip('Add product').first);
      await tester.pumpAndSettle();
      await typeInto(tester, 'Name', 'Hair Mask');
      await typeInto(tester, 'Opening stock', '5');
      await typeInto(tester, 'Selling price', '350');
      await tester.tap(find.text('Save product'));
      await tester.pumpAndSettle();
      final mask = store.data.products.firstWhere((p) => p.name == 'Hair Mask');
      expect(mask.stockQty, 5);
      expect(mask.lowStockAt, 2);
      expect(mask.sellingPricePaise, 35000);
      expect(
        store.data.stockMovements
            .where((m) => m.productId == mask.id)
            .single
            .reason,
        StockReason.purchase,
      );
    });
  });

  group('Expenses', () {
    testWidgets('month total; add, edit and delete', (tester) async {
      final store = await start(tester);
      final may = DateRange(DateTime(2026, 5), DateTime(2026, 6));
      int mayTotal() => store.data.expenses
          .where((e) => may.contains(e.spentOn))
          .fold(0, (s, e) => s + e.amountPaise);
      final before = mayTotal();

      await openMoreSection(tester, 'Expenses');
      expect(find.text('May 2026'), findsOneWidget);
      expect(find.text(Money.format(before)), findsOneWidget);

      await tester.tap(find.byTooltip('Add expense').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '450');
      await tester.tap(find.text('Electricity'));
      await tester.pump();
      await tester.tap(find.text('Save expense'));
      await tester.pumpAndSettle();
      await clearMessages(tester);
      expect(mayTotal(), before + 45000);
      expect(find.text(Money.format(before + 45000)), findsOneWidget);

      // Delete it again.
      await tester.tap(inList('₹450').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete expense'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(mayTotal(), before);
    });

    testWidgets('category is required', (tester) async {
      await start(tester);
      await openMoreSection(tester, 'Expenses');
      await tester.tap(find.byTooltip('Add expense').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '100');
      await tester.tap(find.text('Save expense'));
      await tester.pumpAndSettle();
      expect(find.text('Choose a category.'), findsOneWidget);
    });
  });

  group('Reports', () {
    testWidgets('this month matches the data; Today from the dashboard', (
      tester,
    ) async {
      final store = await start(tester);
      final month = ReportService.build(
        range: ReportService.rangeFor(ReportPeriod.thisMonth, testNow),
        payments: store.data.payments,
        invoices: store.data.invoices,
        expenses: store.data.expenses,
      );

      await openMoreSection(tester, 'Reports');
      expect(find.text('This month'), findsOneWidget);
      expect(find.text(Money.format(month.salesPaise)), findsOneWidget);
      expect(find.text(Money.format(month.expensesPaise)), findsOneWidget);
      expect(
        find.text(Money.format(month.netProfitEstimatePaise)),
        findsOneWidget,
      );
      expect(find.text('${month.billCount}'), findsOneWidget);
      expect(find.text('Net profit (estimate)'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Payment methods'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(month.topServices.first.name), findsWidgets);

      // Dashboard "Today's sales" opens Today.
      await tester.tap(navItem('Dashboard'));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Today's sales"));
      await tester.pumpAndSettle();
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Thursday, 14 May 2026'), findsOneWidget);
    });

    testWidgets('empty period shows the empty state', (tester) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester, now: DateTime(2030, 1, 15, 12));
      await enterApp(tester);
      await openMoreSection(tester, 'Settings');
      await scrollAndTap(tester, find.text('Start empty'));
      await tester.tap(find.text('Start empty').last);
      await tester.pumpAndSettle();
      await clearMessages(tester);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reports'));
      await tester.pumpAndSettle();
      expect(
        find.text('No sales, bills or expenses in this period.'),
        findsOneWidget,
      );
    });
  });

  group('Settings', () {
    testWidgets('edit profile; GST on shows on new bills', (tester) async {
      final store = await start(tester);
      await openMoreSection(tester, 'Settings');

      await tester.tap(find.text('Edit').first);
      await tester.pumpAndSettle();
      await typeInto(tester, 'Parlour name', 'Glow Studio');
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();
      await clearMessages(tester);
      expect(store.data.parlour.name, 'Glow Studio');

      await tester.tap(find.text('Edit').at(2));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Charge GST'));
      await tester.pumpAndSettle();
      await typeInto(tester, 'GSTIN', '27ABCDE1234F1Z5');
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();
      await clearMessages(tester);
      expect(store.data.parlour.taxEnabled, isTrue);
      expect(store.data.parlour.gstin, '27ABCDE1234F1Z5');

      await tester.tap(navItem('Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Glow Studio'), findsOneWidget);
      expect(find.text('GS'), findsOneWidget);

      await tester.tap(navItem('Billing'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New bill'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add service or product'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Haircut'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('GST'));
      expect(find.text('₹90'), findsOneWidget);
      expect(find.text('₹590'), findsOneWidget);
    });

    testWidgets('reset demo data restores the sample data', (tester) async {
      final store = await start(tester);
      await openMoreSection(tester, 'Settings');
      await scrollAndTap(tester, find.text('Start empty'));
      await tester.tap(find.text('Start empty').last);
      await tester.pumpAndSettle();
      await clearMessages(tester);
      expect(store.data.customers, isEmpty);
      expect(store.data.invoices, isEmpty);
      expect(store.data.parlour.name, 'Beauty Bliss Parlour');

      await tester.tap(find.text('Reset demo data'));
      await tester.pumpAndSettle();
      expect(find.text('Reset demo data?'), findsOneWidget);
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(find.text('Demo data restored'), findsOneWidget);
      expect(store.data.customers, hasLength(14));
      expect(store.data.services, hasLength(10));
      expect(store.data.products, hasLength(8));
      expect(
        store.data.invoices
            .where((i) => i.isOpen)
            .fold(0, (s, i) => s + i.balancePaise),
        215000,
      );

      await tester.tap(navItem('Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('₹2,150'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
    });
  });
}
