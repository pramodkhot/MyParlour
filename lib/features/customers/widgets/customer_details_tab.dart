import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/format/money.dart';
import '../../../core/format/phone.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/day_month_picker.dart';
import '../customers_controller.dart';

/// Contact details and lifetime figures.
class CustomerDetailsTab extends StatelessWidget {
  const CustomerDetailsTab({super.key, required this.detail});

  final CustomerDetail detail;

  @override
  Widget build(BuildContext context) {
    final c = detail.customer;
    final l10n = context.l10n;
    final rows = [
      (
        Icons.phone_outlined,
        l10n.custMobile,
        '+91 ${PhoneNumber.display(c.phone)}',
      ),
      (
        Icons.mail_outline_rounded,
        l10n.custEmail,
        c.email ?? l10n.commonNotAdded,
      ),
      (
        Icons.cake_outlined,
        l10n.custBirthday,
        c.birthday == null ? l10n.commonNotAdded : formatDayMonth(c.birthday!),
      ),
      if (c.anniversary != null)
        (
          Icons.favorite_border_rounded,
          l10n.custAnniversary,
          formatDayMonth(c.anniversary!),
        ),
      (Icons.event_outlined, l10n.custSince, Dates.dayMonthYear(c.createdAt)),
      (Icons.repeat_rounded, l10n.custVisits, '${detail.visits}'),
      (
        Icons.payments_outlined,
        l10n.custTotalSpent,
        Money.format(detail.totalSpentPaise),
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(indent: 52),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.lg,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(rows[i].$1, size: 20, color: AppColors.primary),
                      Gap.w16,
                      Expanded(child: Text(rows[i].$2, style: AppText.label)),
                      Flexible(
                        flex: 2,
                        child: Text(
                          rows[i].$3,
                          textAlign: TextAlign.end,
                          style: AppText.bodyStrong,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
