import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/spacing.dart';
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

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);
    final all = products.value ?? const [];
    int count(InventoryTab t) => filterProducts(all, tab: t, query: '').length;

    return Scaffold(
      appBar: AppTopBar(
        title: 'Inventory',
        actions: [
          IconButton(
            tooltip: 'Add product',
            onPressed: _add,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add product',
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
              hint: 'Search products',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          TabBar(
            controller: _tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              for (final t in InventoryTab.values)
                Tab(text: '${t.label} (${count(t)})'),
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
                  message: 'Could not load products. $error',
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
    if (products.isEmpty) {
      return SingleChildScrollView(
        child: switch (tab) {
          InventoryTab.all => EmptyState(
            icon: Icons.inventory_2_outlined,
            message: 'No products yet.',
            actionLabel: 'Add product',
            onAction: onAdd,
          ),
          InventoryTab.low => const EmptyState(
            icon: Icons.inventory_2_outlined,
            message: 'Nothing is running low.',
          ),
          InventoryTab.out => const EmptyState(
            icon: Icons.inventory_2_outlined,
            message: 'Nothing is out of stock.',
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
