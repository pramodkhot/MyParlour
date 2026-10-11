import 'package:flutter/widgets.dart';

import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/format/money.dart';
import '../../../core/format/phone.dart';
import '../../../core/l10n/l10n.dart';
import 'receipt_pdf.dart';

/// The printed receipt, drawn by Flutter so Marathi and Hindi letters are
/// shaped correctly. Sizes are in PDF points: [pageWidth] × at least
/// [pageHeight] (A5).
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.data, required this.l10n});

  static const pageWidth = 420.0;
  static const pageHeight = 595.0;
  static const margin = 28.0;

  static const burgundy = Color(0xFFA92750);
  static const muted = Color(0xFF6F6268);
  static const line = Color(0xFFF0E1E5);
  static const black = Color(0xFF000000);

  final ReceiptData data;
  final AppLocalizations l10n;

  static TextStyle _s(double size, {bool strong = false, Color? color}) =>
      TextStyle(
        fontFamily: AppText.sans,
        fontFamilyFallback: AppText.sansFallback,
        fontSize: size,
        fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
        color: color ?? black,
        height: 1.3,
      );

  static TextStyle _serif(double size) => TextStyle(
    fontFamily: AppText.serif,
    fontFamilyFallback: AppText.serifFallback,
    fontSize: size,
    fontWeight: FontWeight.w700,
    color: burgundy,
    height: 1.3,
  );

  Widget _amountRow(String label, int paise, {bool strong = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: _s(9, strong: strong)),
        ),
        Text(Money.format(paise), style: _s(9, strong: strong)),
      ],
    ),
  );

  Widget _cell(
    Widget child, {
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    child: Align(alignment: alignment, child: child),
  );

  @override
  Widget build(BuildContext context) {
    final p = data.parlour;
    final bill = data.invoice;
    final when = (bill.finalisedAt ?? bill.createdAt).toLocal();
    final date = '${Dates.dayMonthYear(when)}, ${Dates.time(when)}';
    const right = AlignmentDirectional.centerEnd;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: pageWidth,
        maxWidth: pageWidth,
        minHeight: pageHeight,
      ),
      child: ColoredBox(
        color: const Color(0xFFFFFFFF),
        child: Padding(
          padding: const EdgeInsets.all(margin),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(p.name, textAlign: TextAlign.center, style: _serif(18)),
                Text(
                  [p.area, if (p.address != null) p.address!].join(' · '),
                  textAlign: TextAlign.center,
                  style: _s(8.5, color: muted),
                ),
                Text(
                  l10n.receiptPhone(p.phone),
                  textAlign: TextAlign.center,
                  style: _s(8.5, color: muted),
                ),
                if (data.isTaxInvoice)
                  Text(
                    l10n.receiptGstin(p.gstin!),
                    textAlign: TextAlign.center,
                    style: _s(8.5, color: muted),
                  ),
                const SizedBox(height: 10),
                Text(
                  data.isTaxInvoice
                      ? l10n.receiptTaxInvoice
                      : l10n.receiptHeading,
                  textAlign: TextAlign.center,
                  style: _s(10, strong: true, color: burgundy),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.customerName, style: _s(9.5, strong: true)),
                          if (data.customerPhone != null)
                            Text(
                              '+91 ${PhoneNumber.display(data.customerPhone!)}',
                              style: _s(8.5, color: muted),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bill.invoiceNo ?? l10n.billStatusDraft,
                          style: _s(9.5, strong: true),
                        ),
                        Text(date, style: _s(8.5, color: muted)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: line)),
                      ),
                      children: [
                        _cell(
                          Text(
                            l10n.receiptItem,
                            style: _s(8.5, strong: true, color: muted),
                          ),
                        ),
                        _cell(
                          Text(
                            l10n.receiptQty,
                            style: _s(8.5, strong: true, color: muted),
                          ),
                          alignment: Alignment.center,
                        ),
                        _cell(
                          Text(
                            l10n.receiptRate,
                            style: _s(8.5, strong: true, color: muted),
                          ),
                          alignment: right,
                        ),
                        _cell(
                          Text(
                            l10n.receiptAmount,
                            style: _s(8.5, strong: true, color: muted),
                          ),
                          alignment: right,
                        ),
                      ],
                    ),
                    for (final item in bill.items)
                      TableRow(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: line, width: 0.5),
                          ),
                        ),
                        children: [
                          _cell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: _s(9)),
                                if (item.staffId != null &&
                                    data.staffNames[item.staffId] != null)
                                  Text(
                                    l10n.receiptStylist(
                                      data.staffNames[item.staffId]!,
                                    ),
                                    style: _s(8, color: muted),
                                  ),
                              ],
                            ),
                          ),
                          _cell(
                            Text('${item.qty}', style: _s(9)),
                            alignment: Alignment.center,
                          ),
                          _cell(
                            Text(
                              Money.format(item.unitPricePaise),
                              style: _s(9),
                            ),
                            alignment: right,
                          ),
                          _cell(
                            Text(
                              Money.format(item.unitPricePaise * item.qty),
                              style: _s(9),
                            ),
                            alignment: right,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _amountRow(l10n.receiptSubtotal, bill.subtotalPaise),
                if (bill.discountPaise > 0)
                  _amountRow(l10n.receiptDiscount, -bill.discountPaise),
                if (bill.taxEnabled) _amountRow(l10n.receiptGst, bill.taxPaise),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(height: 1, child: ColoredBox(color: line)),
                ),
                _amountRow(l10n.receiptTotal, bill.totalPaise, strong: true),
                _amountRow(l10n.receiptPaid, bill.paidPaise),
                _amountRow(
                  l10n.receiptBalance,
                  bill.balancePaise,
                  strong: bill.balancePaise > 0,
                ),
                if (data.payments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.receiptPayments,
                    style: _s(8.5, strong: true, color: muted),
                  ),
                  for (final pay in data.payments)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            [
                              Dates.dayMonthTime(pay.receivedAt),
                              l10n.paymentMethod(pay.method),
                              if (pay.reference != null) pay.reference!,
                            ].join(' · '),
                            style: _s(8.5),
                          ),
                        ),
                        Text(Money.format(pay.amountPaise), style: _s(8.5)),
                      ],
                    ),
                ],
                const Spacer(),
                const SizedBox(height: 16),
                Text(
                  p.receiptFooter,
                  textAlign: TextAlign.center,
                  style: _serif(11),
                ),
                if (!data.isTaxInvoice)
                  Text(
                    l10n.receiptNotTaxInvoice,
                    textAlign: TextAlign.center,
                    style: _s(7, color: muted),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
