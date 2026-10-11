import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/staff.dart';
import 'package:myparlour/domain/models/value_types.dart';
import 'package:myparlour/domain/services/appointment_rules.dart';
import 'package:myparlour/domain/services/booking_planner.dart';

import '../helpers/test_data.dart';

Staff stylist(
  String id, {
  List<String> services = const ['svc-haircut'],
  List<int> days = const [1, 2, 3, 4, 5, 6],
  bool active = true,
}) => Staff(
  id: id,
  parlourId: 'p',
  name: id,
  phone: '9000000000',
  roleTitle: 'Beautician',
  serviceIds: services,
  workingDays: days,
  startTime: const ClockTime(10, 0),
  endTime: const ClockTime(20, 0),
  isActive: active,
);

void main() {
  final thursday = DateTime(2026, 5, 14);
  DateTime t(int h, [int m = 0]) => DateTime(2026, 5, 14, h, m);

  group('eligible staff', () {
    final staff = [
      stylist('anita', services: ['svc-haircut', 'svc-smooth']),
      stylist('riya'),
      stylist('pooja', services: ['svc-haircut', 'svc-smooth'], active: false),
      stylist('meena', services: ['svc-haircut', 'svc-smooth'], days: [7]),
    ];

    test('active, working that day, doing every chosen service', () {
      expect(
        BookingPlanner.eligibleStaff(
          staff: staff,
          serviceIds: {'svc-haircut', 'svc-smooth'},
          day: thursday,
        ).map((s) => s.id),
        ['anita'],
      );
    });

    test('falls back to everyone working when nobody does all services', () {
      expect(
        BookingPlanner.eligibleStaff(
          staff: staff,
          serviceIds: {'svc-nails'},
          day: thursday,
        ).map((s) => s.id),
        ['anita', 'riya'],
      );
    });
  });

  group('availability', () {
    final booked = [
      testAppointment(id: 'a', start: t(10), minutes: 60),
      testAppointment(id: 'b', start: t(11), minutes: 30),
      testAppointment(id: 'c', start: t(14), minutes: 30),
      testAppointment(
        id: 'x',
        start: t(15),
        minutes: 60,
        status: AppointmentStatus.cancelled,
      ),
    ];

    StylistAvailability at(DateTime start, int minutes, {String? exclude}) =>
        BookingPlanner.availability(
          staffId: 'staff-anita',
          start: start,
          end: start.add(Duration(minutes: minutes)),
          appointments: booked,
          excludeId: exclude,
        );

    test('free when nothing overlaps (cancelled ignored)', () {
      expect(at(t(12), 60).isFree, isTrue);
      expect(at(t(15), 60).isFree, isTrue);
    });

    test('busy until the end of back-to-back bookings', () {
      expect(at(t(10, 30), 30).busyUntil, t(11, 30));
    });

    test('busy from when a later booking starts inside the slot', () {
      expect(at(t(13, 30), 60).busyFrom, t(14));
    });

    test('rescheduling ignores the appointment itself', () {
      expect(at(t(14), 30, exclude: 'c').isFree, isTrue);
    });

    test('next free slot skips past and busy times', () {
      final slots = AppointmentRules.slots(
        day: thursday,
        open: const ClockTime(10, 0),
        close: const ClockTime(20, 0),
        slotMinutes: 30,
      );
      final next = BookingPlanner.nextFreeSlot(
        slots: slots,
        notBefore: t(10, 15),
        durationMin: 60,
        candidates: [stylist('staff-anita')],
        appointments: booked,
      );
      expect(next, t(11, 30));
    });

    test('first free stylist', () {
      final free = BookingPlanner.firstFreeStylist(
        candidates: [stylist('staff-anita'), stylist('staff-riya')],
        start: t(10),
        end: t(11),
        appointments: booked,
      );
      expect(free?.id, 'staff-riya');
    });
  });
}
