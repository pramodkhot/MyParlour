import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../domain/services/customer_stats.dart';
import '../../appointments/appointment_status_chip.dart';
import '../../billing/invoice_status_chip.dart';

/// Appointments and bills, newest first.
class CustomerHistoryTab extends StatelessWidget {
  const CustomerHistoryTab({super.key, required this.entries});

  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return SingleChildScrollView(
        child: EmptyState(
          icon: Icons.history_rounded,
          message: context.l10n.custHistoryEmpty,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(Space.screen),
      itemCount: entries.length,
      separatorBuilder: (_, _) => Gap.h8,
      itemBuilder: (context, index) {
        final e = entries[index];
        final a = e.appointment;
        final bill = e.invoice;
        return AppCard(
          onTap: a == null ? null : () => context.go(Routes.appointment(a.id)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Dates.dayMonthYear(e.at), style: AppText.caption),
                    const SizedBox(height: 2),
                    Text(
                      e.services,
                      style: AppText.bodyStrong,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bill?.invoiceNo != null)
                      Text(bill!.invoiceNo!, style: AppText.caption),
                    if (a?.cancelReason != null)
                      Text(a!.cancelReason!, style: AppText.caption),
                  ],
                ),
              ),
              Gap.w8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MoneyText(e.amountPaise),
                  Gap.h4,
                  if (bill != null && (a == null || bill.balancePaise > 0))
                    InvoiceStatusChip(bill.status)
                  else if (a != null)
                    AppointmentStatusChip(a.status),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
