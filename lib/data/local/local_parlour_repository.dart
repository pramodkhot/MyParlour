import '../../domain/models/parlour.dart';
import '../../domain/repositories/repositories.dart';
import 'local_store.dart';

class LocalParlourRepository implements ParlourRepository {
  LocalParlourRepository(this._store);

  final LocalStore _store;

  @override
  Future<Parlour> get() async => _store.data.parlour;

  @override
  Future<Parlour> save(Parlour parlour) => _store.transact((data) {
    // The parlour id never changes.
    final fixed = Parlour.fromJson({
      ...parlour.toJson(),
      'id': data.parlour.id,
    });
    data.parlour = fixed;
    return fixed;
  });
}
