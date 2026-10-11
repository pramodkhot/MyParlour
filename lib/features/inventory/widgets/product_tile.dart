import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/money.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../domain/models/product.dart';

/// Chip for a product's stock level: In stock / Low stock / Out of stock.
class StockLevelChip extends StatelessWidget {
  const StockLevelChip({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (!product.isActive) {
      return StatusChip(label: l10n.commonInactive, tone: ChipTone.neutral);
    }
    return switch (product.stockLevel) {
      StockLevel.inStock => StatusChip(
        label: l10n.stockInStock,
        tone: ChipTone.success,
      ),
      StockLevel.low => StatusChip(
        label: l10n.stockLow,
        tone: ChipTone.warning,
      ),
      StockLevel.out => StatusChip(label: l10n.stockOut, tone: ChipTone.error),
    };
  }
}

/// Line-icon tile used for products.
class ProductIconTile extends StatelessWidget {
  const ProductIconTile({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.chipSelected,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.spa_outlined,
        color: AppColors.primary,
        size: size * 0.5,
      ),
    );
  }
}

/// One row in the inventory list.
class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = product;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Opacity(
        opacity: p.isActive ? 1 : 0.55,
        child: Row(
          children: [
            const ProductIconTile(),
            Gap.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: AppText.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    context.l10n.inventoryStockLine(
                      p.stockQty,
                      context.l10n.unit(p.unit),
                    ),
                    style: AppText.caption.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (p.sellingPricePaise != null)
                  Text(
                    Money.format(p.sellingPricePaise!),
                    style: AppText.bodyStrong,
                  ),
                Gap.h4,
                StockLevelChip(product: p),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
