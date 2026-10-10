import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/service_item.dart';

import '../helpers/pump_app.dart';

void main() {
  group('Services', () {
    testWidgets('grouped list; add with a new category; edit; deactivate', (
      tester,
    ) async {
      usePhoneScreen(tester);
      final store = await pumpDemoApp(tester);
      await enterApp(tester);
      await openMoreSection(tester, 'Services');

      expect(find.text('Hair'), findsOneWidget);
      expect(find.text('Haircut'), findsOneWidget);
      expect(find.text('₹500'), findsOneWidget);

      // Add with a new category.
      await tester.tap(find.byTooltip('Add service').first);
      await tester.pumpAndSettle();
      await typeInto(tester, 'Service name', 'Bridal makeup');
      await tester.tap(find.text('New category'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Bridal');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      await typeInto(tester, 'Price', '8000');
      await tester.tap(find.text('2 h'));
      await tester.pump();
      await tester.tap(find.text('Save service'));
      await tester.pumpAndSettle();
      await clearMessages(tester);

      final bridal = store.data.services.firstWhere(
        (s) => s.name == 'Bridal makeup',
      );
      expect(bridal.category, 'Bridal');
      expect(bridal.pricePaise, 800000);
      expect(bridal.durationMin, 120);
      expect(bridal.taxRateBp, 1800);
      await tester.scrollUntilVisible(
        find.text('Bridal makeup'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('₹8,000'), findsOneWidget);

      // Edit Haircut's price, then deactivate it.
      await tester.scrollUntilVisible(
        find.text('Haircut'),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Haircut'));
      await tester.pumpAndSettle();
      await typeInto(tester, 'Price', '550');
      await tester.tap(find.text('Save service'));
      await tester.pumpAndSettle();
      await clearMessages(tester);
      expect(find.text('₹550'), findsOneWidget);

      await tester.tap(find.text('Haircut'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Deactivate service'));
      await tester.tap(find.text('Deactivate service'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();
      final haircut = store.data.services.firstWhere(
        (ServiceItem s) => s.name == 'Haircut',
      );
      expect(haircut.isActive, isFalse);
      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('required fields are checked', (tester) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester);
      await enterApp(tester);
      await openMoreSection(tester, 'Services');
      await tester.tap(find.byTooltip('Add service').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save service'));
      await tester.pumpAndSettle();
      expect(find.text('Enter the service name.'), findsOneWidget);
      expect(find.text('Enter the price in rupees.'), findsOneWidget);
      expect(find.text('Choose a category.'), findsOneWidget);
    });
  });

  group('Staff', () {
    testWidgets('inactive grouped at the bottom; detail shows month figures', (
      tester,
    ) async {
      usePhoneScreen(tester);
      await pumpDemoApp(tester);
      await enterApp(tester);
      await openMoreSection(tester, 'Staff');

      final inactiveHeader = tester.getTopLeft(find.text('Inactive').first);
      final pooja = tester.getTopLeft(find.text('Pooja'));
      final anita = tester.getTopLeft(find.text('Anita'));
      expect(anita.dy, lessThan(inactiveHeader.dy));
      expect(pooja.dy, greaterThan(inactiveHeader.dy));

      await tester.tap(find.text('Anita'));
      await tester.pumpAndSettle();
      expect(find.text('Senior Beautician'), findsOneWidget);
      expect(find.text('This month'), findsOneWidget);
      expect(find.text('Services done'), findsOneWidget);
      // Today she has Priya (completed) and Ritika (booked).
      await tester.scrollUntilVisible(
        find.text('Ritika Kapoor'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Priya Sharma'), findsWidgets);
    });

    testWidgets('add staff, then deactivate and reactivate', (tester) async {
      usePhoneScreen(tester);
      final store = await pumpDemoApp(tester);
      await enterApp(tester);
      await openMoreSection(tester, 'Staff');

      await tester.tap(find.byTooltip('Add staff').first);
      await tester.pumpAndSettle();
      await typeInto(tester, 'Name', 'Sana');
      await typeInto(tester, 'Mobile number', '9876555555');
      await tester.ensureVisible(find.text('Receptionist'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Receptionist'));
      await tester.pump();
      await tester.ensureVisible(find.text('Save staff'));
      await tester.tap(find.text('Save staff'));
      await tester.pumpAndSettle();
      await clearMessages(tester);

      final sana = store.data.staff.firstWhere((s) => s.name == 'Sana');
      expect(sana.roleTitle, 'Receptionist');
      expect(sana.workingDays, [1, 2, 3, 4, 5, 6]);
      expect(sana.serviceIds, hasLength(10));
      expect(find.text('Sana'), findsOneWidget);

      await tester.ensureVisible(find.text('Sana'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sana'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Deactivate'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deactivate').last);
      await tester.pumpAndSettle();
      await clearMessages(tester);
      expect(
        store.data.staff.firstWhere((s) => s.name == 'Sana').isActive,
        isFalse,
      );
      await tester.ensureVisible(find.text('Activate'));
      await tester.tap(find.text('Activate'));
      await tester.pumpAndSettle();
      expect(
        store.data.staff.firstWhere((s) => s.name == 'Sana').isActive,
        isTrue,
      );
    });
  });
}
