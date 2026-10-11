import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:myparlour/core/format/dates.dart';
import 'package:myparlour/core/format/money.dart';
import 'package:myparlour/core/l10n/app_language.dart';
import 'package:myparlour/core/l10n/l10n.dart';
import 'package:myparlour/core/l10n/western_digits.dart';
import 'package:myparlour/domain/errors.dart';

void main() {
  setUpAll(() async {
    for (final language in AppLanguage.values) {
      await initializeDateFormatting(language.intlLocale);
    }
    useWesternDigits();
  });
  tearDown(() => Intl.defaultLocale = null);

  final when = DateTime(2026, 5, 14, 16, 30);

  for (final language in AppLanguage.values) {
    test('dates, times and amounts use 0–9 (${language.name})', () {
      Intl.defaultLocale = language.intlLocale;
      final texts = [
        Dates.dayMonthYear(when),
        Dates.weekdayDayMonthYear(when),
        Dates.dayMonthTime(when),
        Dates.monthYear(when),
        Money.format(12345600),
        NumberFormat.decimalPattern().format(1250),
      ];
      for (final t in texts) {
        expect(t, isNot(matches(RegExp('[०-९]'))), reason: t);
      }
      expect(Dates.time(when), '4:30 PM');
      expect(Money.format(125000), '₹1,250');
    });

    test('every error has a message (${language.name})', () {
      final l10n = lookupAppLocalizations(Locale(language.name));
      const args = {
        'from': 'booked',
        'to': 'completed',
        'name': 'Shampoo',
        'qty': '2',
        'invoiceNo': 'BBP/2026-27/0001',
      };
      for (final code in ErrorCode.values) {
        final text = l10n.error(DomainError(code, args));
        expect(text.trim(), isNotEmpty, reason: code.name);
        expect(text, isNot(contains('{')), reason: code.name);
      }
    });
  }

  test('English error texts match the domain messages', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    const args = {'name': 'Shampoo', 'qty': '2', 'invoiceNo': 'X/1'};
    for (final code in ErrorCode.values) {
      if (code == ErrorCode.statusChange) continue; // status names differ
      final error = DomainError(code, args);
      expect(l10n.error(error), error.message, reason: code.name);
    }
  });
}
