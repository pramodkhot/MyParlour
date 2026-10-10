import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/widgets/avatar_initials.dart';
import '../../../domain/models/product.dart';
import '../../../domain/services/dashboard_service.dart';
import 'stock_chip.dart';

/// Bell sheet: low-stock products and today's birthdays.
abstract final class AlertsSheet {
  static Future<void> show(BuildContext context, DashboardSummary summary) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, controller) =>
            _AlertsList(summary: summary, controller: controller),
      ),
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.summary, required this.controller});

  final DashboardSummary summary;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const Text('Alerts', style: AppText.barTitle),
      Gap.h16,
    ];

    if (!summary.hasAlerts) {
      children.add(
        Text(
          'Nothing needs your attention right now.',
          style: AppText.body.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    if (summary.birthdaysToday.isNotEmpty) {
      children
        ..add(const Text('Birthdays today', style: AppText.sectionTitle))
        ..add(Gap.h8);
      for (final c in summary.birthdaysToday) {
        children.add(
          _AlertRow(
            leading: AvatarInitials(name: c.name, size: 40),
            title: c.name,
            subtitle: 'Wish them a happy birthday',
            trailing: const Icon(Icons.cake_outlined, color: AppColors.primary),
          ),
        );
      }
      children.add(Gap.h16);
    }

    if (summary.lowStock.isNotEmpty) {
      children
        ..add(const Text('Low stock', style: AppText.sectionTitle))
        ..add(Gap.h8);
      for (final p in summary.lowStock) {
        children.add(
          _AlertRow(
            leading: const _ProductIcon(),
            title: p.name,
            subtitle: 'Alert at ${p.lowStockAt} ${_unit(p)}',
            trailing: StockChip(product: p),
          ),
        );
      }
    }

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xxl),
      children: children,
    );
  }

  static String _unit(Product p) => p.unit.name;
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Row(
        children: [
          leading,
          Gap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.bodyStrong),
                Text(subtitle, style: AppText.caption),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _ProductIcon extends StatelessWidget {
  const _ProductIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.chipSelected,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }
}
