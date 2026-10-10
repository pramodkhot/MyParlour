import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';

/// Burgundy header with a rounded bottom edge. Pads for the status bar.
///
/// [bottomPadding] leaves room for cards that overlap the band.
class HeaderBand extends StatelessWidget {
  const HeaderBand({
    super.key,
    required this.child,
    this.bottomPadding = Space.xxl,
  });

  final Widget child;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Space.xl,
        top + Space.md,
        Space.xl,
        bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(Radii.header),
        ),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: IconTheme.merge(
          data: const IconThemeData(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}
