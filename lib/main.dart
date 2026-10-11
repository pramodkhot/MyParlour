import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'app/startup_error_app.dart';
import 'core/l10n/app_language.dart';
import 'core/l10n/language_controller.dart';
import 'core/l10n/western_digits.dart';
import 'data/local/open_local_store.dart';
import 'data/local/prefs_store.dart';
import 'data/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  for (final language in AppLanguage.values) {
    await initializeDateFormatting(language.intlLocale);
  }
  useWesternDigits();
  if (kReleaseMode) ErrorWidget.builder = friendlyErrorWidget;
  await _start();
}

/// Opens the data and runs the app, or shows a "Try again" screen if the
/// data cannot be opened.
Future<void> _start() async {
  PrefsStore? prefs;
  try {
    prefs = await openPrefsStore();
    final store = await openLocalStore(
      language: AppLanguage.fromCode(prefs['language']),
    );
    runApp(
      ProviderScope(
        overrides: [
          localStoreProvider.overrideWithValue(store),
          prefsStoreProvider.overrideWithValue(prefs),
        ],
        child: const MyParlourApp(),
      ),
    );
  } on Object catch (error) {
    runApp(
      StartupErrorApp(
        error: error,
        onRetry: _start,
        language: prefs == null
            ? null
            : AppLanguage.fromCode(prefs['language']),
      ),
    );
  }
}
