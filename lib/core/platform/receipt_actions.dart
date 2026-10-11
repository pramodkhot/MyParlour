import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Shares, prints or saves a PDF. Each method returns false when the phone
/// could not do it, so the screen can show a message.
class ReceiptActions {
  const ReceiptActions();

  /// Opens the share sheet with the PDF attached (WhatsApp, email…).
  Future<bool> share(
    Uint8List pdf, {
    required String fileName,
    String? text,
  }) async {
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(pdf, mimeType: 'application/pdf', name: fileName),
          ],
          fileNameOverrides: [fileName],
          text: text,
        ),
      );
      return result.status != ShareResultStatus.unavailable;
    } on Object {
      return false;
    }
  }

  /// Opens the phone's print screen.
  Future<bool> print(Uint8List pdf, {required String fileName}) async {
    try {
      return await Printing.layoutPdf(
        onLayout: (_) async => pdf,
        name: fileName,
      );
    } on Object {
      return false;
    }
  }

  /// Opens the phone's print screen with the file name set, where
  /// "Save as PDF" saves it to the Downloads folder.
  Future<bool> download(Uint8List pdf, {required String fileName}) =>
      print(pdf, fileName: fileName);
}

final receiptActionsProvider = Provider<ReceiptActions>(
  (ref) => const ReceiptActions(),
);
