/// A wall-clock time such as opening hours (10:00). Stored as "HH:mm".
class ClockTime implements Comparable<ClockTime> {
  const ClockTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  factory ClockTime.parse(String value) {
    final parts = value.split(':');
    return ClockTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  factory ClockTime.fromMinutes(int minutes) =>
      ClockTime(minutes ~/ 60, minutes % 60);

  final int hour;
  final int minute;

  int get minutesOfDay => hour * 60 + minute;

  /// This time on the calendar day of [date], in local time.
  DateTime on(DateTime date) =>
      DateTime(date.year, date.month, date.day, hour, minute);

  String toJson() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(ClockTime other) => minutesOfDay - other.minutesOfDay;

  @override
  bool operator ==(Object other) =>
      other is ClockTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => toJson();
}

/// A yearly date without a year, used for birthdays and anniversaries.
class DayMonth {
  const DayMonth(this.day, this.month)
    : assert(month >= 1 && month <= 12),
      assert(day >= 1 && day <= 31);

  factory DayMonth.fromJson(Object? json) {
    final map = json! as Map<String, Object?>;
    return DayMonth(map['day']! as int, map['month']! as int);
  }

  final int day;
  final int month;

  bool matches(DateTime date) => date.day == day && date.month == month;

  Map<String, Object?> toJson() => {'day': day, 'month': month};

  @override
  bool operator ==(Object other) =>
      other is DayMonth && other.day == day && other.month == month;

  @override
  int get hashCode => Object.hash(day, month);
}
