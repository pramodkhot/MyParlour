import '../models/appointment.dart';
import '../models/staff.dart';
import 'appointment_rules.dart';

/// Whether a stylist can take a booking for a given time.
class StylistAvailability {
  const StylistAvailability.free() : busyUntil = null, busyFrom = null;

  const StylistAvailability.busyUntil(DateTime this.busyUntil)
    : busyFrom = null;

  const StylistAvailability.busyFrom(DateTime this.busyFrom) : busyUntil = null;

  /// Already busy at the start time, until this time.
  final DateTime? busyUntil;

  /// Free at the start, but another booking begins before this one ends.
  final DateTime? busyFrom;

  bool get isFree => busyUntil == null && busyFrom == null;
}

/// Helps the New appointment form choose a stylist and a time.
abstract final class BookingPlanner {
  /// Active stylists working on [day]'s weekday who do every chosen
  /// service. If nobody does all of them, every active stylist working that
  /// day is offered instead (the owner decides).
  static List<Staff> eligibleStaff({
    required Iterable<Staff> staff,
    required Set<String> serviceIds,
    required DateTime day,
  }) {
    final working = staff
        .where((s) => s.isActive && s.workingDays.contains(day.weekday))
        .toList();
    final capable = working
        .where((s) => serviceIds.every(s.doesService))
        .toList();
    return capable.isNotEmpty ? capable : working;
  }

  static StylistAvailability availability({
    required String staffId,
    required DateTime start,
    required DateTime end,
    required Iterable<Appointment> appointments,
    String? excludeId,
  }) {
    final others = appointments.where((a) => a.id != excludeId);
    final clashes = AppointmentRules.clashes(
      staffId: staffId,
      start: start,
      end: end,
      existing: others,
    );
    if (clashes.isEmpty) return const StylistAvailability.free();
    final until = AppointmentRules.busyUntil(
      staffId: staffId,
      at: start,
      existing: others,
    );
    if (until != null) return StylistAvailability.busyUntil(until);
    return StylistAvailability.busyFrom(clashes.first.startsAt);
  }

  /// The first slot at or after [notBefore] where at least one of
  /// [candidates] is free for [durationMin] minutes. Null when none is.
  static DateTime? nextFreeSlot({
    required List<DateTime> slots,
    required DateTime notBefore,
    required int durationMin,
    required Iterable<Staff> candidates,
    required Iterable<Appointment> appointments,
    String? excludeId,
  }) {
    for (final slot in slots) {
      if (slot.isBefore(notBefore)) continue;
      final end = slot.add(Duration(minutes: durationMin));
      for (final s in candidates) {
        final a = availability(
          staffId: s.id,
          start: slot,
          end: end,
          appointments: appointments,
          excludeId: excludeId,
        );
        if (a.isFree) return slot;
      }
    }
    return null;
  }

  /// The first of [candidates] free for [start, end), or null.
  static Staff? firstFreeStylist({
    required Iterable<Staff> candidates,
    required DateTime start,
    required DateTime end,
    required Iterable<Appointment> appointments,
    String? excludeId,
  }) {
    for (final s in candidates) {
      if (availability(
        staffId: s.id,
        start: start,
        end: end,
        appointments: appointments,
        excludeId: excludeId,
      ).isFree) {
        return s;
      }
    }
    return null;
  }
}
