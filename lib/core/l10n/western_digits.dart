import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

/// Makes dates and numbers use 0–9 in every language. Marathi's default
/// is Devanagari digits (०–९); parlour owners read prices, times and phone
/// numbers in 0–9, as on UPI apps and receipts. Also affects Flutter's own
/// date and time pickers.
void useWesternDigits() {
  for (final locale in const ['mr', 'hi']) {
    DateFormat.useNativeDigitsByDefaultFor(locale, false);
    final s = numberFormatSymbols[locale];
    if (s == null || s.ZERO_DIGIT == '0') continue;
    numberFormatSymbols[locale] = NumberSymbols(
      NAME: s.NAME,
      DECIMAL_SEP: s.DECIMAL_SEP,
      GROUP_SEP: s.GROUP_SEP,
      PERCENT: s.PERCENT,
      ZERO_DIGIT: '0',
      PLUS_SIGN: s.PLUS_SIGN,
      MINUS_SIGN: s.MINUS_SIGN,
      EXP_SYMBOL: s.EXP_SYMBOL,
      PERMILL: s.PERMILL,
      INFINITY: s.INFINITY,
      NAN: s.NAN,
      DECIMAL_PATTERN: s.DECIMAL_PATTERN,
      SCIENTIFIC_PATTERN: s.SCIENTIFIC_PATTERN,
      PERCENT_PATTERN: s.PERCENT_PATTERN,
      CURRENCY_PATTERN: s.CURRENCY_PATTERN,
      DEF_CURRENCY_CODE: s.DEF_CURRENCY_CODE,
    );
  }
}
