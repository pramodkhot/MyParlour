import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/money.dart';
import '../../../core/widgets/metric_card.dart';
import '../../../domain/services/dashboard_service.dart';

/// The 2×2 figures under the header.
class DashboardMetrics extends StatelessWidget {
  const DashboardMetrics({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final change = summary.salesChangePercent;
    final String salesCaption;
    final Color salesColor;
    IconData? salesIcon;
    if (change == null) {
      salesCaption = 'No sales yesterday';
      salesColor = AppColors.textMuted;
    } else if (change >= 0) {
      salesCaption = '$change% vs yesterday';
      salesColor = AppColors.success;
      salesIcon = Icons.arrow_drop_up_rounded;
    } else {
      salesCaption = '${-change}% vs yesterday';
      salesColor = AppColors.error;
      salesIcon = Icons.arrow_drop_down_rounded;
    }

    final pending = summary.pendingBillCount;
    return Column(
      children: [
        _Pair(
          left: MetricCard(
            label: "Today's sales",
            value: Money.format(summary.todaySalesPaise),
            icon: Icons.payments_outlined,
            caption: salesCaption,
            captionColor: salesColor,
            captionIcon: salesIcon,
            onTap: () => context.go(Routes.reportsToday),
          ),
          right: MetricCard(
            label: 'Appointments',
            value: '${summary.todayAppointmentCount}',
            icon: Icons.event_available_outlined,
            caption: '${summary.stillToComeCount} still to come',
            onTap: () => context.go(Routes.appointments),
          ),
        ),
        Gap.h12,
        _Pair(
          left: MetricCard(
            label: 'Pending payments',
            value: Money.format(summary.pendingPaise),
            icon: Icons.account_balance_wallet_outlined,
            caption: pending == 1 ? '1 bill due' : '$pending bills due',
            captionColor: pending == 0
                ? AppColors.textMuted
                : AppColors.warning,
            onTap: () => context.go(Routes.openBills),
          ),
          right: MetricCard(
            label: 'Customers',
            value: '${summary.activeCustomerCount}',
            icon: Icons.people_alt_outlined,
            caption: 'Active clients',
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
