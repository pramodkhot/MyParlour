import 'package:flutter/material.dart';

/// Colour tokens from the MyParlour design system (spec Section 8).
abstract final class AppColors {
  static const primary = Color(0xFFA92750);
  static const primaryDark = Color(0xFF79142F);
  static const rose = Color(0xFFD75D85);

  static const blush = Color(0xFFFFF6F7);
  static const blushDeep = Color(0xFFFBE3EA);
  static const chipSelected = Color(0xFFFCE8EE);

  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF282126);
  static const textMuted = Color(0xFF6F6268);
  static const border = Color(0xFFF0E1E5);
  static const divider = Color(0xFFF6ECEF);

  static const success = Color(0xFF1F7550);
  static const successBg = Color(0xFFE3F3EB);
  static const warning = Color(0xFF8A5414);
  static const warningBg = Color(0xFFFDF1E1);
  static const error = Color(0xFFB3263A);
  static const errorBg = Color(0xFFFBE6E8);
  static const info = Color(0xFF8E1F43);
  static const infoBg = Color(0xFFFCE8EE);
  static const neutral = Color(0xFF6F6268);
  static const neutralBg = Color(0xFFF1EDEE);

  /// Card shadow: rgba(121, 20, 47, 0.08), blur 22, y 8.
  static const cardShadow = BoxShadow(
    color: Color(0x1479142F),
    blurRadius: 22,
    offset: Offset(0, 8),
  );
}
