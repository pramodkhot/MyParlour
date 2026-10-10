import '../../domain/repositories/repositories.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalDemoDataRepository implements DemoDataRepository {
  LocalDemoDataRepository(this._store);

  final LocalStore _store;

  @override
  Future<void> resetDemo() => _store.replaceAll(_store.seeder(_store.clock()));

  @override
  Future<void> startEmpty() =>
      _store.replaceAll(StoreData(parlour: _store.data.parlour));
}
