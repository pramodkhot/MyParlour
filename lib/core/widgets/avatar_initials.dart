import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/typography.dart';

/// Pink circle with burgundy initials taken from a name.
class AvatarInitials extends StatelessWidget {
  const AvatarInitials({super.key, required this.name, this.size = 44});

  final String name;
  final double size;

  /// "Priya Sharma" → "PS", "Anita" → "AN", "" → "?".
  static String initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.chipSelected,
        shape: BoxShape.circle,
      ),
      child: Text(
        initialsOf(name),
        style: AppText.bodyStrong.copyWith(
          color: AppColors.primary,
          fontSize: size * 0.36,
          height: 1,
        ),
        textScaler: TextScaler.noScaling,
      ),
    );
  }
}
