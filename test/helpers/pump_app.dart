import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myparlour/app/app.dart';
import 'package:myparlour/data/demo/demo_seed.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/data/providers.dart';

import 'test_data.dart';

/// Sets a phone-sized screen (default: 412 × 915, a common Android size).
void usePhoneScreen(
  WidgetTester tester, {
  Size logical = const Size(412, 915),
  double textScale = 1,
}) {
  tester.view.devicePixelRatio = 2.625;
  tester.view.physicalSize = logical * 2.625;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

/// Opens a store seeded with the demo data for [now] (file IO runs outside
/// the fake clock) and pumps the whole app on the Welcome screen.
Future<LocalStore> pumpDemoApp(WidgetTester tester, {DateTime? now}) async {
  final clock = now ?? testNow;
  await initializeDateFormatting('en_IN');
  final store = (await tester.runAsync(
    () => openTestStore(
      seeder: (t) => DemoSeed.build(t, sequentialIds('demo')),
      clock: () => clock,
    ),
  ))!;
  addTearDown(() => tester.runAsync(() => deleteTestStore(store)));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        clockProvider.overrideWithValue(() => clock),
      ],
      child: const MyParlourApp(),
    ),
  );
  await tester.pumpAndSettle();
  return store;
}

/// Taps "Explore MyParlour" on the Welcome screen.
Future<void> enterApp(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Explore MyParlour'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Explore MyParlour'));
  await tester.pumpAndSettle();
}

Finder navItem(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

int selectedTab(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;
