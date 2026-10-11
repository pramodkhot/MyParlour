import '../../domain/errors.dart';
import '../../domain/models/customer.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/customer_rules.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalCustomerRepository implements CustomerRepository {
  LocalCustomerRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<Customer>> list({bool includeInactive = false}) async {
    final all =
        _store.data.customers
            .where((c) => includeInactive || c.isActive)
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
    return all;
  }

  @override
  Future<Customer?> getById(String id) async =>
      findById(_store.data.customers, id, (c) => c.id);

  @override
  Future<Customer> save(Customer customer) => _store.transact((data) {
    if (customer.name.trim().isEmpty) {
      throw const ValidationException(ErrorCode.customerNameRequired);
    }
    final saved = customer.copyWith(
      parlourId: data.parlour.id,
      name: customer.name.trim(),
      phone: customer.phone.trim(),
    );
    upsertById(data.customers, saved, (c) => c.id);
    return saved;
  });

  @override
  Future<void> setActive(String id, {required bool isActive}) =>
      _store.transact((data) {
        final customer = findById(data.customers, id, (c) => c.id);
        if (customer == null) {
          throw const NotFoundException(ErrorCode.customerNotFound);
        }
        upsertById(
          data.customers,
          customer.copyWith(isActive: isActive),
          (c) => c.id,
        );
      });

  @override
  Future<Customer?> findDuplicate(String phone, {String? excludeId}) async =>
      CustomerRules.findDuplicate(
        phone: phone,
        customers: _store.data.customers,
        excludeId: excludeId,
      );
}
