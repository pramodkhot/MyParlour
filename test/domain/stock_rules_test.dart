import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/errors.dart';
import 'package:myparlour/domain/models/product.dart';
import 'package:myparlour/domain/services/stock_rules.dart';

import '../helpers/test_data.dart';

void main() {
  test('adds and removes stock', () {
    expect(StockRules.apply(serum, 5).stockQty, 7);
    expect(StockRules.apply(serum, -2).stockQty, 0);
  });

  test('stock can never go below 0', () {
    expect(
      () => StockRules.apply(serum, -3),
      throwsA(
        isA<InsufficientStockException>().having(
          (e) => e.message,
          'message',
          'Only 2 Hair Serum left in stock.',
        ),
      ),
    );
  });

  test('out of stock message', () {
    final empty = serum.copyWith(stockQty: 0);
    expect(
      () => StockRules.apply(empty, -1),
      throwsA(
        isA<InsufficientStockException>().having(
          (e) => e.message,
          'message',
          'Hair Serum is out of stock.',
        ),
      ),
    );
  });

  test('stock level', () {
    expect(serum.stockLevel, StockLevel.low);
    expect(serum.copyWith(stockQty: 0).stockLevel, StockLevel.out);
    expect(serum.copyWith(stockQty: 4).stockLevel, StockLevel.inStock);
    expect(serum.copyWith(stockQty: 3).needsRestock, isTrue);
  });
}
