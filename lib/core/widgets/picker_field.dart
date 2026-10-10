import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import 'field_label.dart';

/// A form field that opens a picker (date, day/month, time) instead of a
/// keyboard. Same look as `AppTextField`: label above, 52 high box.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
    this.icon,
    this.isRequired = false,
    this.onClear,
  });

  final String label;

  /// Shown in the box; [hint] is shown when null.
  final String? value;
  final String hint;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isRequired;

  /// Shows a clear button when set and a value is present.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: isRequired),

        Gap.h8,
        Material(
          color: AppColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: Radii.controlAll,
            side: BorderSide(color: AppColors.border),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const RoundedRectangleBorder(
              borderRadius: Radii.controlAll,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 52),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.md),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: AppColors.textMuted),
                      Gap.w12,
                    ],
                    Expanded(
                      child: Text(
                        value ?? hint,
                        style: AppText.body.copyWith(
                          color: value == null
                              ? AppColors.textMuted
                              : AppColors.text,
                        ),
                      ),
                    ),
                    if (value != null && onClear != null)
                      IconButton(
                        tooltip: 'Clear $label',
                        onPressed: onClear,
                        icon: const Icon(Icons.close_rounded, size: 20),
                      )
                    else
                      const Icon(
                        Icons.expand_more_rounded,
                        color: AppColors.textMuted,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
