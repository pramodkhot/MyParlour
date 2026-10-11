import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/product.dart';
import '../../domain/models/stock_movement.dart';

/// Tabs on the Inventory screen.
enum InventoryTab {
  all('All items'),
  low('Low stock'),
  out('Out of stock');

  const InventoryTab(this.label);

  final String label;

  /// "low" → low stock tab (used by the Dashboard's Restock link).
  static InventoryTab fromQuery(String? value) => switch (value) {
    'low' => InventoryTab.low,
    'out' => InventoryTab.out,
    _ => InventoryTab.all,
  };

  bool matches(Product p) => switch (this) {
    InventoryTab.all => true,
    InventoryTab.low => p.stockLevel == StockLevel.low,
    InventoryTab.out => p.stockLevel == StockLevel.out,
  };
}

/// All products, active first then A–Z.
final allProductsProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  ref.watch(dataVersionProvider);
  final list = await ref
      .watch(productRepositoryProvider)
      .list(includeInactive: true);
  return list..sort((a, b) {
    if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
});

/// Products for a tab and search text. Inactive products only show on
/// "All items".
List<Product> filterProducts(
  List<Product> products, {
  required InventoryTab tab,
  required String query,
}) {
  final q = query.trim().toLowerCase();
  return products.where((p) {
    if (!p.isActive && tab != InventoryTab.all) return false;
    if (!tab.matches(p)) return false;
    return q.isEmpty ||
        p.name.toLowerCase().contains(q) ||
        (p.category?.toLowerCase().contains(q) ?? false);
  }).toList();
}

class ProductDetail {
  const ProductDetail({required this.product, required this.movements});

  final Product product;

  /// Newest first.
  final List<StockMovement> movements;
}

final productDetailProvider = FutureProvider.autoDispose
    .family<ProductDetail?, String>((ref, id) async {
      ref.watch(dataVersionProvider);
      final repo = ref.watch(productRepositoryProvider);
      final product = await repo.getById(id);
      if (product == null) return null;
      return ProductDetail(
        product: product,
        movements: await repo.movements(id),
      );
    });

class ProductActions {
  ProductActions(this._ref);

  final Ref _ref;

  String newId() => _ref.read(idGeneratorProvider)();

  Future<Product> save(Product product) =>
      _ref.read(productRepositoryProvider).save(product);

  Future<void> setActive(String id, {required bool isActive}) =>
      _ref.read(productRepositoryProvider).setActive(id, isActive: isActive);

  Future<Product> adjust(
    String id, {
    required int qtyChange,
    required StockReason reason,
    String? note,
  }) => _ref
      .read(productRepositoryProvider)
      .adjustStock(id, qtyChange: qtyChange, reason: reason, note: note);
}

final productActionsProvider = Provider<ProductActions>(ProductActions.new);
