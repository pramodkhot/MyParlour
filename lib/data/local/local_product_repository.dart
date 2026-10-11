import '../../domain/errors.dart';
import '../../domain/models/product.dart';
import '../../domain/models/stock_movement.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/stock_rules.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalProductRepository implements ProductRepository {
  LocalProductRepository(this._store, {required this.newId});

  final LocalStore _store;
  final String Function() newId;

  @override
  Future<List<Product>> list({bool includeInactive = false}) async =>
      _store.data.products.where((p) => includeInactive || p.isActive).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  Future<Product?> getById(String id) async =>
      findById(_store.data.products, id, (p) => p.id);

  @override
  Future<Product> save(Product product) => _store.transact((data) {
    if (product.name.trim().isEmpty) {
      throw const ValidationException(ErrorCode.productNameRequired);
    }
    if (product.lowStockAt < 0) {
      throw const ValidationException(ErrorCode.lowStockNegative);
    }
    final existing = findById(data.products, product.id, (p) => p.id);
    if (existing == null) {
      if (product.stockQty < 0) {
        throw const ValidationException(ErrorCode.openingStockNegative);
      }
      final created = product.copyWith(parlourId: data.parlour.id);
      data.products.add(created);
      if (created.stockQty > 0) {
        data.stockMovements.add(
          StockMovement(
            id: newId(),
            parlourId: data.parlour.id,
            productId: created.id,
            qtyChange: created.stockQty,
            reason: StockReason.purchase,
            note: 'Opening stock',
            createdAt: _store.clock(),
          ),
        );
      }
      return created;
    }
    // Stock only changes through adjustStock or bills.
    final updated = product.copyWith(
      parlourId: data.parlour.id,
      stockQty: existing.stockQty,
    );
    upsertById(data.products, updated, (p) => p.id);
    return updated;
  });

  @override
  Future<void> setActive(String id, {required bool isActive}) =>
      _store.transact((data) {
        final product = findById(data.products, id, (p) => p.id);
        if (product == null) {
          throw const NotFoundException(ErrorCode.productNotFound);
        }
        upsertById(
          data.products,
          product.copyWith(isActive: isActive),
          (p) => p.id,
        );
      });

  @override
  Future<Product> adjustStock(
    String productId, {
    required int qtyChange,
    required StockReason reason,
    String? note,
  }) => _store.transact((data) {
    if (qtyChange == 0) {
      throw const ValidationException(ErrorCode.stockChangeZero);
    }
    if (reason == StockReason.sale || reason == StockReason.voidReversal) {
      throw const ValidationException(ErrorCode.stockSalesViaBills);
    }
    final product = findById(data.products, productId, (p) => p.id);
    if (product == null) {
      throw const NotFoundException(ErrorCode.productNotFound);
    }
    final updated = StockRules.apply(product, qtyChange);
    upsertById(data.products, updated, (p) => p.id);
    final trimmed = note?.trim();
    data.stockMovements.add(
      StockMovement(
        id: newId(),
        parlourId: data.parlour.id,
        productId: productId,
        qtyChange: qtyChange,
        reason: reason,
        note: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
        createdAt: _store.clock(),
      ),
    );
    return updated;
  });

  @override
  Future<List<StockMovement>> movements(String productId) async =>
      _store.data.stockMovements.where((m) => m.productId == productId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
