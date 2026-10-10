/// A half-open time range [start, end) in local time.
class DateRange {
  DateRange(this.start, this.end)
    : assert(!end.isBefore(start), 'end must not be before start');

  /// Whole calendar days from [firstDay] to [lastDay], both included.
  factory DateRange.days(DateTime firstDay, DateTime lastDay) {
    final last = startOfDay(lastDay);
    return DateRange(
      startOfDay(firstDay),
      DateTime(last.year, last.month, last.day + 1),
    );
  }

  /// The calendar day containing [moment].
  factory DateRange.day(DateTime moment) => DateRange.days(moment, moment);

  final DateTime start;
  final DateTime end;

  bool contains(DateTime moment) {
    final local = moment.toLocal();
    return !local.isBefore(start) && local.isBefore(end);
  }

  /// Local midnight at the start of each day in the range.
  List<DateTime> get days {
    final result = <DateTime>[];
    var day = startOfDay(start);
    while (day.isBefore(end)) {
      result.add(day);
      day = DateTime(day.year, day.month, day.day + 1);
    }
    return result;
  }

  static DateTime startOfDay(DateTime moment) {
    final local = moment.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  @override
  bool operator ==(Object other) =>
      other is DateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DateRange($start – $end)';
}
