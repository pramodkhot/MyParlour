import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/metric_card.dart';
import '../../data/providers.dart';
import '../../domain/models/payment.dart';
import '../../domain/services/report_service.dart';
import '../billing/payment_method_ui.dart';
import 'reports_controller.dart';
import 'widgets/sales_chart.dart';

/// S14 — Reports.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key, this.initialPeriod = ReportPeriod.thisMonth});

  final ReportPeriod initialPeriod;

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late ReportArgs _args = (period: widget.initialPeriod, from: null, to: null);

  @override
  void didUpdateWidget(ReportsScreen old) {
    super.didUpdateWidget(old);
    if (old.initialPeriod != widget.initialPeriod) {
      _args = (period: widget.initialPeriod, from: null, to: null);
    }
  }

  Future<void> _choose(ReportPeriod period) async {
    if (period != ReportPeriod.custom) {
      setState(() => _args = (period: period, from: null, to: null));
      return;
    }
    final now = ref.read(clockProvider)();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: _args.from == null
          ? DateTimeRange(start: DateTime(now.year, now.month), end: now)
          : DateTimeRange(start: _args.from!, end: _args.to!),
    );
    if (picked != null) {
      setState(
        () => _args = (
          period: ReportPeriod.custom,
          from: picked.start,
          to: picked.end,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final report = ref.watch(reportProvider(_args));
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.reportsTitle,
        actions: [
          PopupMenuButton<ReportPeriod>(
            tooltip: l10n.reportsChoosePeriod,
            onSelected: _choose,
            itemBuilder: (_) => [
              for (final p in ReportPeriod.values)
                CheckedPopupMenuItem(
                  value: p,
                  checked: p == _args.period,
                  child: Text(l10n.reportPeriod(p)),
                ),
            ],
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: Space.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: Space.md,
                vertical: Space.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.reportPeriod(_args.period), style: AppText.chip),
                  const Icon(Icons.expand_more_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
      body: switch (report) {
        AsyncValue(:final value?) => _Body(view: value),
        AsyncValue(:final error?) => Center(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            message: l10n.reportsLoadFailed('$error'),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.view});

  final ReportView view;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = view.summary;
    final range = s.range;
    final last = range.end.subtract(const Duration(days: 1));
    final rangeText = range.days.length == 1
        ? Dates.weekdayDayMonthYear(range.start)
        : '${Dates.dayMonth(range.start)} – ${Dates.dayMonthYear(last)}';

    if (s.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(Space.screen),
        children: [
          Text(rangeText, style: AppText.caption),
          EmptyState(icon: Icons.insights_outlined, message: l10n.reportsEmpty),
        ],
      );
    }

    final net = s.netProfitEstimatePaise;
    final methodTotal = s.paymentMethods.values.fold(0, (a, b) => a + b);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        0,
        Space.screen,
        Space.xxl,
      ),
      children: [
        Text(rangeText, style: AppText.caption),
        Gap.h12,
        _Pair(
          left: MetricCard(
            label: l10n.reportsTotalSales,
            value: Money.format(s.salesPaise),
            icon: Icons.payments_outlined,
            caption: l10n.reportsMoneyReceived,
          ),
          right: MetricCard(
            label: l10n.reportsTotalExpenses,
            value: Money.format(s.expensesPaise),
            icon: Icons.account_balance_wallet_outlined,
          ),
        ),
        Gap.h12,
        _Pair(
          left: MetricCard(
            label: l10n.reportsNetProfit,
            value: Money.format(net),
            icon: Icons.trending_up_rounded,
            caption: l10n.reportsSalesMinusExpenses,
            captionColor: net < 0 ? AppColors.error : AppColors.success,
          ),
          right: MetricCard(
            label: l10n.reportsTotalBills,
            value: '${s.billCount}',
            icon: Icons.receipt_long_outlined,
            caption: l10n.reportsBillsCaption,
          ),
        ),
        Gap.h20,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.reportsSalesOverview, style: AppText.sectionTitle),
              Gap.h16,
              SalesChart(
                daily: s.dailySales,
                hourly: view.hourly,
                now: view.now,
              ),
            ],
          ),
        ),
        Gap.h12,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.reportsTopServices, style: AppText.sectionTitle),
              Gap.h12,
              if (s.topServices.isEmpty)
                Text(
                  l10n.reportsNoServices,
                  style: AppText.body.copyWith(color: AppColors.textMuted),
                ),
              for (final t in s.topServices) _ShareBar(share: t),
            ],
          ),
        ),
        Gap.h12,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.reportsPaymentMethods, style: AppText.sectionTitle),
              Gap.h12,
              for (final m in PaymentMethod.values)
                _MethodBar(
                  method: m,
                  paise: s.paymentMethods[m] ?? 0,
                  total: methodTotal,
                ),
            ],
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

class _ShareBar extends StatelessWidget {
  const _ShareBar({required this.share});

  final ServiceShare share;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(share.name, style: AppText.bodyStrong)),
              Text(
                '${share.sharePercent}%',
                style: AppText.bodyStrong.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          Text(
            context.l10n.reportsServiceCount(
              share.count,
              Money.format(share.amountPaise),
            ),
            style: AppText.caption,
          ),
          Gap.h4,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: share.sharePercent / 100,
              minHeight: 6,
              color: AppColors.primary,
              backgroundColor: AppColors.chipSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodBar extends StatelessWidget {
  const _MethodBar({
    required this.method,
    required this.paise,
    required this.total,
  });

  final PaymentMethod method;
  final int paise;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : paise / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(
        children: [
          Icon(method.icon, size: 18, color: AppColors.primary),
          Gap.w8,
          SizedBox(
            width: 52,
            child: Text(
              context.l10n.paymentMethod(method),
              style: AppText.label,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 10,
                color: AppColors.rose,
                backgroundColor: AppColors.divider,
              ),
            ),
          ),
          Gap.w8,
          SizedBox(
            width: 76,
            child: Text(
              Money.format(paise),
              textAlign: TextAlign.end,
              style: AppText.bodyStrong.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
