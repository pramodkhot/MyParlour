import '../../domain/errors.dart';
import '../../domain/models/service_item.dart';
import '../../domain/repositories/repositories.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalServiceRepository implements ServiceRepository {
  LocalServiceRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<ServiceItem>> list({bool includeInactive = false}) async =>
      _store.data.services.where((s) => includeInactive || s.isActive).toList();

  @override
  Future<ServiceItem?> getById(String id) async =>
      findById(_store.data.services, id, (s) => s.id);

  @override
  Future<ServiceItem> save(ServiceItem service) => _store.transact((data) {
    if (service.name.trim().isEmpty) {
      throw const ValidationException(ErrorCode.serviceNameRequired);
    }
    if (service.pricePaise < 0) {
      throw const ValidationException(ErrorCode.priceNegative);
    }
    if (service.durationMin <= 0) {
      throw const ValidationException(ErrorCode.serviceDurationRequired);
    }
    final saved = service.copyWith(parlourId: data.parlour.id);
    upsertById(data.services, saved, (s) => s.id);
    return saved;
  });

  @override
  Future<void> setActive(String id, {required bool isActive}) =>
      _store.transact((data) {
        final service = findById(data.services, id, (s) => s.id);
        if (service == null) {
          throw const NotFoundException(ErrorCode.serviceNotFound);
        }
        upsertById(
          data.services,
          service.copyWith(isActive: isActive),
          (s) => s.id,
        );
      });
}
