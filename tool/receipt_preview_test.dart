// Writes a sample receipt PDF per language from the demo data for a visual
// check. Not part of the normal test run.
//
//   flutter test tool/receipt_preview_test.dart --dart-define=OUT=<folder>
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:myparlour/core/l10n/app_language.dart';
import 'package:myparlour/core/l10n/l10n.dart';
import 'package:myparlour/core/l10n/language_controller.dart';
import 'package:myparlour/core/l10n/western_digits.dart';
import 'package:myparlour/data/demo/demo_seed.dart';
import 'package:myparlour/features/billing/receipt/receipt_pdf.dart';

import '../test/helpers/test_data.dart';

const _out = String.fromEnvironment('OUT', defaultValue: 'build/receipts');

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    loader.addFont(rootBundle.load('assets/fonts/$f'));
  }
  await loader.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    for (final language in AppLanguage.values) {
      await initializeDateFormatting(language.intlLocale);
    }
    useWesternDigits();
    await _loadFont('Manrope', ['Manrope-500.ttf', 'Manrope-700.ttf']);
    await _loadFont('PlayfairDisplay', ['PlayfairDisplay-700.ttf']);
    await _loadFont('NotoSansDevanagari', [
      'NotoSansDevanagari-400.ttf',
      'NotoSansDevanagari-600.ttf',
      'NotoSansDevanagari-700.ttf',
    ]);
    await _loadFont('NotoSerifDevanagari', ['NotoSerifDevanagari-700.ttf']);
  });

  for (final language in AppLanguage.values) {
    test('sample receipt (${language.name})', () async {
      Intl.defaultLocale = language.intlLocale;
      final data = DemoSeed.build(
        testNow,
        sequentialIds('demo'),
        language: language,
      );
      final bill = data.invoices.firstWhere((i) => i.discountPaise > 0);
      final customer = data.customers.firstWhere(
        (c) => c.id == bill.customerId,
      );
      final bytes = await buildReceiptPdf(
        ReceiptData(
          parlour: data.parlour,
          invoice: bill,
          payments: data.payments.where((p) => p.invoiceId == bill.id).toList(),
          customerName: customer.name,
          customerPhone: customer.phone,
          staffNames: {for (final s in data.staff) s.id: s.name},
        ),
        lookupAppLocalizations(language.locale),
      );
      final file = File('$_out/receipt_${language.name}.pdf');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
    });
  }
}
