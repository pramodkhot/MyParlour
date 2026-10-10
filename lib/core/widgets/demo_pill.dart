import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/typography.dart';

/// Small "Demo" pill shown on the Welcome and Settings screens only.
class DemoPill extends StatelessWidget {
  const DemoPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: const ShapeDecoration(
        color: AppColors.chipSelected,
        shape: StadiumBorder(
          side: BorderSide(color: AppColors.rose, width: 0.8),
        ),
      ),
      child: Text(
        'Demo',
        style: AppText.chip.copyWith(color: AppColors.info, fontSize: 11),
      ),
    );
  }
}
