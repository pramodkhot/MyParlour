import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../domain/models/appointment.dart';
import '../../appointments/appointment_status_chip.dart';
import '../dashboard_controller.dart';

/// Up to three upcoming appointments in one card.
class NextAppointmentsCard extends StatelessWidget {
  const NextAppointmentsCard({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final next = data.summary.nextAppointments;
    void openAppointments() => context.go(Routes.appointments);

    return Column(
      children: [
        SectionHeader(
          title: 'Next appointments',
          actionLabel: 'See all',
          onAction: openAppointments,
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: next.isEmpty
              ? _Empty(onBook: openAppointments)
              : Column(
                  children: [
                    for (var i = 0; i < next.length; i++) ...[
                      if (i > 0)
                        const Divider(indent: Space.lg, endIndent: Space.lg),
                      _Row(
                        appointment: next[i],
                        data: data,
                        onTap: openAppointments,
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.appointment,
    required this.data,
    required this.onTap,
  });

  final Appointment appointment;
  final DashboardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final a = appointment;
    final services = a.services.map((s) => s.name).join(', ');
    final isToday = DateUtils.isSameDay(a.startsAt.toLocal(), data.now);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: Space.md,
        ),
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
                    style: AppText.bodyStrong.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${Dates.amPm(a.startsAt)} · '
                    '${Dates.duration(a.endsAt.difference(a.startsAt).inMinutes)}',
                    style: AppText.caption.copyWith(fontSize: 11),
                  ),
                  if (!isToday)
                    Text(
                      Dates.dayMonth(a.startsAt),
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
                    data.clientName(a),
                    style: AppText.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$services · ${data.stylistName(a)}',
                    style: AppText.caption.copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Gap.w8,
            AppointmentStatusChip(a.status),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onBook});

  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Space.lg),
      child: Row(
        children: [
          const Icon(Icons.event_available_outlined, color: AppColors.primary),
          Gap.w12,
          Expanded(
            child: Text(
              'No more appointments today.',
              style: AppText.body.copyWith(color: AppColors.textMuted),
            ),
          ),
          TextButton(onPressed: onBook, child: const Text('Book')),
        ],
      ),
    );
  }
}
