import 'package:intl/intl.dart';

/// Formats money stored as integer paise into Indian rupees.
///
/// Whole rupees show without decimals (`₹1,23,456`); amounts with paise
/// show two decimals (`₹499.50`). Negative values show as `-₹300`.
abstract final class Money {
  static final _whole = NumberFormat('#,##,##0', 'en_IN');

  static String format(int paise) {
    final sign = paise < 0 ? '-' : '';
    final abs = paise.abs();
    final rupees = _whole.format(abs ~/ 100);
    final rest = abs % 100;
    if (rest == 0) return '$sign₹$rupees';
    return '$sign₹$rupees.${rest.toString().padLeft(2, '0')}';
  }

  /// Converts a rupee amount typed by the user (e.g. "499" or "499.5")
  /// into paise. Returns null when the text is not a valid amount.
  static int? parseRupees(String input) {
    final cleaned = input.replaceAll(',', '').replaceAll('₹', '').trim();
    if (cleaned.isEmpty) return null;
    if (!RegExp(r'^\d+(\.\d{0,2})?$').hasMatch(cleaned)) return null;
    final parts = cleaned.split('.');
    final rupees = int.parse(parts[0]);
    final paiseText = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    return rupees * 100 + int.parse(paiseText);
  }
}
