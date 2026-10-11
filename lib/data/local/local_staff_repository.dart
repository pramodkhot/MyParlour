import '../../domain/errors.dart';
import '../../domain/models/staff.dart';
import '../../domain/repositories/repositories.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalStaffRepository implements StaffRepository {
  LocalStaffRepository(this._store);

  final LocalStore _store;

  /// Active staff first, then by name.
  @override
  Future<List<Staff>> list({bool includeInactive = false}) async =>
      _store.data.staff.where((s) => includeInactive || s.isActive).toList()
        ..sort((a, b) {
          if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
          return a.name.compareTo(b.name);
        });

  @override
  Future<Staff?> getById(String id) async =>
      findById(_store.data.staff, id, (s) => s.id);

  @override
  Future<Staff> save(Staff staff) => _store.transact((data) {
    if (staff.name.trim().isEmpty) {
      throw const ValidationException(ErrorCode.staffNameRequired);
    }
    final saved = staff.copyWith(parlourId: data.parlour.id);
    upsertById(data.staff, saved, (s) => s.id);
    return saved;
  });

  @override
  Future<void> setActive(String id, {required bool isActive}) =>
      _store.transact((data) {
        final staff = findById(data.staff, id, (s) => s.id);
        if (staff == null) {
          throw const NotFoundException(ErrorCode.staffNotFound);
        }
        upsertById(data.staff, staff.copyWith(isActive: isActive), (s) => s.id);
      });
}
