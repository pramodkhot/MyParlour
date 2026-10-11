import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/money.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/qty_stepper.dart';
import '../../../domain/models/invoice.dart';
import '../../../domain/repositories/repositories.dart';

/// One line on the Create bill screen. Swipe left to remove.
class BillLineTile extends StatelessWidget {
  const BillLineTile({
    super.key,
    required this.line,
    required this.stylistName,
    required this.maxQty,
    required this.onQty,
    required this.onRemove,
  });

  final BillLine line;
  final String? stylistName;
  final int maxQty;
  final ValueChanged<int> onQty;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key ?? ValueKey('${line.type.name}-${line.refId}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Space.xl),
        decoration: const BoxDecoration(
          color: AppColors.errorBg,
          borderRadius: Radii.controlAll,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Space.md,
          Space.sm,
          Space.xs,
          Space.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Radii.controlAll,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              line.type == InvoiceItemType.service
                  ? Icons.content_cut_rounded
                  : Icons.inventory_2_outlined,
              size: 20,
              color: AppColors.rose,
            ),
            Gap.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(line.name, style: AppText.bodyStrong),
                  if (stylistName != null)
                    Text(
                      context.l10n.billingStylistName(stylistName!),
                      style: AppText.caption,
                    ),
                  Text(
                    Money.format(line.unitPricePaise * line.qty),
                    style: AppText.caption.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            QtyStepper(value: line.qty, max: maxQty, onChanged: onQty),
          ],
        ),
      ),
    );
  }
}

/// Small helpers for the immutable [BillLine].
extension BillLineCopy on BillLine {
  BillLine withQty(int qty) => BillLine(
    type: type,
    refId: refId,
    name: name,
    unitPricePaise: unitPricePaise,
    qty: qty,
    itemDiscountPaise: itemDiscountPaise,
    taxRateBp: taxRateBp,
    staffId: staffId,
  );

  /// As an [InvoiceItem], for previewing totals.
  InvoiceItem toPreviewItem(int index) => InvoiceItem(
    id: 'preview-$index',
    type: type,
    refId: refId,
    name: name,
    unitPricePaise: unitPricePaise,
    qty: qty,
    itemDiscountPaise: itemDiscountPaise,
    taxRateBp: taxRateBp,
    staffId: staffId,
  );
}

/// The lines of an existing bill, for editing a draft.
List<BillLine> billLinesOf(Invoice invoice) => [
  for (final i in invoice.items)
    BillLine(
      type: i.type,
      refId: i.refId,
      name: i.name,
      unitPricePaise: i.unitPricePaise,
      qty: i.qty,
      itemDiscountPaise: i.itemDiscountPaise,
      taxRateBp: i.taxRateBp,
      staffId: i.staffId,
    ),
];
