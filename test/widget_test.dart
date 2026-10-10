import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('all four tabs open', (tester) async {
    usePhoneScreen(tester);
    await pumpDemoApp(tester);
    await enterApp(tester);

    const tabs = ['Appointments', 'Billing', 'More', 'Dashboard'];
    const expectedIndex = [1, 2, 3, 0];
    for (var i = 0; i < tabs.length; i++) {
      await tester.tap(navItem(tabs[i]));
      await tester.pumpAndSettle();
      expect(selectedTab(tester), expectedIndex[i], reason: tabs[i]);
    }
    expect(find.textContaining('Good '), findsOneWidget);
  });

  testWidgets('screens opened from More keep More highlighted', (tester) async {
    usePhoneScreen(tester);
    await pumpDemoApp(tester);
    await enterApp(tester);

    await tester.tap(navItem('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customers'));
    await tester.pumpAndSettle();

    expect(find.text('Search name or phone'), findsOneWidget);
    expect(selectedTab(tester), 3);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(selectedTab(tester), 3);
  });
}
