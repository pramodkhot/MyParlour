import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:myparlour/core/format/money.dart';
import 'package:myparlour/domain/services/dashboard_service.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_data.dart';

void main() {
  group('Welcome', () {
    testWidgets('shows the brand, demo pill and no login', (tester) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester);

      expect(find.text('MyParlour'), findsOneWidget);
      expect(find.text('Manage your parlour\nbusiness easily'), findsOneWidget);
      expect(find.text('Demo'), findsOneWidget);
      expect(find.text('Sample data · no sign-in needed'), findsOneWidget);
      expect(find.textContaining('Login'), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('button is in view on a small 360 × 640 phone', (tester) async {
      usePhoneScreen(tester, logical: const Size(360, 640));
      await pumpDemoApp(tester);
      final button = tester.getRect(find.text('Explore MyParlour'));
      expect(button.bottom, lessThan(640));
    });

    testWidgets('Explore goes to the Dashboard and Back does not return', (
      tester,
    ) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester);
      await enterApp(tester);

      expect(find.text('Explore MyParlour'), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(selectedTab(tester), 0);
      final context = tester.element(find.byType(NavigationBar));
      expect(GoRouter.of(context).canPop(), isFalse);
    });
  });

  group('Dashboard', () {
    testWidgets('figures match the seed data', (tester) async {
      usePhoneScreen(tester);
      final store = await pumpDemoApp(tester);
      await enterApp(tester);

      final data = store.data;
      final expected = DashboardService.build(
        now: testNow,
        payments: data.payments,
        invoices: data.invoices,
        appointments: data.appointments,
        customers: data.customers,
        products: data.products,
      );

      // Header (testNow is Thursday 14 May 2026, 4:12 PM).
      expect(find.text('Beauty Bliss Parlour'), findsOneWidget);
      expect(find.text('Thursday, 14 May'), findsOneWidget);
      expect(find.text('Good afternoon, Kavita'), findsOneWidget);

      // Metric cards.
      expect(find.text(Money.format(expected.todaySalesPaise)), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('3 still to come'), findsOneWidget);
      expect(find.text('₹2,150'), findsOneWidget);
      expect(find.text('3 bills due'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
      expect(find.text('Active clients'), findsOneWidget);

      // Next appointments at 4:12 PM: Sneha (checked in), Ritika, Anjali.
      // Walk-in Kiran's 2:00 PM threading has already ended.
      await tester.scrollUntilVisible(
        find.text('Anjali Singh'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Sneha Patil'), findsOneWidget);
      expect(find.text('Anjali Singh'), findsOneWidget);
      expect(find.text('Walk-in · Kiran'), findsNothing);
      expect(find.text('Ritika Kapoor'), findsOneWidget);
      expect(find.text('Checked in'), findsOneWidget);

      // Low stock.
      await tester.scrollUntilVisible(
        find.text('Face Cream'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Hair Colour'), findsOneWidget);
      expect(find.text('Out of stock'), findsOneWidget);
      expect(find.text('2 left'), findsOneWidget);
      expect(find.text('3 left'), findsOneWidget);
    });

    testWidgets('bell opens alerts with birthdays and low stock', (
      tester,
    ) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester);
      await enterApp(tester);

      await tester.tap(find.byTooltip('Alerts (new)'));
      await tester.pumpAndSettle();
      expect(find.text('Birthdays today'), findsOneWidget);
      expect(find.text('Pooja Mehta'), findsOneWidget);
      expect(find.text('Alert at 3 pcs'), findsWidgets);
    });

    testWidgets('parlour name opens the branch sheet', (tester) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester);
      await enterApp(tester);

      await tester.tap(find.text('Beauty Bliss Parlour'));
      await tester.pumpAndSettle();
      expect(find.text('More branches in the full version'), findsOneWidget);
    });

    testWidgets('metric card opens Appointments tab', (tester) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester);
      await enterApp(tester);

      await tester.tap(find.text('3 still to come'));
      await tester.pumpAndSettle();
      expect(selectedTab(tester), 1);
    });

    testWidgets('fits a 360 px phone at 130% text without overflow', (
      tester,
    ) async {
      usePhoneScreen(tester, logical: const Size(360, 640), textScale: 1.3);
      await pumpDemoApp(tester);
      expect(tester.takeException(), isNull);
      await enterApp(tester);
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.text('Face Cream'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('evening greeting on a Sunday night', (tester) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester, now: DateTime(2026, 5, 17, 20, 30));
      await enterApp(tester);
      expect(find.text('Good evening, Kavita'), findsOneWidget);
      expect(find.text('Sunday, 17 May'), findsOneWidget);
    });
  });
}
