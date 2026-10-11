import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/money.dart';
import '../../../core/l10n/l10n.dart';

/// Tinted card: Subtotal, Discount (−), GST (only when on), Total.
class TotalsCard extends StatelessWidget {
  const TotalsCard({
    super.key,
    required this.subtotalPaise,
    required this.discountPaise,
    required this.taxPaise,
    required this.totalPaise,
    required this.showTax,
    this.extraRows = const [],
  });

  final int subtotalPaise;
  final int discountPaise;
  final int taxPaise;
  final int totalPaise;
  final bool showTax;

  /// Optional rows after Total (e.g. Paid, Balance).
  final List<(String, int, bool)> extraRows;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget row(String label, String value, {TextStyle? style}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style ?? AppText.body)),
          Text(value, style: style ?? AppText.body),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: const BoxDecoration(
        color: AppColors.chipSelected,
        borderRadius: Radii.cardAll,
      ),
      child: Column(
        children: [
          row(l10n.billingSubtotal, Money.format(subtotalPaise)),
          if (discountPaise > 0)
            row(l10n.billingDiscount, '− ${Money.format(discountPaise)}'),
          if (showTax) row(l10n.billingGst, Money.format(taxPaise)),
          const Divider(height: Space.xl, color: AppColors.blushDeep),
          row(
            l10n.billingTotal,
            Money.format(totalPaise),
            style: AppText.bodyStrong.copyWith(fontSize: 18),
          ),
          for (final (label, paise, strong) in extraRows)
            row(
              label,
              Money.format(paise),
              style: strong ? AppText.bodyStrong : null,
            ),
        ],
      ),
    );
  }
}
