import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:myparlour/app/routes.dart';
import 'package:myparlour/core/l10n/app_language.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/domain/models/appointment.dart';

import '../helpers/pump_app.dart';

/// Phase 8: every screen on a small 360 × 640 phone with text at 130%, in
/// every language (Devanagari text is taller and often longer).
/// Any layout overflow fails the test for that screen.
void main() {
  // Each entry builds the path from the demo data.
  final screens = <String, String Function(LocalStore)>{
    'dashboard': (_) => Routes.dashboard,
    'appointments': (_) => Routes.appointments,
    'appointment (checked in)': (s) => Routes.appointment(
      s.data.appointments
          .firstWhere((a) => a.status == AppointmentStatus.checkedIn)
          .id,
    ),
    'appointment (completed)': (s) => Routes.appointment(
      s.data.appointments
          .firstWhere((a) => a.status == AppointmentStatus.completed)
          .id,
    ),
    'new appointment': (s) =>
        Routes.newAppointment(customerId: s.data.customers.first.id),
    'reschedule': (s) => Routes.rescheduleAppointment(
      s.data.appointments
          .firstWhere((a) => a.status == AppointmentStatus.booked)
          .id,
    ),
    'billing': (_) => Routes.billing,
    'all bills': (_) => '/billing?filter=all',
    'new bill from appointment': (s) => Routes.newBill(
      appointmentId: s.data.appointments
          .firstWhere((a) => a.status == AppointmentStatus.checkedIn)
          .id,
    ),
    'bill': (s) => Routes.bill(s.data.invoices.firstWhere((i) => i.isOpen).id),
    'payment': (s) =>
        Routes.payBill(s.data.invoices.firstWhere((i) => i.isOpen).id),
    'payment success': (s) {
      final p = s.data.payments.first;
      return Routes.paymentDone(p.invoiceId, p.id);
    },
    'more': (_) => Routes.more,
    'customers': (_) => Routes.customers,
    'customer': (s) => Routes.customer(s.data.customers.first.id),
    'new customer': (_) => Routes.newCustomer,
    'edit customer': (s) => Routes.editCustomer(s.data.customers.first.id),
    'services': (_) => Routes.services,
    'new service': (_) => Routes.newService,
    'edit service': (s) => Routes.editService(s.data.services.first.id),
    'staff': (_) => Routes.staff,
    'staff member': (s) => Routes.staffMember(s.data.staff.first.id),
    'new staff': (_) => Routes.newStaff,
    'inventory': (_) => Routes.inventory,
    'product': (s) => Routes.product(s.data.products.first.id),
    'new product': (_) => Routes.newProduct,
    'edit product': (s) => Routes.editProduct(s.data.products.first.id),
    'expenses': (_) => Routes.expenses,
    'new expense': (_) => Routes.newExpense,
    'edit expense': (s) => Routes.editExpense(s.data.expenses.first.id),
    'reports': (_) => Routes.reports,
    'reports today': (_) => Routes.reportsToday,
    'settings': (_) => Routes.settings,
    'settings profile': (_) => Routes.settingsProfile,
    'settings hours': (_) => Routes.settingsHours,
    'settings billing': (_) => Routes.settingsBilling,
  };

  for (final language in AppLanguage.values) {
    for (final entry in screens.entries) {
      testWidgets('${entry.key} fits 360 px at 130% text (${language.name})', (
        tester,
      ) async {
        usePhoneScreen(tester, logical: const Size(360, 640), textScale: 1.3);
        final store = await pumpDemoApp(tester, language: language);
        await enterApp(tester);

        final context = tester.element(find.byType(NavigationBar));
        GoRouter.of(context).go(entry.value(store));
        await tester.pumpAndSettle();

        // Scroll every list on screen to the end so all of it is laid out.
        for (var i = 0; i < 12; i++) {
          final scrollables = find.byType(Scrollable).hitTestable();
          if (scrollables.evaluate().isEmpty) break;
          await tester.drag(scrollables.first, const Offset(0, -400));
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
