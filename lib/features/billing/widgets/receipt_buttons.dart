import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/platform/receipt_actions.dart';
import '../../../core/widgets/feedback.dart';
import '../receipt/receipt_pdf.dart';

/// Builds the receipt PDF and shares, prints or downloads it, with a
/// message when the phone cannot. Used by the bill and success screens.
class ReceiptSender {
  ReceiptSender(this._ref, this._context);

  final WidgetRef _ref;
  final BuildContext _context;

  Future<void> share(ReceiptData data) => _run(
    data,
    (actions, pdf) => actions.share(
      pdf,
      fileName: data.fileName,
      text: 'Receipt from ${data.parlour.name}',
    ),
    'Could not open sharing on this phone.',
  );

  Future<void> print(ReceiptData data) => _run(
    data,
    (actions, pdf) => actions.print(pdf, fileName: data.fileName),
    'Could not open printing on this phone.',
  );

  Future<void> download(ReceiptData data) => _run(
    data,
    (actions, pdf) => actions.download(pdf, fileName: data.fileName),
    'Could not save the PDF on this phone.',
  );

  Future<void> _run(
    ReceiptData data,
    Future<bool> Function(ReceiptActions, Uint8List) action,
    String failure,
  ) async {
    final actions = _ref.read(receiptActionsProvider);
    try {
      final pdf = await buildReceiptPdf(data);
      final ok = await action(actions, pdf);
      if (!ok && _context.mounted) showMessage(_context, failure);
    } on Object {
      if (_context.mounted) {
        showMessage(_context, 'Could not create the receipt.');
      }
    }
  }
}
