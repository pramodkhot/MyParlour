import '../../core/l10n/app_language.dart';
import '../../domain/repositories/repositories.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalDemoDataRepository implements DemoDataRepository {
  LocalDemoDataRepository(this._store);

  final LocalStore _store;

  @override
  Future<void> resetDemo({AppLanguage language = AppLanguage.en}) => _store
      .replaceAll(_store.seeder(_store.clock(), language), pristine: true);

  @override
  Future<void> startEmpty() =>
      _store.replaceAll(StoreData(parlour: _store.data.parlour));

  @override
  bool get isUntouchedSample => _store.isPristine;
}
