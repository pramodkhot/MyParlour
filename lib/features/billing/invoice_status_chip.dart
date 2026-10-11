import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/status_chip.dart';
import '../../domain/models/invoice.dart';

/// Read-only status chip for a bill.
class InvoiceStatusChip extends StatelessWidget {
  const InvoiceStatusChip(this.status, {super.key});

  final InvoiceStatus status;

  static ChipTone toneFor(InvoiceStatus status) => switch (status) {
    InvoiceStatus.draft => ChipTone.neutral,
    InvoiceStatus.finalised => ChipTone.error,
    InvoiceStatus.partiallyPaid => ChipTone.warning,
    InvoiceStatus.paid => ChipTone.success,
    InvoiceStatus.void_ => ChipTone.neutral,
  };

  @override
  Widget build(BuildContext context) => StatusChip(
    label: context.l10n.invoiceStatus(status),
    tone: toneFor(status),
  );
}
