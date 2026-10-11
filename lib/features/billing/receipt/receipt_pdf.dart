import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/format/money.dart';
import '../../../core/format/phone.dart';
import '../../../domain/models/invoice.dart';
import '../../../domain/models/parlour.dart';
import '../../../domain/models/payment.dart';

/// Everything printed on a receipt.
class ReceiptData {
  const ReceiptData({
    required this.parlour,
    required this.invoice,
    required this.payments,
    required this.customerName,
    this.customerPhone,
    this.staffNames = const {},
  });

  final Parlour parlour;
  final Invoice invoice;

  /// Non-void payments, oldest first.
  final List<Payment> payments;
  final String customerName;
  final String? customerPhone;
  final Map<String, String> staffNames;

  /// Shown as "Tax invoice" only when GST was on for this bill and the
  /// parlour has a GSTIN; otherwise it is a plain receipt.
  bool get isTaxInvoice =>
      invoice.taxEnabled && (parlour.gstin?.trim().isNotEmpty ?? false);

  String get fileName =>
      'Receipt-${(invoice.invoiceNo ?? 'draft').replaceAll('/', '-')}.pdf';
}

const _burgundy = PdfColor.fromInt(0xFFA92750);
const _muted = PdfColor.fromInt(0xFF6F6268);
const _line = PdfColor.fromInt(0xFFF0E1E5);

String _methodLabel(PaymentMethod m) => switch (m) {
  PaymentMethod.cash => 'Cash',
  PaymentMethod.upi => 'UPI',
  PaymentMethod.card => 'Card',
  PaymentMethod.other => 'Other',
};

/// Builds an A5 receipt. Fonts are the app's bundled Manrope and Playfair
/// Display (they include the ₹ sign).
Future<Uint8List> buildReceiptPdf(ReceiptData data) async {
  Future<pw.Font> font(String path) async =>
      pw.Font.ttf(await rootBundle.load(path));
  final regular = await font('assets/fonts/Manrope-500.ttf');
  final bold = await font('assets/fonts/Manrope-700.ttf');
  final serif = await font('assets/fonts/PlayfairDisplay-700.ttf');

  final p = data.parlour;
  final bill = data.invoice;
  final date = DateFormat(
    'd MMM y, h:mm a',
    'en_IN',
  ).format((bill.finalisedAt ?? bill.createdAt).toLocal());

  pw.TextStyle s(double size, {bool strong = false, PdfColor? color}) =>
      pw.TextStyle(
        font: strong ? bold : regular,
        fontSize: size,
        color: color ?? PdfColors.black,
      );

  pw.Widget amountRow(String label, int paise, {bool strong = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(label, style: s(9, strong: strong)),
            ),
            pw.Text(Money.format(paise), style: s(9, strong: strong)),
          ],
        ),
      );

  final doc = pw.Document(title: data.fileName, author: p.name);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      margin: const pw.EdgeInsets.all(28),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Text(
            p.name,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: serif, fontSize: 18, color: _burgundy),
          ),
          pw.Text(
            [p.area, if (p.address != null) p.address!].join(' · '),
            textAlign: pw.TextAlign.center,
            style: s(8.5, color: _muted),
          ),
          pw.Text(
            'Phone ${p.phone}',
            textAlign: pw.TextAlign.center,
            style: s(8.5, color: _muted),
          ),
          if (data.isTaxInvoice)
            pw.Text(
              'GSTIN ${p.gstin}',
              textAlign: pw.TextAlign.center,
              style: s(8.5, color: _muted),
            ),
          pw.SizedBox(height: 10),
          pw.Text(
            data.isTaxInvoice ? 'TAX INVOICE' : 'RECEIPT',
            textAlign: pw.TextAlign.center,
            style: s(10, strong: true, color: _burgundy),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(data.customerName, style: s(9.5, strong: true)),
                    if (data.customerPhone != null)
                      pw.Text(
                        '+91 ${PhoneNumber.display(data.customerPhone!)}',
                        style: s(8.5, color: _muted),
                      ),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    bill.invoiceNo ?? 'Draft',
                    style: s(9.5, strong: true),
                  ),
                  pw.Text(date, style: s(8.5, color: _muted)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            border: null,
            headerStyle: s(8.5, strong: true, color: _muted),
            cellStyle: s(9),
            headerDecoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: _line)),
            ),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: _line, width: 0.5),
              ),
            ),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
            },
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            },
            headers: ['Item', 'Qty', 'Rate', 'Amount'],
            data: [
              for (final item in bill.items)
                [
                  item.staffId != null && data.staffNames[item.staffId] != null
                      ? '${item.name}\nStylist: ${data.staffNames[item.staffId]}'
                      : item.name,
                  '${item.qty}',
                  Money.format(item.unitPricePaise),
                  Money.format(item.unitPricePaise * item.qty),
                ],
            ],
          ),
          pw.SizedBox(height: 8),
          amountRow('Subtotal', bill.subtotalPaise),
          if (bill.discountPaise > 0)
            amountRow('Discount', -bill.discountPaise),
          if (bill.taxEnabled) amountRow('GST', bill.taxPaise),
          pw.Divider(color: _line),
          amountRow('Total', bill.totalPaise, strong: true),
          amountRow('Paid', bill.paidPaise),
          amountRow(
            'Balance',
            bill.balancePaise,
            strong: bill.balancePaise > 0,
          ),
          if (data.payments.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text('Payments', style: s(8.5, strong: true, color: _muted)),
            for (final pay in data.payments)
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      '${DateFormat('d MMM, h:mm a', 'en_IN').format(pay.receivedAt.toLocal())}'
                      ' · ${_methodLabel(pay.method)}'
                      '${pay.reference == null ? '' : ' · ${pay.reference}'}',
                      style: s(8.5),
                    ),
                  ),
                  pw.Text(Money.format(pay.amountPaise), style: s(8.5)),
                ],
              ),
          ],
          pw.Spacer(),
          pw.Text(
            p.receiptFooter,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: serif, fontSize: 11, color: _burgundy),
          ),
          if (!data.isTaxInvoice)
            pw.Text(
              'This is a payment receipt, not a GST tax invoice.',
              textAlign: pw.TextAlign.center,
              style: s(7, color: _muted),
            ),
        ],
      ),
    ),
  );
  return doc.save();
}
