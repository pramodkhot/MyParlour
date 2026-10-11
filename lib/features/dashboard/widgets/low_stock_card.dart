import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../domain/models/product.dart';
import 'stock_chip.dart';

/// Products at or below their alert level, with a link to restock.
class LowStockCard extends StatelessWidget {
  const LowStockCard({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: context.l10n.stockLow,
          actionLabel: context.l10n.dashRestock,
          onAction: () => context.go(Routes.lowStock),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: products.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.success,
                      ),
                      Gap.w12,
                      Expanded(
                        child: Text(
                          context.l10n.dashAllWellStocked,
                          style: AppText.body.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < products.length; i++) ...[
                      if (i > 0)
                        const Divider(indent: Space.lg, endIndent: Space.lg),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.lg,
                          vertical: Space.md,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.water_drop_outlined,
                              color: AppColors.rose,
                              size: 22,
                            ),
                            Gap.w12,
                            Expanded(
                              child: Text(
                                products[i].name,
                                style: AppText.bodyStrong,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            StockChip(product: products[i]),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}
