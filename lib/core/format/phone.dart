/// Indian mobile number helpers. Pure Dart, used by domain rules too.
abstract final class PhoneNumber {
  /// The 10-digit number for matching duplicates, or null if [input] is not
  /// a 10-digit number optionally prefixed by `+91`, `91` or `0`. Spaces,
  /// dashes and brackets are ignored.
  static String? normalise(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return digits;
    if (digits.length == 11 && digits.startsWith('0')) {
      return digits.substring(1);
    }
    if (digits.length == 12 && digits.startsWith('91')) {
      return digits.substring(2);
    }
    return null;
  }

  /// Digits to search for in a search box entry, ignoring a typed `+91`
  /// or leading `0` ("+91 9123" → "9123"). Empty when there are no digits.
  static String searchDigits(String query) {
    final q = query.trim().replaceFirst(RegExp(r'^\+\s*91'), '');
    return q.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^0+'), '');
  }

  /// True for numbers that normalise to 10 digits starting with 6–9.
  static bool isValidMobile(String input) {
    final normalised = normalise(input);
    return normalised != null && RegExp(r'^[6-9]').hasMatch(normalised);
  }

  /// "9876543210" → "98765 43210". Falls back to the input as typed.
  static String display(String input) {
    final n = normalise(input);
    if (n == null) return input.trim();
    return '${n.substring(0, 5)} ${n.substring(5)}';
  }

  /// `wa.me` link for WhatsApp, or null if the number is not valid.
  static Uri? whatsAppUri(String input) {
    final n = normalise(input);
    return n == null ? null : Uri.parse('https://wa.me/91$n');
  }
}
