import 'package:flutter/widgets.dart';

/// Spacing scale and corner radii (spec Section 8).
abstract final class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Horizontal padding for screen content.
  static const double screen = 16;

  /// Minimum tap target.
  static const double tapTarget = 48;
}

abstract final class Radii {
  static const double card = 18;
  static const double control = 14;
  static const double sheet = 24;
  static const double header = 28;

  static const cardAll = BorderRadius.all(Radius.circular(card));
  static const controlAll = BorderRadius.all(Radius.circular(control));
  static const sheetTop = BorderRadius.vertical(top: Radius.circular(sheet));
}

/// Vertical and horizontal gaps.
abstract final class Gap {
  static const h4 = SizedBox(height: Space.xs);
  static const h8 = SizedBox(height: Space.sm);
  static const h12 = SizedBox(height: Space.md);
  static const h16 = SizedBox(height: Space.lg);
  static const h20 = SizedBox(height: Space.xl);
  static const h24 = SizedBox(height: Space.xxl);
  static const h32 = SizedBox(height: Space.xxxl);

  static const w4 = SizedBox(width: Space.xs);
  static const w8 = SizedBox(width: Space.sm);
  static const w12 = SizedBox(width: Space.md);
  static const w16 = SizedBox(width: Space.lg);
}
