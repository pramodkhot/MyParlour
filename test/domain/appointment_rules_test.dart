import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/errors.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/value_types.dart';
import 'package:myparlour/domain/services/appointment_rules.dart';

import '../helpers/test_data.dart';

void main() {
  group('status flow', () {
    const s = AppointmentStatus.values;
    const allowed = {
      (AppointmentStatus.booked, AppointmentStatus.checkedIn),
      (AppointmentStatus.booked, AppointmentStatus.cancelled),
      (AppointmentStatus.booked, AppointmentStatus.noShow),
      (AppointmentStatus.checkedIn, AppointmentStatus.completed),
      (AppointmentStatus.checkedIn, AppointmentStatus.cancelled),
    };

    test('exactly the spec transitions are allowed', () {
      for (final from in s) {
        for (final to in s) {
          expect(
            AppointmentRules.canChange(from, to),
            allowed.contains((from, to)),
            reason: '$from → $to',
          );
        }
      }
    });

    test('completed, cancelled and no-show are final', () {
      expect(AppointmentRules.isFinal(AppointmentStatus.completed), isTrue);
      expect(AppointmentRules.isFinal(AppointmentStatus.cancelled), isTrue);
      expect(AppointmentRules.isFinal(AppointmentStatus.noShow), isTrue);
      expect(AppointmentRules.isFinal(AppointmentStatus.booked), isFalse);
      expect(AppointmentRules.isFinal(AppointmentStatus.checkedIn), isFalse);
    });

    test('book → check in → complete', () {
      var a = testAppointment();
      a = AppointmentRules.changeStatus(a, AppointmentStatus.checkedIn);
      a = AppointmentRules.changeStatus(a, AppointmentStatus.completed);
      expect(a.status, AppointmentStatus.completed);
    });

    test('a disallowed change throws with a plain message', () {
      final a = testAppointment(status: AppointmentStatus.completed);
      expect(
        () => AppointmentRules.changeStatus(a, AppointmentStatus.booked),
        throwsA(isA<InvalidStatusChangeException>()),
      );
      final b = testAppointment();
      expect(
        () => AppointmentRules.changeStatus(b, AppointmentStatus.completed),
        throwsA(isA<InvalidStatusChangeException>()),
      );
    });

    test('cancel keeps the reason', () {
      final a = AppointmentRules.changeStatus(
        testAppointment(),
        AppointmentStatus.cancelled,
        cancelReason: '  Customer unwell ',
      );
      expect(a.cancelReason, 'Customer unwell');
    });
  });

  group('overlap', () {
    DateTime t(int h, [int m = 0]) => DateTime(2026, 5, 14, h, m);

    test('touching bookings do not overlap', () {
      expect(AppointmentRules.overlaps(t(10), t(11), t(11), t(12)), isFalse);
      expect(AppointmentRules.overlaps(t(10), t(11), t(10, 59), t(12)), isTrue);
      expect(AppointmentRules.overlaps(t(10), t(12), t(10, 30), t(11)), isTrue);
    });

    test(
      'clashes finds the same stylist only, ignoring cancelled and no-show',
      () {
        final existing = [
          testAppointment(id: 'same', start: t(10), minutes: 60),
          testAppointment(
            id: 'other-staff',
            staffId: 'staff-riya',
            start: t(10),
            minutes: 60,
          ),
          testAppointment(
            id: 'cancelled',
            start: t(10),
            minutes: 60,
            status: AppointmentStatus.cancelled,
          ),
          testAppointment(
            id: 'noshow',
            start: t(10),
            minutes: 60,
            status: AppointmentStatus.noShow,
          ),
          testAppointment(id: 'later', start: t(11), minutes: 30),
        ];
        final clashes = AppointmentRules.clashes(
          staffId: 'staff-anita',
          start: t(10, 30),
          end: t(11, 30),
          existing: existing,
        );
        expect(clashes.map((a) => a.id), ['same', 'later']);
      },
    );

    test('rescheduling ignores the appointment itself', () {
      final existing = [testAppointment(id: 'me', start: t(10), minutes: 60)];
      expect(
        AppointmentRules.clashes(
          staffId: 'staff-anita',
          start: t(10, 30),
          end: t(11, 30),
          existing: existing,
          excludeId: 'me',
        ),
        isEmpty,
      );
    });

    test('busyUntil follows back-to-back bookings', () {
      final existing = [
        testAppointment(id: 'a', start: t(10), minutes: 60),
        testAppointment(id: 'b', start: t(11), minutes: 30),
        testAppointment(id: 'c', start: t(13), minutes: 30),
      ];
      expect(
        AppointmentRules.busyUntil(
          staffId: 'staff-anita',
          at: t(10, 15),
          existing: existing,
        ),
        t(11, 30),
      );
      expect(
        AppointmentRules.busyUntil(
          staffId: 'staff-anita',
          at: t(12),
          existing: existing,
        ),
        isNull,
      );
    });
  });

  group('slots', () {
    test('30-minute slots from 10:00 to 20:00', () {
      final slots = AppointmentRules.slots(
        day: DateTime(2026, 5, 14),
        open: const ClockTime(10, 0),
        close: const ClockTime(20, 0),
        slotMinutes: 30,
      );
      expect(slots.length, 20);
      expect(slots.first, DateTime(2026, 5, 14, 10));
      expect(slots.last, DateTime(2026, 5, 14, 19, 30));
    });

    test('a slot must fit before closing', () {
      final slots = AppointmentRules.slots(
        day: DateTime(2026, 5, 14),
        open: const ClockTime(10, 0),
        close: const ClockTime(11, 0),
        slotMinutes: 45,
      );
      expect(slots, [DateTime(2026, 5, 14, 10)]);
    });

    test('end time adds up the service durations', () {
      final a = testAppointment(minutes: 90);
      expect(
        AppointmentRules.endFor(a.startsAt, a.services),
        a.startsAt.add(const Duration(minutes: 90)),
      );
    });
  });
}
