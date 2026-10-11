import '../../domain/errors.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/date_range.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/appointment_rules.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalAppointmentRepository implements AppointmentRepository {
  LocalAppointmentRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<Appointment>> listInRange(DateRange range) async => _sorted(
    _store.data.appointments.where((a) => range.contains(a.startsAt)),
  );

  @override
  Future<List<Appointment>> listForCustomer(String customerId) async => _sorted(
    _store.data.appointments.where((a) => a.customerId == customerId),
  ).reversed.toList();

  @override
  Future<Map<String, int>> completedVisitCounts() async {
    final counts = <String, int>{};
    for (final a in _store.data.appointments) {
      if (a.status == AppointmentStatus.completed && a.customerId != null) {
        counts[a.customerId!] = (counts[a.customerId!] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Future<Appointment?> getById(String id) async =>
      findById(_store.data.appointments, id, (a) => a.id);

  @override
  Future<Appointment> save(Appointment appointment) => _store.transact((data) {
    if (appointment.services.isEmpty) {
      throw const ValidationException(ErrorCode.appointmentNoServices);
    }
    if (appointment.customerId == null &&
        (appointment.walkInName?.trim().isEmpty ?? true)) {
      throw const ValidationException(ErrorCode.appointmentNoClient);
    }
    if (!appointment.endsAt.isAfter(appointment.startsAt)) {
      throw const ValidationException(ErrorCode.appointmentEndBeforeStart);
    }
    final existing = findById(data.appointments, appointment.id, (a) => a.id);
    if (existing != null && AppointmentRules.isFinal(existing.status)) {
      throw const InvalidStatusChangeException(ErrorCode.appointmentFinished);
    }
    final saved = appointment.copyWith(parlourId: data.parlour.id);
    upsertById(data.appointments, saved, (a) => a.id);
    return saved;
  });

  @override
  Future<Appointment> changeStatus(
    String id,
    AppointmentStatus to, {
    String? cancelReason,
  }) => _store.transact((data) {
    final appointment = findById(data.appointments, id, (a) => a.id);
    if (appointment == null) {
      throw const NotFoundException(ErrorCode.appointmentNotFound);
    }
    final updated = AppointmentRules.changeStatus(
      appointment,
      to,
      cancelReason: cancelReason,
    );
    upsertById(data.appointments, updated, (a) => a.id);

    if (to == AppointmentStatus.completed && updated.customerId != null) {
      final customer = findById(
        data.customers,
        updated.customerId!,
        (c) => c.id,
      );
      if (customer != null &&
          (customer.lastVisitAt == null ||
              customer.lastVisitAt!.isBefore(updated.startsAt))) {
        upsertById(
          data.customers,
          customer.copyWith(lastVisitAt: updated.startsAt),
          (c) => c.id,
        );
      }
    }
    return updated;
  });

  List<Appointment> _sorted(Iterable<Appointment> items) =>
      items.toList()..sort((a, b) => a.startsAt.compareTo(b.startsAt));
}
