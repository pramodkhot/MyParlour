import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/money.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/list_row_card.dart';
import 'more_controller.dart';

/// S15 — More: the less frequent sections, with a figure for each.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final s = ref.watch(moreSummaryProvider).value;

    final items = [
      (
        l10n.moreCustomers,
        Icons.people_alt_outlined,
        Routes.customers,
        s == null ? null : l10n.moreCustomerCount(s.customers),
        false,
      ),
      (
        l10n.moreStaff,
        Icons.badge_outlined,
        Routes.staff,
        s == null ? null : l10n.moreActiveStaff(s.activeStaff),
        false,
      ),
      (
        l10n.moreServices,
        Icons.content_cut_rounded,
        Routes.services,
        s == null ? null : l10n.moreServiceCount(s.services),
        false,
      ),
      (
        l10n.moreInventory,
        Icons.inventory_2_outlined,
        Routes.inventory,
        s == null ? null : l10n.moreLowCount(s.lowStock),
        (s?.lowStock ?? 0) > 0,
      ),
      (
        l10n.expensesTitle,
        Icons.account_balance_wallet_outlined,
        Routes.expenses,
        s == null
            ? null
            : l10n.moreExpensesThisMonth(Money.format(s.monthExpensesPaise)),
        false,
      ),
      (l10n.moreReports, Icons.insights_outlined, Routes.reports, null, false),
      (
        l10n.settingsTitle,
        Icons.settings_outlined,
        Routes.settings,
        null,
        false,
      ),
    ];

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.navMore,
        subtitle: s == null ? null : l10n.moreOwnerSubtitle(s.parlourName),
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
                  Flexible(
                    child: Text(
                      meta,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: AppText.caption.copyWith(
                        color: alert ? AppColors.warning : AppColors.textMuted,
                        fontWeight: alert ? FontWeight.w700 : FontWeight.w500,
                      ),
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
