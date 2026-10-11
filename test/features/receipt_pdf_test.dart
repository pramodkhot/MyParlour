import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:myparlour/core/l10n/app_language.dart';
import 'package:myparlour/core/l10n/l10n.dart';
import 'package:myparlour/core/l10n/western_digits.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/payment.dart';
import 'package:myparlour/features/billing/receipt/receipt_pdf.dart';

import '../helpers/test_data.dart';

Invoice bill({bool taxEnabled = false, int lines = 1}) => Invoice(
  id: 'b1',
  parlourId: 'parlour-1',
  invoiceNo: 'BBP/2026-27/0042',
  status: InvoiceStatus.partiallyPaid,
  items: [
    for (var i = 1; i <= lines; i++)
      InvoiceItem(
        id: 'l$i',
        type: InvoiceItemType.service,
        refId: 'svc-haircut',
        name: 'Haircut',
        unitPricePaise: 50000,
        qty: 1,
        taxRateBp: 1800,
        lineTotalPaise: 50000,
        staffId: 'staff-anita',
      ),
  ],
  subtotalPaise: 50000,
  discountPaise: 5000,
  taxablePaise: 45000,
  taxPaise: 0,
  totalPaise: 45000,
  paidPaise: 20000,
  balancePaise: 25000,
  taxEnabled: taxEnabled,
  createdAt: DateTime(2026, 5, 14, 16),
  finalisedAt: DateTime(2026, 5, 14, 16),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final language in AppLanguage.values) {
      await initializeDateFormatting(language.intlLocale);
    }
    useWesternDigits();
  });
  tearDown(() => Intl.defaultLocale = null);

  AppLocalizations l10n([AppLanguage language = AppLanguage.en]) {
    Intl.defaultLocale = language.intlLocale;
    return lookupAppLocalizations(Locale(language.name));
  }

  ReceiptData data({bool taxEnabled = false, String? gstin}) => ReceiptData(
    parlour: testParlour(taxEnabled: taxEnabled).copyWith(gstin: gstin),
    invoice: bill(taxEnabled: taxEnabled),
    payments: [
      Payment(
        id: 'p1',
        parlourId: 'parlour-1',
        invoiceId: 'b1',
        amountPaise: 20000,
        method: PaymentMethod.upi,
        reference: 'UPI123',
        receivedAt: DateTime(2026, 5, 14, 16, 5),
      ),
    ],
    customerName: 'Priya Sharma',
    customerPhone: '98765 43210',
    staffNames: const {'staff-anita': 'Anita'},
  );

  test('builds a PDF', () async {
    final bytes = await buildReceiptPdf(data(), l10n());
    expect(bytes.length, greaterThan(1000));
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
  });

  test('file name is safe for sharing', () {
    expect(data().fileName, 'Receipt-BBP-2026-27-0042.pdf');
  });

  test('tax invoice only when GST was on and a GSTIN is set', () {
    expect(data().isTaxInvoice, isFalse);
    expect(data(taxEnabled: true).isTaxInvoice, isFalse);
    expect(
      data(taxEnabled: true, gstin: '27ABCDE1234F1Z5').isTaxInvoice,
      isTrue,
    );
  });

  test('builds with GST on as well', () async {
    final bytes = await buildReceiptPdf(
      data(taxEnabled: true, gstin: '27ABCDE1234F1Z5'),
      l10n(),
    );
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
  });

  for (final language in [AppLanguage.mr, AppLanguage.hi]) {
    test('builds in ${language.name}', () async {
      final bytes = await buildReceiptPdf(data(), l10n(language));
      expect(bytes.length, greaterThan(1000));
      expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    });
  }

  test('a long bill makes a taller page instead of cutting items', () async {
    final long = data();
    final bytes = await buildReceiptPdf(
      ReceiptData(
        parlour: long.parlour,
        invoice: bill(lines: 40),
        payments: long.payments,
        customerName: long.customerName,
      ),
      l10n(),
    );
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
  });
}
