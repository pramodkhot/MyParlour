import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/format/money.dart';
import '../../../core/l10n/l10n.dart';
import '../../../domain/services/report_service.dart';

/// Burgundy line with dots over a light pink area (spec S14). Shows days,
/// or hours for a single day. The line stops at [now]: days or hours that
/// have not happened yet keep their label but get no point.
class SalesChart extends StatelessWidget {
  const SalesChart({
    super.key,
    required this.daily,
    required this.now,
    this.hourly,
  });

  final List<DailyAmount> daily;
  final List<(int, int)>? hourly;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hours = hourly;
    final values = hours != null
        ? [for (final h in hours) h.$2]
        : [for (final d in daily) d.amountPaise];
    final labels = hours != null
        ? [for (final h in hours) _hourLabel(h.$1)]
        : [for (final d in daily) Dates.dayMonth(d.day)];
    if (values.isEmpty) return const SizedBox.shrink();

    // How many points have happened (at least one).
    final today = DateTime(now.year, now.month, now.day);
    final isToday =
        daily.isNotEmpty && DateUtils.isSameDay(daily.first.day, today);
    final shown = hours != null
        ? (isToday ? hours.where((h) => h.$1 <= now.hour).length : hours.length)
        : daily.where((d) => !d.day.isAfter(today)).length;
    final pointCount = shown.clamp(1, values.length);

    final maxRupees = values.fold(0, (m, v) => v > m ? v : m) / 100;
    final top = _niceTop(maxRupees);
    final every = (values.length / 5).ceil().clamp(1, 1000);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: top,
          minX: 0,
          maxX: (values.length - 1).toDouble().clamp(1, double.infinity),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: top / 4,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AppColors.divider, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: top / 4,
                getTitlesWidget: (value, meta) => Text(
                  _compact(l10n, value),
                  style: AppText.caption.copyWith(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= labels.length || i % every != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[i],
                      style: AppText.caption.copyWith(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.text,
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    '${labels[s.x.round()]}\n'
                    '${Money.format((s.y * 100).round())}',
                    AppText.caption.copyWith(color: Colors.white),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < pointCount; i++)
                  FlSpot(i.toDouble(), values[i] / 100),
              ],
              isCurved: true,
              preventCurveOverShooting: true,
              color: AppColors.primary,
              barWidth: 2.5,
              dotData: FlDotData(
                getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                  radius: 3,
                  color: AppColors.primary,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.rose.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _hourLabel(int h) {
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$hour ${Dates.amPm(DateTime(2000, 1, 1, h))}';
  }

  /// A round top value for the y-axis (₹1k, 2k, 5k, 10k…).
  static double _niceTop(double max) {
    if (max <= 0) return 1000;
    var step = 1000.0;
    while (step * 4 < max) {
      step *= step.toString().startsWith('2') ? 2.5 : 2;
    }
    return step * 4;
  }

  static String _compact(AppLocalizations l10n, double rupees) {
    if (rupees >= 100000) {
      return l10n.reportsCompactLakhs((rupees / 100000).toStringAsFixed(1));
    }
    if (rupees >= 1000) {
      return l10n.reportsCompactThousands('${(rupees / 1000).round()}');
    }
    return '₹${rupees.round()}';
  }
}
