import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/models/stock_movement.dart';
import 'package:myparlour/domain/services/report_service.dart';
import 'package:myparlour/domain/services/stock_rules.dart';

Payment pay(int amount, DateTime at, {bool isVoid = false}) => Payment(
  id: '$at',
  parlourId: 'p',
  invoiceId: 'i',
  amountPaise: amount,
  method: PaymentMethod.cash,
  receivedAt: at,
  isVoid: isVoid,
);

void main() {
  group('stock adjustments', () {
    test('stock in adds, used and damaged remove', () {
      expect(
        StockAdjustment.stockIn.changeFor(quantity: 5, currentStock: 2),
        5,
      );
      expect(
        StockAdjustment.usedInService.changeFor(quantity: 1, currentStock: 2),
        -1,
      );
      expect(
        StockAdjustment.damaged.changeFor(quantity: 2, currentStock: 2),
        -2,
      );
    });

    test('count correction sets the counted number', () {
      expect(
        StockAdjustment.countCorrection.changeFor(
          quantity: 7,
          currentStock: 10,
        ),
        -3,
      );
      expect(
        StockAdjustment.countCorrection.changeFor(quantity: 4, currentStock: 4),
        0,
      );
    });

    test('reasons are recorded on the movement', () {
      expect(StockAdjustment.stockIn.reason, StockReason.purchase);
      expect(StockAdjustment.countCorrection.reason, StockReason.correction);
    });
  });

  test('hourly sales for the Today chart', () {
    final day = DateTime(2026, 5, 14);
    final hours = ReportService.hourlySales(day, [
      pay(10000, DateTime(2026, 5, 14, 10, 30)),
      pay(5000, DateTime(2026, 5, 14, 10, 59)),
      pay(20000, DateTime(2026, 5, 14, 16, 12)),
      pay(3000, DateTime(2026, 5, 14, 21, 5)), // after closing → last hour
      pay(99999, DateTime(2026, 5, 14, 12), isVoid: true),
      pay(77777, DateTime(2026, 5, 13, 12)),
    ]);
    expect(hours.first, (10, 15000));
    expect(hours.firstWhere((h) => h.$1 == 16).$2, 20000);
    expect(hours.last, (19, 3000));
    expect(hours.fold(0, (s, h) => s + h.$2), 38000);
  });
}
