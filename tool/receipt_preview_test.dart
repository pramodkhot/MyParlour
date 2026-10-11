// Writes a sample receipt PDF from the demo data for a visual check.
// Not part of the normal test run.
//
//   flutter test tool/receipt_preview_test.dart --dart-define=OUT=<folder>
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myparlour/data/demo/demo_seed.dart';
import 'package:myparlour/features/billing/receipt/receipt_pdf.dart';

import '../test/helpers/test_data.dart';

const _out = String.fromEnvironment('OUT', defaultValue: 'build/receipts');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sample receipt', () async {
    await initializeDateFormatting('en_IN');
    final data = DemoSeed.build(testNow, sequentialIds('demo'));
    final bill = data.invoices.firstWhere((i) => i.discountPaise > 0);
    final customer = data.customers.firstWhere((c) => c.id == bill.customerId);
    final bytes = await buildReceiptPdf(
      ReceiptData(
        parlour: data.parlour,
        invoice: bill,
        payments: data.payments.where((p) => p.invoiceId == bill.id).toList(),
        customerName: customer.name,
        customerPhone: customer.phone,
        staffNames: {for (final s in data.staff) s.id: s.name},
      ),
    );
    final file = File('$_out/receipt.pdf');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
  });
}
