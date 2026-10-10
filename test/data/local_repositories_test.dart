import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/local/local_appointment_repository.dart';
import 'package:myparlour/data/local/local_customer_repository.dart';
import 'package:myparlour/data/local/local_demo_data_repository.dart';
import 'package:myparlour/data/local/local_expense_repository.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/domain/errors.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/customer.dart';
import 'package:myparlour/domain/models/date_range.dart';
import 'package:myparlour/domain/models/expense.dart';

import '../helpers/test_data.dart';

void main() {
  late LocalStore store;

  setUp(() async => store = await openTestStore());
  tearDown(() => deleteTestStore(store));

  group('customers', () {
    test('save, deactivate, duplicate warning', () async {
      final repo = LocalCustomerRepository(store);
      await repo.save(
        Customer(
          id: 'c2',
          parlourId: 'wrong',
          name: '  Neha Verma ',
          phone: '91234 56789',
          createdAt: testNow,
        ),
      );
      final neha = await repo.getById('c2');
      expect(neha!.name, 'Neha Verma');
      expect(neha.parlourId, 'parlour-1');

      expect(
        (await repo.findDuplicate('+91 98765 43210'))?.name,
        'Priya Sharma',
      );
      expect(
        await repo.findDuplicate('9876543210', excludeId: priya.id),
        isNull,
      );

      await repo.setActive('c2', isActive: false);
      expect((await repo.list()).map((c) => c.id), [priya.id]);
      expect(await repo.list(includeInactive: true), hasLength(2));
    });
  });

  group('appointments', () {
    test('book → check in → complete updates last visit', () async {
      final repo = LocalAppointmentRepository(store);
      final start = DateTime(2026, 5, 15, 11);
      await repo.save(testAppointment(id: 'new', start: start));
      await repo.changeStatus('new', AppointmentStatus.checkedIn);
      final done = await repo.changeStatus('new', AppointmentStatus.completed);
      expect(done.status, AppointmentStatus.completed);
      expect(store.data.customers.single.lastVisitAt, start);
    });

    test('cancelled stays in history and cannot be edited', () async {
      final repo = LocalAppointmentRepository(store);
      await repo.save(
        testAppointment(id: 'x', start: DateTime(2026, 5, 16, 10)),
      );
      await repo.changeStatus(
        'x',
        AppointmentStatus.cancelled,
        cancelReason: 'Unwell',
      );
      final history = await repo.listForCustomer(priya.id);
      expect(history.map((a) => a.id), contains('x'));
      expect(
        () => repo.save(testAppointment(id: 'x')),
        throwsA(isA<InvalidStatusChangeException>()),
      );
      expect(
        () => repo.changeStatus('x', AppointmentStatus.checkedIn),
        throwsA(isA<InvalidStatusChangeException>()),
      );
    });

    test('lists by date range', () async {
      final repo = LocalAppointmentRepository(store);
      final day = await repo.listInRange(DateRange.day(DateTime(2026, 5, 14)));
      expect(day.map((a) => a.id), ['appt-1']);
    });
  });

  group('expenses', () {
    test('amount must be more than 0', () async {
      final repo = LocalExpenseRepository(store);
      expect(
        () => repo.save(
          Expense(
            id: 'e',
            parlourId: 'p',
            category: 'Rent',
            amountPaise: 0,
            spentOn: DateTime(2026, 5, 1),
          ),
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('demo data', () {
    test('start empty keeps the parlour; reset restores the seed', () async {
      final repo = LocalDemoDataRepository(store);
      await repo.startEmpty();
      expect(store.data.customers, isEmpty);
      expect(store.data.parlour.name, 'Test Parlour');

      await repo.resetDemo();
      expect(store.data.customers, hasLength(1));
    });
  });
}
