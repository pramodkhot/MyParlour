import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/domain/models/appointment.dart';

import '../helpers/pump_app.dart';

/// testNow is Thursday 14 May 2026, 4:12 PM. Today's seed: Priya (Anita,
/// 10:00, completed), Neha (Meena, 10:30, completed), Sneha (Meena, 12:30,
/// checked in), walk-in Kiran (Riya, 2:00 PM), Ritika (Anita, 3:30–5:00 PM),
/// Anjali (Riya, 5:30 PM).
void main() {
  Future<LocalStore> openAppointments(WidgetTester tester) async {
    usePhoneScreen(tester);
    final store = await pumpDemoApp(tester);
    await enterApp(tester);
    await tester.tap(navItem('Appointments'));
    await tester.pumpAndSettle();
    return store;
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find.byType(Scrollable).first,
      );

  Appointment byClient(LocalStore store, String name) {
    final customer = store.data.customers.firstWhere((c) => c.name == name);
    // Today's appointment for that customer (some also have later ones).
    return store.data.appointments.singleWhere(
      (a) =>
          a.customerId == customer.id &&
          DateUtils.isSameDay(a.startsAt, DateTime(2026, 5, 14)),
    );
  }

  testWidgets('today: week strip, counts, filters, empty day', (tester) async {
    await openAppointments(tester);

    expect(find.text('May 2026'), findsOneWidget);
    expect(find.text('All (6)'), findsOneWidget);
    expect(find.text('Upcoming (3)'), findsOneWidget);
    expect(find.text('Checked in (1)'), findsOneWidget);
    expect(find.text('Completed (2)'), findsOneWidget);
    expect(find.text('Walk-in · Kiran'), findsOneWidget);

    await tester.ensureVisible(find.text('Completed (2)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed (2)'));
    await tester.pumpAndSettle();
    expect(find.text('Priya Sharma'), findsOneWidget);
    expect(find.text('Sneha Patil'), findsNothing);

    // Sunday 17 May has no bookings.
    await tester.tap(find.text('17'));
    await tester.pumpAndSettle();
    expect(find.text('No appointments on this day'), findsOneWidget);
    expect(find.text('Book appointment'), findsOneWidget);
  });

  testWidgets('book → check in → complete', (tester) async {
    final store = await openAppointments(tester);
    await tester.tap(find.byTooltip('Book appointment'));
    await tester.pumpAndSettle();

    // Customer.
    await tester.tap(find.text('Search name or phone'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'kav');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kavya Nair'));
    await tester.pumpAndSettle();

    // Services.
    await tester.tap(find.text('Add services'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Haircut'));
    await tester.pump();
    await tester.tap(find.text('Add 1 service'));
    await tester.pumpAndSettle();

    // Next free slot (4:30 PM) and first free stylist (Riya: Anita is busy
    // with Ritika until 5:00 PM) are preselected.
    await scrollTo(tester, find.textContaining('Duration'));
    expect(find.text('Duration 30 min · ends 5:00 PM'), findsOneWidget);
    expect(find.text('Estimate ₹500'), findsOneWidget);
    expect(
      find.textContaining('Busy until 5:00 PM', findRichText: true),
      findsOneWidget,
    );

    await tester.tap(find.text('Book appointment'));
    await tester.pumpAndSettle();
    await clearMessages(tester);

    final booked = byClient(store, 'Kavya Nair');
    expect(booked.status, AppointmentStatus.booked);
    expect(booked.startsAt, DateTime(2026, 5, 14, 16, 30));
    expect(
      store.data.staff.firstWhere((s) => s.id == booked.staffId).name,
      'Riya',
    );
    expect(find.text('Kavya Nair'), findsOneWidget);

    await tester.tap(find.text('Check in'));
    await tester.pumpAndSettle();
    await clearMessages(tester);
    expect(byClient(store, 'Kavya Nair').status, AppointmentStatus.checkedIn);

    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();
    await clearMessages(tester);
    expect(byClient(store, 'Kavya Nair').status, AppointmentStatus.completed);
    expect(find.text('Create bill'), findsOneWidget);
    final kavya = store.data.customers.firstWhere(
      (c) => c.name == 'Kavya Nair',
    );
    expect(kavya.lastVisitAt, DateTime(2026, 5, 14, 16, 30));
  });

  testWidgets('overlap shows the clash; pick another time or book anyway', (
    tester,
  ) async {
    final store = await openAppointments(tester);
    await tester.tap(find.byTooltip('Book appointment'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Walk-in'));
    await tester.pumpAndSettle();
    await typeInto(tester, 'Walk-in name', 'Meera');
    await tester.tap(find.text('Add services'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Haircut'));
    await tester.pump();
    await tester.tap(find.text('Add 1 service'));
    await tester.pumpAndSettle();

    // Choose Anita at 4:30 PM, while she is with Ritika until 5:00 PM.
    await scrollTo(tester, find.text('Anita'));
    await tester.tap(find.text('Anita'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Book appointment'));
    await tester.pumpAndSettle();
    expect(find.text('Anita is already booked'), findsOneWidget);
    expect(find.text('3:30 PM – 5:00 PM'), findsOneWidget);

    await tester.tap(find.text('Pick another time'));
    await tester.pumpAndSettle();
    expect(find.text('New appointment'), findsOneWidget);
    expect(
      store.data.appointments.where((a) => a.walkInName == 'Meera'),
      isEmpty,
    );

    await tester.tap(find.text('Book appointment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book anyway'));
    await tester.pumpAndSettle();
    await clearMessages(tester);
    final meera = store.data.appointments.singleWhere(
      (a) => a.walkInName == 'Meera',
    );
    expect(meera.startsAt, DateTime(2026, 5, 14, 16, 30));
    expect(find.text('Walk-in · Meera'), findsOneWidget);
  });

  testWidgets('required fields are checked', (tester) async {
    await openAppointments(tester);
    await tester.tap(find.byTooltip('Book appointment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book appointment'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a customer or add a walk-in.'), findsOneWidget);
    expect(find.text('Choose at least one service.'), findsOneWidget);
  });

  testWidgets('cancel with a reason; it stays in the customer history', (
    tester,
  ) async {
    final store = await openAppointments(tester);
    await scrollTo(tester, find.text('Anjali Singh'));
    await tester.tap(find.text('Anjali Singh'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel appointment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customer unwell'));
    await tester.pump();
    await tester.tap(find.text('Cancel appointment').last);
    await tester.pumpAndSettle();
    await clearMessages(tester);

    final a = byClient(store, 'Anjali Singh');
    expect(a.status, AppointmentStatus.cancelled);
    expect(a.cancelReason, 'Customer unwell');
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Customer unwell'), findsOneWidget);
    expect(find.text('Check in'), findsNothing);

    // Customer history still lists it.
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open customer'));
    await tester.pumpAndSettle();
    expect(find.text('Cancelled'), findsOneWidget);
  });

  testWidgets('reschedule moves the time', (tester) async {
    final store = await openAppointments(tester);
    await scrollTo(tester, find.text('Anjali Singh'));
    await tester.tap(find.text('Anjali Singh'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reschedule'));
    await tester.pumpAndSettle();

    expect(find.text('Reschedule'), findsOneWidget);
    await scrollTo(tester, find.text('7:00 PM'));
    await tester.tap(find.text('7:00 PM'));
    await tester.pump();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    await clearMessages(tester);

    final a = byClient(store, 'Anjali Singh');
    expect(a.startsAt, DateTime(2026, 5, 14, 19));
    expect(a.endsAt, DateTime(2026, 5, 14, 20));
    expect(find.text('7:00 PM – 8:00 PM'), findsOneWidget);
  });

  testWidgets('mark no-show', (tester) async {
    final store = await openAppointments(tester);
    await scrollTo(tester, find.text('Ritika Kapoor'));
    await tester.tap(find.text('Ritika Kapoor'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark no-show'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark no-show').last);
    await tester.pumpAndSettle();
    expect(byClient(store, 'Ritika Kapoor').status, AppointmentStatus.noShow);
  });

  testWidgets('New appointment from a customer is pre-filled', (tester) async {
    usePhoneScreen(tester);
    await pumpDemoApp(tester);
    await enterApp(tester);
    await openMoreSection(tester, 'Customers');
    await tester.enterText(find.byType(TextField).first, 'divya');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Divya Iyer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New appointment'));
    await tester.pumpAndSettle();
    expect(find.text('Divya Iyer · 94420 44556'), findsOneWidget);
    expect(selectedTab(tester), 1);
  });
}
