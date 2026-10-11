import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/app/routes.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/features/appointments/appointments_controller.dart';

import '../helpers/test_data.dart';

void main() {
  test('week starts on Monday', () {
    expect(weekStartOf(DateTime(2026, 5, 14, 16)), DateTime(2026, 5, 11));
    expect(weekStartOf(DateTime(2026, 5, 17)), DateTime(2026, 5, 11));
    expect(weekStartOf(DateTime(2026, 5, 11)), DateTime(2026, 5, 11));
    expect(weekStartOf(DateTime(2026, 3, 1)), DateTime(2026, 2, 23));
  });

  test('day list, stylist filter and status counts', () {
    final all = [
      testAppointment(id: 'late', start: DateTime(2026, 5, 14, 15)),
      testAppointment(
        id: 'early',
        start: DateTime(2026, 5, 14, 10),
        status: AppointmentStatus.completed,
      ),
      testAppointment(
        id: 'riya',
        staffId: 'staff-riya',
        start: DateTime(2026, 5, 14, 11),
        status: AppointmentStatus.cancelled,
      ),
      testAppointment(id: 'tomorrow', start: DateTime(2026, 5, 15, 10)),
    ];
    final day = appointmentsOnDay(all, DateTime(2026, 5, 14));
    expect(day.map((a) => a.id), ['early', 'riya', 'late']);
    expect(
      appointmentsOnDay(
        all,
        DateTime(2026, 5, 14),
        staffId: 'staff-anita',
      ).map((a) => a.id),
      ['early', 'late'],
    );
    final counts = filterCounts(day);
    expect(counts[AppointmentFilter.all], 3);
    expect(counts[AppointmentFilter.upcoming], 1);
    expect(counts[AppointmentFilter.completed], 1);
    expect(counts[AppointmentFilter.cancelled], 1);
    expect(counts[AppointmentFilter.noShow], 0);
  });

  test('new appointment links carry customer and date', () {
    expect(Routes.newAppointment(), '/appointments/new');
    expect(
      Routes.newAppointment(customerId: 'c1', date: DateTime(2026, 5, 4)),
      '/appointments/new?customerId=c1&date=2026-05-04',
    );
  });
}
