import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../demo/demo_seed.dart';
import 'local_store.dart';
import 'store_file.dart';

/// Opens the store in the app documents folder, seeding demo data on
/// first launch.
Future<LocalStore> openLocalStore() async {
  final directory = await getApplicationDocumentsDirectory();
  const uuid = Uuid();
  final store = LocalStore(
    storage: DiskStoreFile(directory),
    seeder: (now) => DemoSeed.build(now, uuid.v4),
  );
  await store.load();
  return store;
}
