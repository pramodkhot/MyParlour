import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app.dart';
import 'app/startup_error_app.dart';
import 'data/local/open_local_store.dart';
import 'data/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'en_IN';
  await initializeDateFormatting('en_IN');
  if (kReleaseMode) ErrorWidget.builder = friendlyErrorWidget;
  await _start();
}

/// Opens the data and runs the app, or shows a "Try again" screen if the
/// data cannot be opened.
Future<void> _start() async {
  try {
    final store = await openLocalStore();
    runApp(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: const MyParlourApp(),
      ),
    );
  } on Object catch (error) {
    runApp(StartupErrorApp(error: error, onRetry: _start));
  }
}
