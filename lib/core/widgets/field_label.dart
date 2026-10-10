import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/typography.dart';

/// Form label: required fields get " *", optional ones "(optional)"
/// (form rules, spec Section 9).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.primary),
            )
          else
            TextSpan(
              text: '  (optional)',
              style: AppText.caption.copyWith(fontWeight: FontWeight.w500),
            ),
        ],
      ),
      style: AppText.label.copyWith(color: AppColors.text),
    );
  }
}
