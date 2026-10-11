import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/header_band.dart';
import 'dashboard_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_metrics.dart';
import 'widgets/low_stock_card.dart';
import 'widgets/next_appointments_card.dart';
import 'widgets/quick_actions.dart';

/// S2 — Dashboard.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  /// How far the metric cards overlap the burgundy header.
  static const _overlap = 56.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: switch (dashboard) {
          AsyncValue(:final value?) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.refresh(dashboardProvider.future),
            child: _Body(data: value),
          ),
          AsyncValue(:final error?) => Center(
            child: EmptyState(
              icon: Icons.cloud_off_outlined,
              message: 'Could not load the dashboard. $error',
              actionLabel: 'Try again',
              onAction: () => ref.invalidate(dashboardProvider),
            ),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        DashboardHeader(
          data: data,
          bottomPadding: Space.lg,
          roundedBottom: false,
        ),
        // The band continues behind the top of the metric cards.
        HeaderBandOverlap(
          overlap: DashboardScreen._overlap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              0,
              Space.screen,
              Space.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardMetrics(summary: data.summary),
                Gap.h20,
                const Text('Quick actions', style: AppText.sectionTitle),
                Gap.h12,
                const QuickActions(),
                Gap.h12,
                NextAppointmentsCard(data: data),
                Gap.h12,
                LowStockCard(products: data.summary.lowStock),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
