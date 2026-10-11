import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/empty_state.dart';
import '../../domain/models/stock_movement.dart';
import 'inventory_controller.dart';
import 'widgets/adjust_stock_sheet.dart';
import 'widgets/product_tile.dart';

/// S13 detail — product, stock history and "Adjust stock".
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  static String reasonLabel(StockReason r) => switch (r) {
    StockReason.purchase => 'Stock in',
    StockReason.sale => 'Sold on bill',
    StockReason.usedInService => 'Used in service',
    StockReason.damaged => 'Damaged / expired',
    StockReason.correction => 'Count correction',
    StockReason.voidReversal => 'Bill voided (returned)',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(productDetailProvider(productId));
    final d = detail.value;
    if (d == null) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Product'),
        body: Center(
          child: detail.isLoading
              ? const CircularProgressIndicator()
              : const EmptyState(
                  icon: Icons.inventory_2_outlined,
                  message: 'This product no longer exists.',
                ),
        ),
      );
    }
    final p = d.product;
    return Scaffold(
      appBar: AppTopBar(
        title: 'Product',
        actions: [
          IconButton(
            tooltip: 'Edit product',
            onPressed: () => context.push(Routes.editProduct(p.id)),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.sm,
          Space.screen,
          Space.xxl,
        ),
        children: [
          AppCard(
            child: Row(
              children: [
                const ProductIconTile(size: 56),
                Gap.w16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: AppText.barTitle),
                      if (p.category != null)
                        Text(p.category!, style: AppText.caption),
                      Gap.h4,
                      StockLevelChip(product: p),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap.h12,
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _Row('In stock', '${p.stockQty} ${p.unit.name}', strong: true),
                const Divider(indent: Space.lg, endIndent: Space.lg),
                _Row('Low-stock alert at', '${p.lowStockAt} ${p.unit.name}'),
                const Divider(indent: Space.lg, endIndent: Space.lg),
                _Row(
                  'Selling price',
                  p.sellingPricePaise == null
                      ? 'Not set'
                      : Money.format(p.sellingPricePaise!),
                ),
                if (p.costPricePaise != null) ...[
                  const Divider(indent: Space.lg, endIndent: Space.lg),
                  _Row('Cost price', Money.format(p.costPricePaise!)),
                ],
              ],
            ),
          ),
          Gap.h20,
          const Text('Stock history', style: AppText.sectionTitle),
          Gap.h8,
          if (d.movements.isEmpty)
            const AppCard(
              child: Text(
                'No stock changes yet.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          else
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < d.movements.length; i++) ...[
                    if (i > 0)
                      const Divider(indent: Space.lg, endIndent: Space.lg),
                    _MovementRow(movement: d.movements[i]),
                  ],
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: p.isActive
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.screen,
                  Space.sm,
                  Space.screen,
                  Space.lg,
                ),
                child: PrimaryButton(
                  label: 'Adjust stock',
                  icon: Icons.tune_rounded,
                  onPressed: () => showAdjustStockSheet(context, p),
                ),
              ),
            )
          : null,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppText.label)),
          Text(
            value,
            style: strong
                ? AppText.bigNumber.copyWith(fontSize: 18)
                : AppText.bodyStrong,
          ),
        ],
      ),
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.movement});

  final StockMovement movement;

  @override
  Widget build(BuildContext context) {
    final m = movement;
    final positive = m.qtyChange > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProductDetailScreen.reasonLabel(m.reason),
                  style: AppText.bodyStrong,
                ),
                Text(
                  [Dates.dayMonthTime(m.createdAt), ?m.note].join(' · '),
                  style: AppText.caption,
                ),
              ],
            ),
          ),
          Text(
            positive ? '+${m.qtyChange}' : '${m.qtyChange}',
            style: AppText.bodyStrong.copyWith(
              color: positive ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
