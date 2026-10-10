import 'package:flutter/material.dart';

import '../../../core/widgets/status_chip.dart';
import '../../../domain/models/product.dart';

/// "2 left" (warning) or "Out of stock" (error) for a product.
class StockChip extends StatelessWidget {
  const StockChip({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return switch (product.stockLevel) {
      StockLevel.out => const StatusChip(
        label: 'Out of stock',
        tone: ChipTone.error,
      ),
      StockLevel.low => StatusChip(
        label: '${product.stockQty} left',
        tone: ChipTone.warning,
      ),
      StockLevel.inStock => const StatusChip(
        label: 'In stock',
        tone: ChipTone.success,
      ),
    };
  }
}
