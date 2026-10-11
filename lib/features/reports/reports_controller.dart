import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/services/report_service.dart';

/// The chosen period. [from]/[to] are used only for a custom range.
typedef ReportArgs = ({ReportPeriod period, DateTime? from, DateTime? to});

class ReportView {
  const ReportView({required this.summary, required this.now, this.hourly});

  final ReportSummary summary;

  /// When the report was made; the chart line stops here.
  final DateTime now;

  /// Sales per hour, for single-day ranges (the chart shows hours then).
  final List<(int, int)>? hourly;
}

final reportProvider = FutureProvider.autoDispose
    .family<ReportView, ReportArgs>((ref, args) async {
      ref.watch(dataVersionProvider);
      final now = ref.watch(clockProvider)();
      final range = ReportService.rangeFor(
        args.period,
        now,
        customFrom: args.from,
        customTo: args.to,
      );
      final payments = await ref
          .watch(paymentRepositoryProvider)
          .listInRange(range);
      final invoices = await ref.watch(invoiceRepositoryProvider).list();
      final expenses = await ref
          .watch(expenseRepositoryProvider)
          .listInRange(range);
      final parlour = await ref.watch(parlourRepositoryProvider).get();

      final singleDay = range.days.length == 1;
      return ReportView(
        now: now,
        summary: ReportService.build(
          range: range,
          payments: payments,
          invoices: invoices,
          expenses: expenses,
        ),
        hourly: singleDay
            ? ReportService.hourlySales(
                range.start,
                payments,
                fromHour: parlour.openTime.hour,
                toHour: parlour.closeTime.minute > 0
                    ? parlour.closeTime.hour + 1
                    : parlour.closeTime.hour,
              )
            : null,
      );
    });
