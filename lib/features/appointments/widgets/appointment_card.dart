import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/models/appointment.dart';
import '../appointment_status_chip.dart';

/// One appointment in the day list: time column, client, services,
/// stylist and status.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.clientName,
    required this.stylistName,
    required this.onTap,
  });

  final Appointment appointment;
  final String clientName;
  final String stylistName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final a = appointment;
    final minutes = a.endsAt.difference(a.startsAt).inMinutes;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Dates.clock(a.startsAt),
                  style: AppText.bodyStrong.copyWith(color: AppColors.primary),
                ),
                Text(
                  '${Dates.amPm(a.startsAt)} · ${context.l10n.durationOneLine(minutes)}',
                  style: AppText.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Gap.w8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName,
                  style: AppText.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  a.services.map((s) => s.name).join(', '),
                  style: AppText.caption.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(stylistName, style: AppText.caption),
              ],
            ),
          ),
          Gap.w8,
          AppointmentStatusChip(a.status),
        ],
      ),
    );
  }
}
