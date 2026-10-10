import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/service_item.dart';

/// Default category order; any others follow alphabetically.
const defaultServiceCategories = ['Hair', 'Skin', 'Nails', 'Waxing'];

/// All services, active and inactive.
final allServicesProvider = FutureProvider.autoDispose<List<ServiceItem>>((
  ref,
) async {
  ref.watch(dataVersionProvider);
  return ref.watch(serviceRepositoryProvider).list(includeInactive: true);
});

/// Categories in display order (defaults first, then others A–Z).
List<String> serviceCategories(Iterable<ServiceItem> services) {
  final extra =
      services
          .map((s) => s.category)
          .where((c) => !defaultServiceCategories.contains(c))
          .toSet()
          .toList()
        ..sort();
  return [...defaultServiceCategories, ...extra];
}

/// Services grouped by category in display order. Inside a group, active
/// services come first, then by name. Empty groups are left out.
List<(String, List<ServiceItem>)> groupServices(List<ServiceItem> services) {
  return [
    for (final category in serviceCategories(services))
      if (services.any((s) => s.category == category))
        (
          category,
          services.where((s) => s.category == category).toList()..sort((a, b) {
            if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
            return a.name.compareTo(b.name);
          }),
        ),
  ];
}

final serviceByIdProvider = FutureProvider.autoDispose
    .family<ServiceItem?, String>((ref, id) async {
      ref.watch(dataVersionProvider);
      return ref.watch(serviceRepositoryProvider).getById(id);
    });

class ServiceActions {
  ServiceActions(this._ref);

  final Ref _ref;

  String newId() => _ref.read(idGeneratorProvider)();

  Future<int> defaultTaxRateBp() async =>
      (await _ref.read(parlourRepositoryProvider).get()).defaultTaxRateBp;

  Future<ServiceItem> save(ServiceItem service) =>
      _ref.read(serviceRepositoryProvider).save(service);

  Future<void> setActive(String id, {required bool isActive}) =>
      _ref.read(serviceRepositoryProvider).setActive(id, isActive: isActive);
}

final serviceActionsProvider = Provider<ServiceActions>(ServiceActions.new);
