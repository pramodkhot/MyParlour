import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/format/money.dart';
import '../../../core/format/phone.dart';
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
    final rows = [
      (Icons.phone_outlined, 'Mobile', '+91 ${PhoneNumber.display(c.phone)}'),
      (Icons.mail_outline_rounded, 'Email', c.email ?? 'Not added'),
      (
        Icons.cake_outlined,
        'Birthday',
        c.birthday == null ? 'Not added' : formatDayMonth(c.birthday!),
      ),
      if (c.anniversary != null)
        (
          Icons.favorite_border_rounded,
          'Anniversary',
          formatDayMonth(c.anniversary!),
        ),
      (Icons.event_outlined, 'Customer since', Dates.dayMonthYear(c.createdAt)),
      (Icons.repeat_rounded, 'Visits', '${detail.visits}'),
      (
        Icons.payments_outlined,
        'Total spent',
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
