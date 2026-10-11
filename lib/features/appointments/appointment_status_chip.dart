import 'package:flutter/material.dart';

import '../../core/widgets/status_chip.dart';
import '../../domain/models/appointment.dart';
import '../../core/l10n/l10n.dart';

/// Read-only status chip for an appointment.
class AppointmentStatusChip extends StatelessWidget {
  const AppointmentStatusChip(this.status, {super.key});

  final AppointmentStatus status;

  static ChipTone toneFor(AppointmentStatus status) => switch (status) {
    AppointmentStatus.booked => ChipTone.info,
    AppointmentStatus.checkedIn => ChipTone.success,
    AppointmentStatus.completed => ChipTone.success,
    AppointmentStatus.cancelled => ChipTone.error,
    AppointmentStatus.noShow => ChipTone.neutral,
  };

  @override
  Widget build(BuildContext context) => StatusChip(
    label: context.l10n.appointmentStatus(status),
    tone: toneFor(status),
  );
}
