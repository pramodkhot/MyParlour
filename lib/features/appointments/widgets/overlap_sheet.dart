import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/buttons.dart';
import '../../../domain/models/appointment.dart';

/// Shown when the stylist already has a booking at that time. Resolves to
/// true for "Book anyway", false/null for "Pick another time".
Future<bool> showOverlapSheet(
  BuildContext context, {
  required String stylistName,
  required List<Appointment> clashes,
  required String Function(Appointment) clientName,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                ),
                Gap.w8,
                Expanded(
                  child: Text(
                    context.l10n.apptAlreadyBooked(stylistName),
                    style: AppText.barTitle,
                  ),
                ),
              ],
            ),
            Gap.h12,
            for (final a in clashes)
              Container(
                margin: const EdgeInsets.only(bottom: Space.sm),
                padding: const EdgeInsets.all(Space.md),
                decoration: const BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: Radii.controlAll,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Dates.time(a.startsAt)} – ${Dates.time(a.endsAt)}',
                      style: AppText.bodyStrong.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                    Text(
                      '${clientName(a)} · '
                      '${a.services.map((s) => s.name).join(', ')}',
                      style: AppText.body.copyWith(color: AppColors.warning),
                    ),
                  ],
                ),
              ),
            Gap.h8,
            PrimaryButton(
              label: context.l10n.apptPickAnotherTime,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            Gap.h12,
            SecondaryButton(
              label: context.l10n.apptBookAnyway,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}
