import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../domain/models/product.dart';

/// "2 left" (warning) or "Out of stock" (error) for a product.
class StockChip extends StatelessWidget {
  const StockChip({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return switch (product.stockLevel) {
      StockLevel.out => StatusChip(
        label: context.l10n.stockOut,
        tone: ChipTone.error,
      ),
      StockLevel.low => StatusChip(
        label: context.l10n.stockLeft(product.stockQty),
        tone: ChipTone.warning,
      ),
      StockLevel.inStock => StatusChip(
        label: context.l10n.stockInStock,
        tone: ChipTone.success,
      ),
    };
  }
}
