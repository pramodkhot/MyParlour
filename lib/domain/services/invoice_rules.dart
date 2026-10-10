import '../models/invoice.dart';
import '../models/payment.dart';

/// Bill status, numbering and payment rules (spec Section 6).
abstract final class InvoiceRules {
  /// Status of a finalised, non-void bill from its total and amount paid.
  /// A ₹0 bill is paid at once.
  static InvoiceStatus statusFor({
    required int totalPaise,
    required int paidPaise,
  }) {
    if (totalPaise <= 0) return InvoiceStatus.paid;
    if (paidPaise <= 0) return InvoiceStatus.finalised;
    if (paidPaise < totalPaise) return InvoiceStatus.partiallyPaid;
    return InvoiceStatus.paid;
  }

  /// Sum of non-void payments.
  static int paidPaise(Iterable<Payment> payments) =>
      payments.where((p) => !p.isVoid).fold(0, (sum, p) => sum + p.amountPaise);

  /// Indian financial year (April–March) label for [date], e.g. "2026-27".
  static String financialYear(DateTime date) {
    final local = date.toLocal();
    final startYear = local.month >= 4 ? local.year : local.year - 1;
    final endShort = ((startYear + 1) % 100).toString().padLeft(2, '0');
    return '$startYear-$endShort';
  }

  /// `{prefix}/{financial year}/{4-digit serial}`, e.g. `BBP/2026-27/0042`.
  static String invoiceNumber({
    required String prefix,
    required DateTime date,
    required int serial,
  }) => '$prefix/${financialYear(date)}/${serial.toString().padLeft(4, '0')}';

  /// Plain-language problem with a payment, or null when it can be recorded.
  static String? paymentError({
    required int amountPaise,
    required int balancePaise,
    required PaymentMethod? method,
  }) {
    if (method == null) return 'Choose how the customer paid.';
    if (amountPaise <= 0) return 'Enter an amount more than ₹0.';
    if (amountPaise > balancePaise) {
      return 'Amount is more than the balance due.';
    }
    return null;
  }
}
