import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';

/// Burgundy header with a rounded bottom edge. Pads for the status bar.
///
/// Set [roundedBottom] to false when the band continues behind content
/// below it (see [HeaderBandOverlap]).
class HeaderBand extends StatelessWidget {
  const HeaderBand({
    super.key,
    required this.child,
    this.bottomPadding = Space.xxl,
    this.roundedBottom = true,
  });

  final Widget child;
  final double bottomPadding;
  final bool roundedBottom;

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
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: roundedBottom
            ? const BorderRadius.vertical(bottom: Radius.circular(Radii.header))
            : null,
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

/// Content that sits over the bottom of a [HeaderBand]: the band's last
/// [overlap] pixels (with its rounded corners) are painted behind [child].
///
/// Unlike shifting the content up with a transform, the content keeps its
/// real position, so every part of it can be tapped.
class HeaderBandOverlap extends StatelessWidget {
  const HeaderBandOverlap({
    super.key,
    required this.overlap,
    required this.child,
  });

  final double overlap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: overlap,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(Radii.header),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
