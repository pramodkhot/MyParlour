import 'package:flutter/material.dart';

import 'colors.dart';

/// Type styles (spec Section 8): Playfair Display for titles and the logo,
/// Manrope for everything else.
abstract final class AppText {
  static const serif = 'PlayfairDisplay';
  static const sans = 'Manrope';

  static const logo = TextStyle(
    fontFamily: serif,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
    height: 1.15,
  );

  static const screenTitle = TextStyle(
    fontFamily: serif,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    height: 1.2,
  );

  static const greeting = TextStyle(
    fontFamily: serif,
    fontSize: 25,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );

  static const barTitle = TextStyle(
    fontFamily: serif,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const sectionTitle = TextStyle(
    fontFamily: sans,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    height: 1.4,
  );

  static const bodyStrong = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    height: 1.4,
  );

  static const label = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );

  static const caption = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const chip = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const bigNumber = TextStyle(
    fontFamily: sans,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const button = TextStyle(
    fontFamily: sans,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const link = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}
