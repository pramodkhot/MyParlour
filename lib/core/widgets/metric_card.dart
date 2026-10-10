import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import 'app_card.dart';

/// Dashboard / report figure: label, big value, coloured caption and a
/// small outline icon in the top-right corner.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.captionColor = AppColors.textMuted,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? caption;
  final Color captionColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppText.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap.w4,
              Icon(icon, size: 20, color: AppColors.primary),
            ],
          ),
          Gap.h8,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppText.bigNumber, maxLines: 1),
          ),
          if (caption != null) ...[
            Gap.h4,
            Text(
              caption!,
              style: AppText.caption.copyWith(
                color: captionColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
