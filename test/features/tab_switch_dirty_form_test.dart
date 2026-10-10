import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

/// Tapping a bottom tab while a form has unsaved typing must not freeze.
void main() {
  Future<void> settle(WidgetTester tester) => tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 5),
  );

  Future<void> openDirtyForm(WidgetTester tester) async {
    usePhoneScreen(tester);
    await pumpDemoApp(tester);
    await enterApp(tester);
    await openMoreSection(tester, 'Customers');
    await tester.tap(find.byTooltip('Add customer').first);
    await settle(tester);
    await typeInto(tester, 'Name', 'Half done');
    await settle(tester);
  }

  testWidgets('switching to another tab', (tester) async {
    await openDirtyForm(tester);
    await tester.tap(navItem('Dashboard'));
    await settle(tester);
    expect(selectedTab(tester), 0);
  });

  testWidgets('tapping the current tab again', (tester) async {
    await openDirtyForm(tester);
    await tester.tap(navItem('More'));
    await settle(tester);
    expect(selectedTab(tester), 3);
  });
}
