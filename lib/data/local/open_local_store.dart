import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/app_language.dart';
import '../demo/demo_seed.dart';
import 'local_store.dart';
import 'prefs_store.dart';
import 'store_file.dart';

/// Opens the store in the app documents folder, seeding demo data (in
/// [language]) on first launch.
Future<LocalStore> openLocalStore({required AppLanguage language}) async {
  final directory = await getApplicationDocumentsDirectory();
  const uuid = Uuid();
  final store = LocalStore(
    storage: DiskStoreFile(directory),
    seeder: (now, lang) => DemoSeed.build(now, uuid.v4, language: lang),
  );
  await store.load(language: language);
  return store;
}

/// Opens the device preferences (language) next to the data file.
Future<PrefsStore> openPrefsStore() async {
  final directory = await getApplicationDocumentsDirectory();
  final prefs = PrefsStore(
    DiskStoreFile(directory, name: DiskStoreFile.prefsFileName),
  );
  await prefs.load();
  return prefs;
}
