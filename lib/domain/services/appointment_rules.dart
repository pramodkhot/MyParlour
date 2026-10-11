import '../errors.dart';
import '../models/appointment.dart';
import '../models/value_types.dart';

/// Appointment status flow, overlap checks and time slots (spec Section 6).
abstract final class AppointmentRules {
  static const _allowed = <AppointmentStatus, Set<AppointmentStatus>>{
    AppointmentStatus.booked: {
      AppointmentStatus.checkedIn,
      AppointmentStatus.cancelled,
      AppointmentStatus.noShow,
    },
    AppointmentStatus.checkedIn: {
      AppointmentStatus.completed,
      AppointmentStatus.cancelled,
    },
  };

  static bool canChange(AppointmentStatus from, AppointmentStatus to) =>
      _allowed[from]?.contains(to) ?? false;

  /// Completed, cancelled and no-show are final.
  static bool isFinal(AppointmentStatus status) =>
      !_allowed.containsKey(status);

  /// Statuses that occupy the stylist's time.
  static bool blocksTime(AppointmentStatus status) =>
      status == AppointmentStatus.booked ||
      status == AppointmentStatus.checkedIn ||
      status == AppointmentStatus.completed;

  /// Moves [appointment] to [to], or throws [InvalidStatusChangeException].
  static Appointment changeStatus(
    Appointment appointment,
    AppointmentStatus to, {
    String? cancelReason,
  }) {
    if (!canChange(appointment.status, to)) {
      throw InvalidStatusChangeException(ErrorCode.statusChange, {
        'from': appointment.status.name,
        'to': to.name,
      });
    }
    final reason = cancelReason?.trim();
    return appointment.copyWith(
      status: to,
      cancelReason:
          to == AppointmentStatus.cancelled &&
              reason != null &&
              reason.isNotEmpty
          ? reason
          : null,
    );
  }

  /// True when [aStart, aEnd) and [bStart, bEnd) share any time.
  static bool overlaps(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) => aStart.isBefore(bEnd) && bStart.isBefore(aEnd);

  /// The same stylist's bookings that clash with [start, end).
  /// Cancelled and no-show bookings never clash. [excludeId] skips the
  /// appointment being rescheduled.
  static List<Appointment> clashes({
    required String staffId,
    required DateTime start,
    required DateTime end,
    required Iterable<Appointment> existing,
    String? excludeId,
  }) {
    final result =
        existing
            .where(
              (a) =>
                  a.id != excludeId &&
                  a.staffId == staffId &&
                  blocksTime(a.status) &&
                  overlaps(start, end, a.startsAt, a.endsAt),
            )
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return result;
  }

  /// When the stylist is next free at or after [at]: null if free at [at],
  /// otherwise the end of the back-to-back bookings covering [at].
  static DateTime? busyUntil({
    required String staffId,
    required DateTime at,
    required Iterable<Appointment> existing,
  }) {
    final mine =
        existing
            .where((a) => a.staffId == staffId && blocksTime(a.status))
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    DateTime? until;
    var cursor = at;
    for (final a in mine) {
      if (!a.startsAt.isAfter(cursor) && a.endsAt.isAfter(cursor)) {
        until = a.endsAt;
        cursor = a.endsAt;
      }
    }
    return until;
  }

  /// Start times on [day] from [open] in steps of [slotMinutes], keeping
  /// only starts where a slot still fits before [close].
  static List<DateTime> slots({
    required DateTime day,
    required ClockTime open,
    required ClockTime close,
    required int slotMinutes,
  }) {
    final result = <DateTime>[];
    if (slotMinutes <= 0) return result;
    for (
      var m = open.minutesOfDay;
      m + slotMinutes <= close.minutesOfDay;
      m += slotMinutes
    ) {
      result.add(ClockTime.fromMinutes(m).on(day));
    }
    return result;
  }

  /// End time for services starting at [start].
  static DateTime endFor(DateTime start, List<AppointmentService> services) =>
      start.add(
        Duration(minutes: services.fold(0, (sum, s) => sum + s.durationMin)),
      );
}
