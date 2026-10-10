import '../models/date_range.dart';
import '../models/invoice.dart';
import 'report_service.dart';

class StaffPeriodStats {
  const StaffPeriodStats({
    required this.servicesDone,
    required this.billedPaise,
  });

  /// Service lines (counting quantity) credited to the stylist.
  final int servicesDone;

  /// Line totals of those services.
  final int billedPaise;
}

abstract final class StaffStats {
  /// Services the stylist did on bills finalised in [range] (void and
  /// draft bills excluded).
  static StaffPeriodStats forRange({
    required String staffId,
    required DateRange range,
    required Iterable<Invoice> invoices,
  }) {
    var count = 0;
    var amount = 0;
    for (final bill in ReportService.billsIn(range, invoices)) {
      for (final item in bill.items) {
        if (item.type == InvoiceItemType.service && item.staffId == staffId) {
          count += item.qty;
          amount += item.lineTotalPaise;
        }
      }
    }
    return StaffPeriodStats(servicesDone: count, billedPaise: amount);
  }
}
