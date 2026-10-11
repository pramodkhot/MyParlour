import '../errors.dart';
import '../models/product.dart';
import '../models/stock_movement.dart';

/// The choices in the "Adjust stock" sheet (spec S13).
enum StockAdjustment {
  stockIn('Stock in', StockReason.purchase),
  usedInService('Used in service', StockReason.usedInService),
  damaged('Damaged / expired', StockReason.damaged),
  countCorrection('Count correction', StockReason.correction);

  const StockAdjustment(this.label, this.reason);

  final String label;
  final StockReason reason;

  /// The stock change for [quantity]. For a count correction, [quantity]
  /// is the number actually counted, so the change is the difference.
  int changeFor({required int quantity, required int currentStock}) =>
      switch (this) {
        StockAdjustment.stockIn => quantity,
        StockAdjustment.usedInService || StockAdjustment.damaged => -quantity,
        StockAdjustment.countCorrection => quantity - currentStock,
      };
}

/// Stock can never go below zero (spec Section 6).
abstract final class StockRules {
  /// [product] with [qtyChange] applied, or throws
  /// [InsufficientStockException] if stock would go negative.
  static Product apply(Product product, int qtyChange) {
    final next = product.stockQty + qtyChange;
    if (next < 0) {
      throw product.stockQty == 0
          ? InsufficientStockException(ErrorCode.outOfStock, {
              'name': product.name,
            })
          : InsufficientStockException(ErrorCode.notEnoughStock, {
              'name': product.name,
              'qty': product.stockQty,
            });
    }
    return product.copyWith(stockQty: next);
  }
}
