import '../errors.dart';
import '../models/invoice.dart';

/// The bill-level discount as entered: a rupee amount or a percentage.
class BillDiscount {
  const BillDiscount.none() : type = DiscountType.none, value = 0;

  /// [paise] off the subtotal.
  const BillDiscount.amount(int paise)
    : type = DiscountType.amount,
      value = paise;

  /// [basisPoints] off the subtotal (1000 = 10%).
  const BillDiscount.percent(int basisPoints)
    : type = DiscountType.percent,
      value = basisPoints;

  const BillDiscount._(this.type, this.value);

  factory BillDiscount.of(DiscountType type, int value) =>
      BillDiscount._(type, value);

  final DiscountType type;
  final int value;
}

/// Result of [InvoiceCalculator.calculate]: lines with their discount
/// share, tax and total filled in, plus the bill totals (all paise).
class InvoiceTotals {
  const InvoiceTotals({
    required this.items,
    required this.subtotalPaise,
    required this.discountPaise,
    required this.taxablePaise,
    required this.taxPaise,
    required this.totalPaise,
  });

  final List<InvoiceItem> items;
  final int subtotalPaise;
  final int discountPaise;
  final int taxablePaise;
  final int taxPaise;
  final int totalPaise;
}

/// Bill maths from spec Section 6. Integer paise throughout; no doubles.
abstract final class InvoiceCalculator {
  /// Line gross = unit price × qty.
  static int lineGross(InvoiceItem item) => item.unitPricePaise * item.qty;

  /// Line net = gross − item discount, never below 0.
  static int lineNet(InvoiceItem item) {
    final net = lineGross(item) - item.itemDiscountPaise;
    return net < 0 ? 0 : net;
  }

  /// The problem with the discount, or null when it is fine.
  static DomainError? discountError(BillDiscount discount, int subtotalPaise) {
    if (discount.value < 0) {
      return const DomainError(ErrorCode.discountNegative);
    }
    switch (discount.type) {
      case DiscountType.none:
        return null;
      case DiscountType.amount:
        return discount.value > subtotalPaise
            ? const DomainError(ErrorCode.discountOverSubtotal)
            : null;
      case DiscountType.percent:
        return discount.value > 10000
            ? const DomainError(ErrorCode.discountOverHundred)
            : null;
    }
  }

  /// The discount in paise for this subtotal, capped at the subtotal.
  static int discountPaise(BillDiscount discount, int subtotalPaise) {
    final raw = switch (discount.type) {
      DiscountType.none => 0,
      DiscountType.amount => discount.value,
      DiscountType.percent => roundHalfUp(
        subtotalPaise * discount.value,
        10000,
      ),
    };
    if (raw < 0) return 0;
    return raw > subtotalPaise ? subtotalPaise : raw;
  }

  static InvoiceTotals calculate({
    required List<InvoiceItem> items,
    BillDiscount discount = const BillDiscount.none(),
    required bool taxEnabled,
    bool pricesIncludeTax = false,
  }) {
    final nets = [for (final item in items) lineNet(item)];
    final subtotal = nets.fold(0, (a, b) => a + b);
    final discountTotal = discountPaise(discount, subtotal);
    final shares = splitProportionally(discountTotal, nets);

    var taxableSum = 0;
    var taxSum = 0;
    final calculated = <InvoiceItem>[];
    for (var i = 0; i < items.length; i++) {
      final afterDiscount = nets[i] - shares[i];
      final rate = taxEnabled ? items[i].taxRateBp : 0;
      final int taxable;
      final int tax;
      if (rate == 0) {
        taxable = afterDiscount;
        tax = 0;
      } else if (pricesIncludeTax) {
        // The amount already contains tax: back it out.
        taxable = roundHalfUp(afterDiscount * 10000, 10000 + rate);
        tax = afterDiscount - taxable;
      } else {
        taxable = afterDiscount;
        tax = roundHalfUp(taxable * rate, 10000);
      }
      taxableSum += taxable;
      taxSum += tax;
      calculated.add(
        items[i].copyWith(
          allocatedDiscountPaise: shares[i],
          taxPaise: tax,
          lineTotalPaise: taxable + tax,
        ),
      );
    }

    return InvoiceTotals(
      items: calculated,
      subtotalPaise: subtotal,
      discountPaise: discountTotal,
      taxablePaise: taxableSum,
      taxPaise: taxSum,
      totalPaise: taxableSum + taxSum,
    );
  }

  /// Splits [amount] across [weights] in proportion. Rounding leftovers go
  /// one paisa at a time to the largest weights (earliest first on ties),
  /// so the shares always add up to [amount] exactly.
  static List<int> splitProportionally(int amount, List<int> weights) {
    final shares = List<int>.filled(weights.length, 0);
    final total = weights.fold(0, (a, b) => a + b);
    if (amount <= 0 || total <= 0) return shares;

    var allocated = 0;
    for (var i = 0; i < weights.length; i++) {
      shares[i] = amount * weights[i] ~/ total;
      allocated += shares[i];
    }

    final order =
        [
          for (var i = 0; i < weights.length; i++)
            if (weights[i] > 0) i,
        ]..sort((a, b) {
          final byWeight = weights[b].compareTo(weights[a]);
          return byWeight != 0 ? byWeight : a.compareTo(b);
        });

    var leftover = amount - allocated;
    for (var k = 0; leftover > 0; k = (k + 1) % order.length) {
      shares[order[k]]++;
      leftover--;
    }
    return shares;
  }

  /// numerator ÷ denominator rounded half-up (both non-negative).
  static int roundHalfUp(int numerator, int denominator) =>
      (numerator * 2 + denominator) ~/ (denominator * 2);
}
