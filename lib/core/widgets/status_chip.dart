import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/typography.dart';

/// Colour family for a [StatusChip] (spec Section 8 status colours).
enum ChipTone {
  success(AppColors.success, AppColors.successBg),
  warning(AppColors.warning, AppColors.warningBg),
  error(AppColors.error, AppColors.errorBg),
  info(AppColors.info, AppColors.infoBg),
  neutral(AppColors.neutral, AppColors.neutralBg);

  const ChipTone(this.foreground, this.background);

  final Color foreground;
  final Color background;
}

/// Small read-only pill showing a status such as "Paid" or "Low stock".
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.tone});

  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: ShapeDecoration(
        color: tone.background,
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: AppText.chip.copyWith(color: tone.foreground, fontSize: 11.5),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
