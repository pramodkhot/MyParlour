import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:myparlour/app/app.dart';
import 'package:myparlour/core/l10n/app_language.dart';
import 'package:myparlour/core/l10n/language_controller.dart';
import 'package:myparlour/core/l10n/western_digits.dart';
import 'package:myparlour/data/local/prefs_store.dart';
import 'package:myparlour/core/widgets/app_text_field.dart';
import 'package:myparlour/data/demo/demo_seed.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/data/providers.dart';

import 'memory_store_file.dart';
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

/// Opens an in-memory store seeded with the demo data for [now] and pumps
/// the whole app on the Welcome screen, in [language] (as if chosen
/// earlier). Pass [storage] / [prefsStorage] to start from saved data (e.g.
/// to check something survives a restart), and [overrides] to replace other
/// providers (e.g. contact actions).
Future<LocalStore> pumpDemoApp(
  WidgetTester tester, {
  DateTime? now,
  AppLanguage language = AppLanguage.en,
  MemoryStoreFile? storage,
  MemoryStoreFile? prefsStorage,
  List<Override> overrides = const [],
}) async {
  final clock = now ?? testNow;
  for (final l in AppLanguage.values) {
    await initializeDateFormatting(l.intlLocale);
  }
  useWesternDigits();
  final prefs = PrefsStore(
    prefsStorage ??
        MemoryStoreFile(
          language == AppLanguage.en ? null : '{"language":"${language.name}"}',
        ),
  );
  await prefs.load();
  final store = LocalStore(
    storage: storage ?? MemoryStoreFile(),
    seeder: (t, lang) =>
        DemoSeed.build(t, sequentialIds('demo'), language: lang),
    clock: () => clock,
  );
  await store.load(language: AppLanguage.fromCode(prefs['language']));
  addTearDown(store.dispose);
  // Each test starts from English formatting unless it chose a language.
  addTearDown(() => Intl.defaultLocale = AppLanguage.en.intlLocale);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        prefsStoreProvider.overrideWithValue(prefs),
        clockProvider.overrideWithValue(() => clock),
        idGeneratorProvider.overrideWithValue(sequentialIds('new')),
        ...overrides,
      ],
      child: const MyParlourApp(),
    ),
  );
  await tester.pumpAndSettle();
  return store;
}

/// Taps the Welcome screen's main button ("Explore MyParlour" in English).
Future<void> enterApp(WidgetTester tester) async {
  final explore = find.byKey(const Key('welcome.explore'));
  await tester.ensureVisible(explore);
  await tester.pumpAndSettle();
  await tester.tap(explore);
  await tester.pumpAndSettle();
}

/// Removes any message bar, so it does not cover the next button tapped.
Future<void> clearMessages(WidgetTester tester) async {
  final messenger = tester.state<ScaffoldMessengerState>(
    find.byType(ScaffoldMessenger).first,
  );
  messenger.removeCurrentSnackBar();
  await tester.pumpAndSettle();
}

/// Scrolls the first scrollable until [finder] is built, then fully into
/// view (lists build rows a little beyond the screen), and taps it.
Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// From anywhere in the app: More tab → [section] (e.g. "Customers").
Future<void> openMoreSection(WidgetTester tester, String section) async {
  await tester.tap(navItem('More'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(section));
  await tester.pumpAndSettle();
}

/// The text input inside the form field labelled [label].
Finder formField(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(EditableText),
);

/// Types into the form field labelled [label] (scrolling to it first).
Future<void> typeInto(WidgetTester tester, String label, String text) async {
  await tester.ensureVisible(formField(label));
  await tester.enterText(formField(label), text);
  await tester.pumpAndSettle();
}

Finder navItem(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

int selectedTab(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;
