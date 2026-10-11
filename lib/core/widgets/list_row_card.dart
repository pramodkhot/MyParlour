import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import 'app_card.dart';

/// A tappable list row inside its own card: leading widget, title,
/// subtitle lines and a trailing widget (chip, amount or chevron).
class ListRowCard extends StatelessWidget {
  const ListRowCard({
    super.key,
    required this.title,
    this.subtitle,
    this.caption,
    this.leading,
    this.trailing,
    this.onTap,
    this.dimmed = false,
  });

  final String title;
  final String? subtitle;
  final String? caption;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Greys out inactive records (e.g. deactivated staff or services).
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        if (leading != null) ...[leading!, Gap.w12],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.bodyStrong,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppText.caption.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (caption != null) ...[
                const SizedBox(height: 2),
                Text(
                  caption!,
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        // Flexible: on narrow screens or large text the trailing part may
        // shrink (up to half the row) instead of overflowing.
        if (trailing != null) ...[Gap.w8, Flexible(child: trailing!)],
      ],
    );

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Opacity(opacity: dimmed ? 0.55 : 1, child: row),
    );
  }
}

/// Standard right-hand chevron for rows that open a detail screen.
class RowChevron extends StatelessWidget {
  const RowChevron({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.chevron_right_rounded,
      color: AppColors.textMuted,
      size: 22,
    );
  }
}
