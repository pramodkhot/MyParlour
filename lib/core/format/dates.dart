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
