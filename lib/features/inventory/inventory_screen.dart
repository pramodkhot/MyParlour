import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/spacing.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/search_field.dart';
import '../../domain/models/product.dart';
import 'inventory_controller.dart';
import 'widgets/product_tile.dart';

/// S13 — Inventory with All / Low stock / Out of stock tabs.
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key, this.initialTab = InventoryTab.all});

  final InventoryTab initialTab;

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(
    length: InventoryTab.values.length,
    vsync: this,
    initialIndex: widget.initialTab.index,
  );
  String _query = '';

  @override
  void didUpdateWidget(InventoryScreen old) {
    super.didUpdateWidget(old);
    if (old.initialTab != widget.initialTab) {
      _tabs.index = widget.initialTab.index;
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _add() => context.push(Routes.newProduct);

  static String _tabLabel(AppLocalizations l10n, InventoryTab t) => switch (t) {
    InventoryTab.all => l10n.inventoryAllItems,
    InventoryTab.low => l10n.stockLow,
    InventoryTab.out => l10n.stockOut,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final products = ref.watch(allProductsProvider);
    final all = products.value ?? const [];
    int count(InventoryTab t) => filterProducts(all, tab: t, query: '').length;

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.inventoryTitle,
        actions: [
          IconButton(
            tooltip: l10n.inventoryAddProduct,
            onPressed: _add,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.inventoryAddProduct,
        onPressed: _add,
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              Space.xs,
              Space.screen,
              0,
            ),
            child: SearchField(
              hint: l10n.inventorySearch,
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          TabBar(
            controller: _tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              for (final t in InventoryTab.values)
                Tab(text: l10n.inventoryTabCount(_tabLabel(l10n, t), count(t))),
            ],
          ),
          Expanded(
            child: switch (products) {
              AsyncValue(:final value?) => TabBarView(
                controller: _tabs,
                children: [
                  for (final t in InventoryTab.values)
                    _List(
                      products: filterProducts(value, tab: t, query: _query),
                      tab: t,
                      onAdd: _add,
                    ),
                ],
              ),
              AsyncValue(:final error?) => Center(
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  message: l10n.inventoryLoadError('$error'),
                ),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.products, required this.tab, required this.onAdd});

  final List<Product> products;
  final InventoryTab tab;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (products.isEmpty) {
      return SingleChildScrollView(
        child: switch (tab) {
          InventoryTab.all => EmptyState(
            icon: Icons.inventory_2_outlined,
            message: l10n.inventoryEmpty,
            actionLabel: l10n.inventoryAddProduct,
            onAction: onAdd,
          ),
          InventoryTab.low => EmptyState(
            icon: Icons.inventory_2_outlined,
            message: l10n.inventoryNoneLow,
          ),
          InventoryTab.out => EmptyState(
            icon: Icons.inventory_2_outlined,
            message: l10n.inventoryNoneOut,
          ),
        },
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        Space.md,
        Space.screen,
        96,
      ),
      itemCount: products.length,
      separatorBuilder: (_, _) => Gap.h8,
      itemBuilder: (context, i) => ProductTile(
        product: products[i],
        onTap: () => context.push(Routes.product(products[i].id)),
      ),
    );
  }
}
