import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app.dart';
import 'data/local/open_local_store.dart';
import 'data/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'en_IN';
  await initializeDateFormatting('en_IN');
  final store = await openLocalStore();
  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      child: const MyParlourApp(),
    ),
  );
}
