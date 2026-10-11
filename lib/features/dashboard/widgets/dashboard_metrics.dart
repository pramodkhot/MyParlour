import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/money.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/metric_card.dart';
import '../../../domain/services/dashboard_service.dart';

/// The 2×2 figures under the header.
class DashboardMetrics extends StatelessWidget {
  const DashboardMetrics({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final change = summary.salesChangePercent;
    final String salesCaption;
    final Color salesColor;
    IconData? salesIcon;
    if (change == null) {
      salesCaption = l10n.dashNoSalesYesterday;
      salesColor = AppColors.textMuted;
    } else if (change >= 0) {
      salesCaption = l10n.dashVsYesterday(change);
      salesColor = AppColors.success;
      salesIcon = Icons.arrow_drop_up_rounded;
    } else {
      salesCaption = l10n.dashVsYesterday(-change);
      salesColor = AppColors.error;
      salesIcon = Icons.arrow_drop_down_rounded;
    }

    final pending = summary.pendingBillCount;
    return Column(
      children: [
        _Pair(
          left: MetricCard(
            label: l10n.dashTodaysSales,
            value: Money.format(summary.todaySalesPaise),
            icon: Icons.payments_outlined,
            caption: salesCaption,
            captionColor: salesColor,
            captionIcon: salesIcon,
            onTap: () => context.go(Routes.reportsToday),
          ),
          right: MetricCard(
            label: l10n.navAppointments,
            value: '${summary.todayAppointmentCount}',
            icon: Icons.event_available_outlined,
            caption: l10n.dashStillToCome(summary.stillToComeCount),
            onTap: () => context.go(Routes.appointments),
          ),
        ),
        Gap.h12,
        _Pair(
          left: MetricCard(
            label: l10n.dashPendingPayments,
            value: Money.format(summary.pendingPaise),
            icon: Icons.account_balance_wallet_outlined,
            caption: l10n.dashBillsDue(pending),
            captionColor: pending == 0
                ? AppColors.textMuted
                : AppColors.warning,
            onTap: () => context.go(Routes.openBills),
          ),
          right: MetricCard(
            label: l10n.dashCustomers,
            value: '${summary.activeCustomerCount}',
            icon: Icons.people_alt_outlined,
            caption: l10n.dashActiveClients,
            onTap: () => context.go(Routes.customers),
          ),
        ),
      ],
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          Gap.w12,
          Expanded(child: right),
        ],
      ),
    );
  }
}
