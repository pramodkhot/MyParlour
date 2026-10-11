import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/services/invoice_calculator.dart';

InvoiceItem line(
  int unitPaise, {
  int qty = 1,
  int itemDiscount = 0,
  int rateBp = 1800,
  String id = 'l',
}) => InvoiceItem(
  id: id,
  type: InvoiceItemType.service,
  refId: 'ref-$id',
  name: 'Line $id',
  unitPricePaise: unitPaise,
  qty: qty,
  itemDiscountPaise: itemDiscount,
  taxRateBp: rateBp,
);

void main() {
  group('lines', () {
    test('gross = unit price × qty; net = gross − item discount', () {
      final item = line(50000, qty: 3, itemDiscount: 10000);
      expect(InvoiceCalculator.lineGross(item), 150000);
      expect(InvoiceCalculator.lineNet(item), 140000);
    });

    test('line net never goes below 0', () {
      expect(InvoiceCalculator.lineNet(line(5000, itemDiscount: 9000)), 0);
    });
  });

  group('totals without tax', () {
    test('subtotal and total add up the lines', () {
      final totals = InvoiceCalculator.calculate(
        items: [
          line(50000, id: 'a'),
          line(250000, id: 'b'),
        ],
        taxEnabled: false,
      );
      expect(totals.subtotalPaise, 300000);
      expect(totals.discountPaise, 0);
      expect(totals.taxPaise, 0);
      expect(totals.totalPaise, 300000);
      expect(totals.items.map((i) => i.lineTotalPaise), [50000, 250000]);
    });

    test('GST rates are ignored when tax is off', () {
      final totals = InvoiceCalculator.calculate(
        items: [line(100000, rateBp: 1800)],
        taxEnabled: false,
      );
      expect(totals.taxPaise, 0);
      expect(totals.totalPaise, 100000);
    });

    test('empty bill is zero', () {
      final totals = InvoiceCalculator.calculate(items: [], taxEnabled: true);
      expect(totals.totalPaise, 0);
      expect(totals.items, isEmpty);
    });
  });

  group('bill discount', () {
    test('percent discount is split in proportion to line net', () {
      final totals = InvoiceCalculator.calculate(
        items: [
          line(50000, id: 'a'),
          line(250000, id: 'b'),
        ],
        discount: const BillDiscount.percent(1000),
        taxEnabled: false,
      );
      expect(totals.discountPaise, 30000);
      expect(totals.items.map((i) => i.allocatedDiscountPaise), [5000, 25000]);
      expect(totals.totalPaise, 270000);
    });

    test(
      'rounding leftovers go to the largest lines, shares add up exactly',
      () {
        final shares = InvoiceCalculator.splitProportionally(100, [
          100,
          200,
          300,
        ]);
        // Exact: 16.67, 33.33, 50 → floors 16, 33, 50 (=99); +1 to largest.
        expect(shares, [16, 33, 51]);
        expect(shares.reduce((a, b) => a + b), 100);
      },
    );

    test('ties for the leftover go to the earliest line', () {
      final shares = InvoiceCalculator.splitProportionally(100, [
        100,
        100,
        100,
      ]);
      expect(shares, [34, 33, 33]);
    });

    test('split always adds up for awkward numbers', () {
      final weights = [333, 777, 1, 0, 12345, 999];
      for (final amount in [1, 7, 99, 1000, 14454]) {
        final shares = InvoiceCalculator.splitProportionally(amount, weights);
        expect(shares.reduce((a, b) => a + b), amount, reason: '$amount');
        expect(shares[3], 0, reason: 'a zero line gets no discount');
      }
    });

    test('amount discount cannot exceed the subtotal', () {
      final totals = InvoiceCalculator.calculate(
        items: [line(30000)],
        discount: const BillDiscount.amount(999999),
        taxEnabled: false,
      );
      expect(totals.discountPaise, 30000);
      expect(totals.totalPaise, 0);
    });

    test('discountError explains invalid discounts', () {
      expect(
        InvoiceCalculator.discountError(
          const BillDiscount.amount(40000),
          30000,
        )?.message,
        'Discount cannot be more than the subtotal.',
      );
      expect(
        InvoiceCalculator.discountError(
          const BillDiscount.percent(10001),
          30000,
        )?.message,
        'Discount cannot be more than 100%.',
      );
      expect(
        InvoiceCalculator.discountError(
          const BillDiscount.amount(-1),
          30000,
        )?.message,
        'Discount cannot be negative.',
      );
      expect(
        InvoiceCalculator.discountError(
          const BillDiscount.amount(30000),
          30000,
        ),
        isNull,
      );
    });

    test('percent discount rounds half-up to the paisa', () {
      // 12.5% of ₹0.99 = 12.375 paise → 12; 10% of ₹0.05 = 0.5 → 1.
      expect(
        InvoiceCalculator.discountPaise(const BillDiscount.percent(1250), 99),
        12,
      );
      expect(
        InvoiceCalculator.discountPaise(const BillDiscount.percent(1000), 5),
        1,
      );
    });
  });

  group('tax', () {
    test('18% GST on top of the price', () {
      final totals = InvoiceCalculator.calculate(
        items: [line(50000)],
        taxEnabled: true,
      );
      expect(totals.taxablePaise, 50000);
      expect(totals.taxPaise, 9000);
      expect(totals.totalPaise, 59000);
      expect(totals.items.single.taxPaise, 9000);
      expect(totals.items.single.lineTotalPaise, 59000);
    });

    test('tax rounds half-up per line', () {
      // 25 paise × 18% = 4.5 → 5; 333 × 18% = 59.94 → 60.
      final totals = InvoiceCalculator.calculate(
        items: [
          line(25, id: 'a'),
          line(333, id: 'b'),
        ],
        taxEnabled: true,
      );
      expect(totals.items.map((i) => i.taxPaise), [5, 60]);
      expect(totals.totalPaise, 25 + 5 + 333 + 60);
    });

    test('tax is charged on the amount after discount', () {
      final totals = InvoiceCalculator.calculate(
        items: [line(100000)],
        discount: const BillDiscount.percent(1000),
        taxEnabled: true,
      );
      expect(totals.taxablePaise, 90000);
      expect(totals.taxPaise, 16200);
      expect(totals.totalPaise, 106200);
    });

    test('mixed rates are applied per line', () {
      final totals = InvoiceCalculator.calculate(
        items: [
          line(10000, rateBp: 1800, id: 'a'),
          line(10000, rateBp: 500, id: 'b'),
        ],
        taxEnabled: true,
      );
      expect(totals.taxPaise, 1800 + 500);
    });

    test('prices that include GST have tax backed out', () {
      final totals = InvoiceCalculator.calculate(
        items: [line(11800)],
        taxEnabled: true,
        pricesIncludeTax: true,
      );
      expect(totals.taxablePaise, 10000);
      expect(totals.taxPaise, 1800);
      expect(totals.totalPaise, 11800);
    });
  });

  test('a ₹0 bill totals zero', () {
    final totals = InvoiceCalculator.calculate(
      items: [line(0)],
      taxEnabled: true,
    );
    expect(totals.totalPaise, 0);
  });
}
