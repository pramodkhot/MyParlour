import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/value_types.dart';
import '../design/spacing.dart';

/// "14 May" for a birthday or anniversary.
String formatDayMonth(DayMonth value) => DateFormat(
  'd MMMM',
  'en_IN',
).format(DateTime(2000, value.month, value.day));

/// Picks a day and month without a year (birthdays, anniversaries).
Future<DayMonth?> showDayMonthPicker(
  BuildContext context, {
  required String title,
  DayMonth? initial,
}) {
  return showDialog<DayMonth>(
    context: context,
    builder: (context) => _DayMonthDialog(title: title, initial: initial),
  );
}

class _DayMonthDialog extends StatefulWidget {
  const _DayMonthDialog({required this.title, this.initial});

  final String title;
  final DayMonth? initial;

  @override
  State<_DayMonthDialog> createState() => _DayMonthDialogState();
}

class _DayMonthDialogState extends State<_DayMonthDialog> {
  late int _day = widget.initial?.day ?? 1;
  late int _month = widget.initial?.month ?? DateTime.now().month;

  // 2000 is a leap year, so 29 February is allowed.
  int get _daysInMonth => DateTime(2000, _month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    final months = DateFormat.MMMM('en_IN');
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        children: [
          SizedBox(
            width: 84,
            child: DropdownButtonFormField<int>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Day'),
              items: [
                for (var d = 1; d <= _daysInMonth; d++)
                  DropdownMenuItem(value: d, child: Text('$d')),
              ],
              onChanged: (v) => setState(() => _day = v ?? _day),
            ),
          ),
          Gap.w12,
          Expanded(
            child: DropdownButtonFormField<int>(
              initialValue: _month,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Month'),
              items: [
                for (var m = 1; m <= 12; m++)
                  DropdownMenuItem(
                    value: m,
                    child: Text(months.format(DateTime(2000, m))),
                  ),
              ],
              onChanged: (v) => setState(() {
                _month = v ?? _month;
                if (_day > _daysInMonth) _day = _daysInMonth;
              }),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(DayMonth(_day, _month)),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
