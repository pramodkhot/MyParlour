import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:myparlour/app/routes.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/domain/models/appointment.dart';

import '../helpers/pump_app.dart';

/// Phase 8: Flutter's accessibility guidelines on the main screens —
/// 48 px tap targets (spec Section 8), labels on tappable things, and
/// readable text contrast.
void main() {
  final screens = <String, String Function(LocalStore)>{
    'dashboard': (_) => Routes.dashboard,
    'appointments': (_) => Routes.appointments,
    'appointment': (s) => Routes.appointment(
      s.data.appointments
          .firstWhere((a) => a.status == AppointmentStatus.booked)
          .id,
    ),
    'new appointment': (s) =>
        Routes.newAppointment(customerId: s.data.customers.first.id),
    'billing': (_) => Routes.billing,
    'payment': (s) =>
        Routes.payBill(s.data.invoices.firstWhere((i) => i.isOpen).id),
    'customers': (_) => Routes.customers,
    'customer': (s) => Routes.customer(s.data.customers.first.id),
    'inventory': (_) => Routes.inventory,
    'reports': (_) => Routes.reports,
    'more': (_) => Routes.more,
    'settings': (_) => Routes.settings,
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key} meets accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      usePhoneScreen(tester);
      final store = await pumpDemoApp(tester);
      await enterApp(tester);
      GoRouter.of(
        tester.element(find.byType(NavigationBar)),
      ).go(entry.value(store));
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }
}
