import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:myparlour/app/routes.dart';
import 'package:myparlour/core/l10n/app_language.dart';
import 'package:myparlour/core/l10n/l10n.dart';

import '../helpers/memory_store_file.dart';
import '../helpers/pump_app.dart';

AppLocalizations _l10n(AppLanguage language) =>
    lookupAppLocalizations(Locale(language.name));

Future<void> _openSettings(WidgetTester tester) async {
  GoRouter.of(tester.element(find.byType(NavigationBar))).go(Routes.settings);
  await tester.pumpAndSettle();
}

Future<void> _pick(WidgetTester tester, AppLanguage language) async {
  final option = find.byKey(Key('language.${language.name}'));
  await tester.ensureVisible(option);
  await tester.pumpAndSettle();
  await tester.tap(option);
  await tester.pumpAndSettle();
}

void main() {
  final mr = _l10n(AppLanguage.mr);
  final hi = _l10n(AppLanguage.hi);

  testWidgets(
    'choosing मराठी on Welcome shows the app and sample data in Marathi',
    (tester) async {
      usePhoneScreen(tester);
      final store = await pumpDemoApp(tester);
      expect(store.data.services.map((s) => s.name), contains('Haircut'));

      await _pick(tester, AppLanguage.mr);
      expect(find.text(mr.welcomeExplore), findsOneWidget);
      // Untouched sample data is created again in Marathi.
      expect(store.data.services.map((s) => s.name), contains('हेअरकट'));

      await enterApp(tester);
      expect(navItem(mr.navDashboard), findsOneWidget);
      expect(navItem(mr.navBilling), findsOneWidget);
      expect(find.text('Dashboard'), findsNothing);
    },
  );

  testWidgets('switching to हिन्दी in Settings changes labels at once and is '
      'remembered after a restart', (tester) async {
    usePhoneScreen(tester);
    final prefs = MemoryStoreFile();
    final storage = MemoryStoreFile();
    final store = await pumpDemoApp(
      tester,
      prefsStorage: prefs,
      storage: storage,
    );
    await enterApp(tester);
    // A change by the owner: the sample data is no longer untouched.
    await store.transact((d) => d.customers.first = d.customers.first);
    await _openSettings(tester);

    await _pick(tester, AppLanguage.hi);
    expect(find.text(hi.settingsTitle), findsWidgets);
    expect(navItem(hi.navMore), findsOneWidget);
    expect(prefs.text, contains('"hi"'));
    // Data the owner has worked with is kept as it is.
    expect(store.data.services.map((s) => s.name), contains('Haircut'));

    // Restart with the same saved files.
    await tester.pumpWidget(const SizedBox());
    await pumpDemoApp(tester, prefsStorage: prefs, storage: storage);
    expect(find.text(hi.welcomeExplore), findsOneWidget);
    await enterApp(tester);
    expect(navItem(hi.navDashboard), findsOneWidget);
  });

  testWidgets(
    'Reset demo data keeps the language and creates Hindi sample names',
    (tester) async {
      usePhoneScreen(tester);
      final prefs = MemoryStoreFile('{"language":"hi"}');
      final store = await pumpDemoApp(tester, prefsStorage: prefs);
      await enterApp(tester);
      await store.transact((d) => d.services.removeLast());
      await _openSettings(tester);

      await scrollAndTap(tester, find.text(hi.settingsResetDemo));
      await tester.tap(find.text(hi.settingsResetConfirm));
      await tester.pumpAndSettle();

      expect(store.data.services.map((s) => s.name), contains('हेयरकट'));
      expect(prefs.text, contains('"hi"'));
      expect(navItem(hi.navDashboard), findsOneWidget);
    },
  );
}
