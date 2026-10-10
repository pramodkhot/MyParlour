import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myparlour/app/app.dart';

Finder _navItem(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

int _selectedTab(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: MyParlourApp()));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('en_IN'));

  testWidgets('opens on the Dashboard tab', (tester) async {
    await _pumpApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(_selectedTab(tester), 0);
    expect(find.textContaining('Good '), findsOneWidget);
  });

  testWidgets('all four tabs open', (tester) async {
    await _pumpApp(tester);

    const tabs = ['Appointments', 'Billing', 'More', 'Dashboard'];
    const expectedIndex = [1, 2, 3, 0];
    for (var i = 0; i < tabs.length; i++) {
      await tester.tap(_navItem(tabs[i]));
      await tester.pumpAndSettle();
      expect(_selectedTab(tester), expectedIndex[i], reason: tabs[i]);
    }
    expect(find.textContaining('Good '), findsOneWidget);
  });

  testWidgets('screens opened from More keep More highlighted', (tester) async {
    await _pumpApp(tester);

    await tester.tap(_navItem('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customers'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Customers will be ready'), findsOneWidget);
    expect(_selectedTab(tester), 3);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(_selectedTab(tester), 3);
  });
}
