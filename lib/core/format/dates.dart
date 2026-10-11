import 'package:intl/intl.dart';

/// Time-of-day greeting for the dashboard header (English; screens use the
/// translated greeting via [Greeting.partOfDay]).
abstract final class Greeting {
  /// Morning before 12:00, afternoon before 17:00, evening after.
  static String forTime(DateTime time, {String? name}) {
    final suffix = (name == null || name.trim().isEmpty)
        ? ''
        : ', ${name.trim()}';
    return 'Good ${partOfDay(time).name}$suffix';
  }

  static DayPart partOfDay(DateTime time) => time.hour < 12
      ? DayPart.morning
      : time.hour < 17
      ? DayPart.afternoon
      : DayPart.evening;
}

enum DayPart { morning, afternoon, evening }

/// Date and time text, in the app's current language (`Intl.defaultLocale`,
/// set by the language setting) and always with 0–9 digits.
abstract final class Dates {
  /// "Tuesday, 14 May"
  static String weekdayDayMonth(DateTime value) =>
      DateFormat('EEEE, d MMMM').format(value.toLocal());

  /// "Thursday, 14 May 2026"
  static String weekdayDayMonthYear(DateTime value) =>
      DateFormat('EEEE, d MMMM y').format(value.toLocal());

  /// "14 May 2026, Thursday"
  static String dayMonthYearWeekday(DateTime value) =>
      DateFormat('d MMMM y, EEEE').format(value.toLocal());

  /// "14 May 2026"
  static String dayMonthYear(DateTime value) =>
      DateFormat('d MMM y').format(value.toLocal());

  /// "12 May"
  static String dayMonth(DateTime value) =>
      DateFormat('d MMM').format(value.toLocal());

  /// "May 2026"
  static String monthYear(DateTime value) =>
      DateFormat('MMMM y').format(value.toLocal());

  /// "14 May" with the full month name.
  static String dayFullMonth(DateTime value) =>
      DateFormat('d MMMM').format(value.toLocal());

  /// "Mon"
  static String weekdayShort(DateTime value) =>
      DateFormat.E().format(value.toLocal());

  /// "Monday"
  static String weekday(DateTime value) =>
      DateFormat.EEEE().format(value.toLocal());

  /// "May" (full month name only).
  static String monthName(DateTime value) =>
      DateFormat.MMMM().format(value.toLocal());

  /// "10:30" (12-hour clock, no AM/PM; pair with [amPm]).
  static String clock(DateTime value) =>
      DateFormat('h:mm').format(value.toLocal());

  /// "AM" or "PM" — in every language, as on Indian phones and receipts
  /// (Marathi's own marker would otherwise print as a bare "a"/"p").
  static String amPm(DateTime value) => value.toLocal().hour < 12 ? 'AM' : 'PM';

  /// "10:30 AM"
  static String time(DateTime value) => '${clock(value)} ${amPm(value)}';

  /// "14 May, 4:12 PM"
  static String dayMonthTime(DateTime value) =>
      '${dayMonth(value)}, ${time(value)}';

  /// 30 → "30 min", 60 → "1 h", 90 → "1 h 30". English only; screens use
  /// `context.l10n.duration`.
  static String duration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h h' : '$h h ${m.toString().padLeft(2, '0')}';
  }
}
