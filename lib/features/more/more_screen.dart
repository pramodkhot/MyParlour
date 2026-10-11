import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/money.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/list_row_card.dart';
import 'more_controller.dart';

/// S15 — More: the less frequent sections, with a figure for each.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(moreSummaryProvider).value;
    String? count(int? n, String one, String many) =>
        n == null ? null : (n == 1 ? '1 $one' : '$n $many');

    final items = [
      (
        'Customers',
        Icons.people_alt_outlined,
        Routes.customers,
        count(s?.customers, 'customer', 'customers'),
        false,
      ),
      (
        'Staff',
        Icons.badge_outlined,
        Routes.staff,
        s == null ? null : '${s.activeStaff} active',
        false,
      ),
      (
        'Services',
        Icons.content_cut_rounded,
        Routes.services,
        count(s?.services, 'service', 'services'),
        false,
      ),
      (
        'Inventory',
        Icons.inventory_2_outlined,
        Routes.inventory,
        s == null ? null : '${s.lowStock} low',
        (s?.lowStock ?? 0) > 0,
      ),
      (
        'Expenses',
        Icons.account_balance_wallet_outlined,
        Routes.expenses,
        s == null ? null : '${Money.format(s.monthExpensesPaise)} this month',
        false,
      ),
      ('Reports', Icons.insights_outlined, Routes.reports, null, false),
      ('Settings', Icons.settings_outlined, Routes.settings, null, false),
    ];

    return Scaffold(
      appBar: AppTopBar(
        title: 'More',
        subtitle: s == null ? null : '${s.parlourName} · Owner',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.sm,
          Space.screen,
          Space.xxl,
        ),
        itemCount: items.length,
        separatorBuilder: (_, _) => Gap.h8,
        itemBuilder: (context, index) {
          final (label, icon, path, meta, alert) = items[index];
          return ListRowCard(
            title: label,
            leading: _IconTile(icon: icon),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (meta != null)
                  Text(
                    meta,
                    style: AppText.caption.copyWith(
                      color: alert ? AppColors.warning : AppColors.textMuted,
                      fontWeight: alert ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                const RowChevron(),
              ],
            ),
            onTap: () => context.go(path),
          );
        },
      ),
    );
  }
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
