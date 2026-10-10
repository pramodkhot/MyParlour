import 'package:intl/intl.dart';

/// Time-of-day greeting for the dashboard header.
abstract final class Greeting {
  /// Morning before 12:00, afternoon before 17:00, evening after.
  static String forTime(DateTime time, {String? name}) {
    final part = time.hour < 12
        ? 'morning'
        : time.hour < 17
        ? 'afternoon'
        : 'evening';
    final suffix = (name == null || name.trim().isEmpty)
        ? ''
        : ', ${name.trim()}';
    return 'Good $part$suffix';
  }
}

/// Date and time text used across the app (shown in local time).
abstract final class Dates {
  /// "Tuesday, 14 May"
  static String weekdayDayMonth(DateTime value) =>
      DateFormat('EEEE, d MMMM', 'en_IN').format(value.toLocal());

  /// "14 May 2026"
  static String dayMonthYear(DateTime value) =>
      DateFormat('d MMM y', 'en_IN').format(value.toLocal());

  /// "12 May"
  static String dayMonth(DateTime value) =>
      DateFormat('d MMM', 'en_IN').format(value.toLocal());

  /// "10:30" (12-hour clock, no AM/PM; pair with [amPm]).
  static String clock(DateTime value) =>
      DateFormat('h:mm', 'en_IN').format(value.toLocal());

  /// "AM" or "PM".
  static String amPm(DateTime value) => value.toLocal().hour < 12 ? 'AM' : 'PM';

  /// "10:30 AM"
  static String time(DateTime value) => '${clock(value)} ${amPm(value)}';

  /// "14 May, 4:12 PM"
  static String dayMonthTime(DateTime value) =>
      '${dayMonth(value)}, ${time(value)}';

  /// 30 → "30 min", 60 → "1 h", 90 → "1 h 30".
  static String duration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h h' : '$h h ${m.toString().padLeft(2, '0')}';
  }
}
