import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';

/// Month label, previous/next week arrows and seven day pills. The
/// selected day is a burgundy pill; days with bookings get a dot.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.weekStart,
    required this.selected,
    required this.today,
    required this.daysWithBookings,
    required this.onSelect,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final DateTime weekStart;
  final DateTime selected;
  final DateTime today;
  final Set<DateTime> daysWithBookings;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context) {
    final days = [
      for (var i = 0; i < 7; i++)
        DateTime(weekStart.year, weekStart.month, weekStart.day + i),
    ];
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: Space.xs),
                child: Text(
                  DateFormat('MMMM y', 'en_IN').format(selected),
                  style: AppText.sectionTitle,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Previous week',
              onPressed: onPreviousWeek,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            IconButton(
              tooltip: 'Next week',
              onPressed: onNextWeek,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        Row(
          children: [
            for (final day in days)
              Expanded(
                child: _DayPill(
                  day: day,
                  isSelected: DateUtils.isSameDay(day, selected),
                  isToday: DateUtils.isSameDay(day, today),
                  hasBookings: daysWithBookings.contains(day),
                  onTap: () => onSelect(day),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.hasBookings,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool hasBookings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? Colors.white : AppColors.text;
    final label = DateFormat('EEEE d MMMM', 'en_IN').format(day);
    return Semantics(
      button: true,
      selected: isSelected,
      label: hasBookings ? '$label, has bookings' : label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: Space.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: isToday && !isSelected
                ? Border.all(color: AppColors.rose)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat.E('en_IN').format(day),
                style: AppText.caption.copyWith(
                  color: isSelected ? Colors.white : AppColors.textMuted,
                  fontSize: 11,
                ),
                textScaler: TextScaler.noScaling,
              ),
              const SizedBox(height: 2),
              Text(
                '${day.day}',
                style: AppText.bodyStrong.copyWith(color: fg),
                textScaler: TextScaler.noScaling,
              ),
              const SizedBox(height: 3),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasBookings
                      ? (isSelected ? Colors.white : AppColors.rose)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
