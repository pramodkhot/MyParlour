import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/domain/services/invoice_rules.dart';

Payment pay(int amount, {bool isVoid = false}) => Payment(
  id: 'p$amount',
  parlourId: 'x',
  invoiceId: 'i',
  amountPaise: amount,
  method: PaymentMethod.cash,
  receivedAt: DateTime.utc(2026, 5, 14),
  isVoid: isVoid,
);

void main() {
  group('status', () {
    test('nothing paid → finalised', () {
      expect(
        InvoiceRules.statusFor(totalPaise: 270000, paidPaise: 0),
        InvoiceStatus.finalised,
      );
    });

    test('part paid → partially paid', () {
      expect(
        InvoiceRules.statusFor(totalPaise: 270000, paidPaise: 100000),
        InvoiceStatus.partiallyPaid,
      );
    });

    test('fully paid → paid', () {
      expect(
        InvoiceRules.statusFor(totalPaise: 270000, paidPaise: 270000),
        InvoiceStatus.paid,
      );
    });

    test('a ₹0 bill is paid at once', () {
      expect(
        InvoiceRules.statusFor(totalPaise: 0, paidPaise: 0),
        InvoiceStatus.paid,
      );
    });

    test('paid counts only non-void payments', () {
      expect(
        InvoiceRules.paidPaise([pay(1000), pay(500, isVoid: true), pay(200)]),
        1200,
      );
    });
  });

  group('invoice number', () {
    test('financial year runs April to March', () {
      expect(InvoiceRules.financialYear(DateTime(2026, 4, 1)), '2026-27');
      expect(
        InvoiceRules.financialYear(DateTime(2027, 3, 31, 23, 59)),
        '2026-27',
      );
      expect(InvoiceRules.financialYear(DateTime(2026, 1, 15)), '2025-26');
      expect(InvoiceRules.financialYear(DateTime(2099, 6, 1)), '2099-00');
    });

    test('format is prefix/FY/4-digit serial', () {
      expect(
        InvoiceRules.invoiceNumber(
          prefix: 'BBP',
          date: DateTime(2026, 5, 14),
          serial: 42,
        ),
        'BBP/2026-27/0042',
      );
      expect(
        InvoiceRules.invoiceNumber(
          prefix: 'BBP',
          date: DateTime(2026, 5, 14),
          serial: 12345,
        ),
        'BBP/2026-27/12345',
      );
    });
  });

  group('payment limits', () {
    test('valid payment', () {
      expect(
        InvoiceRules.paymentError(
          amountPaise: 170000,
          balancePaise: 170000,
          method: PaymentMethod.cash,
        ),
        isNull,
      );
    });

    test('amount must be more than 0', () {
      expect(
        InvoiceRules.paymentError(
          amountPaise: 0,
          balancePaise: 1000,
          method: PaymentMethod.upi,
        ),
        isNotNull,
      );
    });

    test('amount cannot exceed the balance', () {
      expect(
        InvoiceRules.paymentError(
          amountPaise: 1001,
          balancePaise: 1000,
          method: PaymentMethod.upi,
        ),
        'Amount is more than the balance due.',
      );
    });

    test('method is required', () {
      expect(
        InvoiceRules.paymentError(
          amountPaise: 100,
          balancePaise: 1000,
          method: null,
        ),
        isNotNull,
      );
    });
  });
}
