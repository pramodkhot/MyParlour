import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';

/// White rounded card with the design-system border and soft shadow.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Space.lg),
    this.color = AppColors.surface,
    this.showShadow = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: Radii.cardAll,
        boxShadow: showShadow ? const [AppColors.cardShadow] : null,
      ),
      child: Material(
        color: color,
        shape: const RoundedRectangleBorder(
          borderRadius: Radii.cardAll,
          side: BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
