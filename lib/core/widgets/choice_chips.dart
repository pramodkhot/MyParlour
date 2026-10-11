import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// One option in a [ChoiceChips] group.
class ChoiceOption<T> {
  const ChoiceOption(this.value, this.label, {this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// Single-select pill chips. Scrolls horizontally when [scrollable],
/// otherwise wraps onto new lines.
class ChoiceChips<T> extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.scrollable = false,
  });

  final List<ChoiceOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final option in options)
        _Chip(
          label: option.label,
          icon: option.icon,
          isSelected: option.value == selected,
          onTap: () => onSelected(option.value),
        ),
    ];

    if (!scrollable) {
      return Wrap(spacing: Space.sm, runSpacing: Space.sm, children: chips);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) Gap.w8,
            chips[i],
          ],
        ],
      ),
    );
  }
}

/// Multi-select pill chips (e.g. working days), wrapping onto new lines.
class MultiChoiceChips<T> extends StatelessWidget {
  const MultiChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<ChoiceOption<T>> options;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: [
        for (final option in options)
          _Chip(
            label: option.label,
            icon: option.icon,
            isSelected: selected.contains(option.value),
            onTap: () {
              final next = {...selected};
              if (!next.remove(option.value)) next.add(option.value);
              onChanged(next);
            },
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? AppColors.primary : AppColors.textMuted;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? AppColors.chipSelected : AppColors.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: fg),
                    Gap.w4,
                  ],
                  // Flexible lets long labels wrap instead of overflowing
                  // narrow spaces such as dialogs.
                  Flexible(
                    child: Text(label, style: AppText.chip.copyWith(color: fg)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
