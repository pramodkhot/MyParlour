import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/l10n/l10n.dart';
import '../../../domain/models/invoice.dart';
import '../../../domain/models/parlour.dart';
import '../../../domain/models/payment.dart';
import 'offscreen_render.dart';
import 'receipt_view.dart';

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

/// Builds the receipt PDF in the language of [l10n].
///
/// The `pdf` package cannot join Devanagari letters correctly, so the
/// receipt is drawn by Flutter ([ReceiptView]) at 3× and placed in the PDF as
/// one image: A5 width, and taller than A5 only when the bill is long.
Future<Uint8List> buildReceiptPdf(
  ReceiptData data,
  AppLocalizations l10n,
) async {
  const scale = 3.0;
  final image = await renderOffscreen(
    ReceiptView(data: data, l10n: l10n),
    maxWidth: ReceiptView.pageWidth,
    pixelRatio: scale,
  );
  final width = image.width / scale;
  final height = image.height / scale;
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();

  final doc = pw.Document(title: data.fileName, author: data.parlour.name);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(width, height),
      margin: pw.EdgeInsets.zero,
      build: (_) => pw.Image(
        pw.MemoryImage(png!.buffer.asUint8List()),
        width: width,
        height: height,
        fit: pw.BoxFit.fill,
      ),
    ),
  );
  return doc.save();
}
