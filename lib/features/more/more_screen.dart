import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/list_row_card.dart';

/// More tab: entry point to the less frequent sections (spec S15).
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const _items = [
    _MoreItem('Customers', Icons.people_alt_outlined, Routes.customers),
    _MoreItem('Staff', Icons.badge_outlined, Routes.staff),
    _MoreItem('Services', Icons.content_cut_rounded, Routes.services),
    _MoreItem('Inventory', Icons.inventory_2_outlined, Routes.inventory),
    _MoreItem(
      'Expenses',
      Icons.account_balance_wallet_outlined,
      Routes.expenses,
    ),
    _MoreItem('Reports', Icons.insights_outlined, Routes.reports),
    _MoreItem('Settings', Icons.settings_outlined, Routes.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'More'),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.sm,
          Space.screen,
          Space.xxl,
        ),
        itemCount: _items.length,
        separatorBuilder: (_, _) => Gap.h8,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListRowCard(
            title: item.label,
            leading: _IconTile(icon: item.icon),
            trailing: const RowChevron(),
            onTap: () => context.go(item.path),
          );
        },
      ),
    );
  }
}

class _MoreItem {
  const _MoreItem(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.chipSelected,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22, color: AppColors.primary),
    );
  }
}
