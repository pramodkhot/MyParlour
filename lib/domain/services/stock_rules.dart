import '../errors.dart';
import '../models/product.dart';

/// Stock can never go below zero (spec Section 6).
abstract final class StockRules {
  /// [product] with [qtyChange] applied, or throws
  /// [InsufficientStockException] if stock would go negative.
  static Product apply(Product product, int qtyChange) {
    final next = product.stockQty + qtyChange;
    if (next < 0) {
      throw InsufficientStockException(
        product.stockQty == 0
            ? '${product.name} is out of stock.'
            : 'Only ${product.stockQty} ${product.name} left in stock.',
      );
    }
    return product.copyWith(stockQty: next);
  }
}
