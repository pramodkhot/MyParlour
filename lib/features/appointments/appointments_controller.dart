import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../data/providers.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/parlour.dart';
import '../../domain/models/service_item.dart';
import '../../domain/models/staff.dart';

/// Status chips on the Appointments screen.
enum AppointmentFilter {
  all(null),
  upcoming(AppointmentStatus.booked),
  checkedIn(AppointmentStatus.checkedIn),
  completed(AppointmentStatus.completed),
  cancelled(AppointmentStatus.cancelled),
  noShow(AppointmentStatus.noShow);

  const AppointmentFilter(this.status);

  final AppointmentStatus? status;

  bool matches(Appointment a) => status == null || a.status == status;

  /// Chip text in the current language.
  String label(AppLocalizations l10n) {
    final s = status;
    return s == null ? l10n.apptFilterAll : l10n.appointmentStatus(s);
  }

  /// Empty-list message when nothing on the day matches this filter.
  String emptyMessage(AppLocalizations l10n) => switch (this) {
    AppointmentFilter.all => l10n.apptNoneOnDay,
    AppointmentFilter.upcoming => l10n.apptNoneUpcomingOnDay,
    AppointmentFilter.checkedIn => l10n.apptNoneCheckedInOnDay,
    AppointmentFilter.completed => l10n.apptNoneCompletedOnDay,
    AppointmentFilter.cancelled => l10n.apptNoneCancelledOnDay,
    AppointmentFilter.noShow => l10n.apptNoneNoShowOnDay,
  };
}

/// Monday of the week containing [day] (local midnight).
DateTime weekStartOf(DateTime day) {
  final d = DateRange.startOfDay(day);
  return DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday));
}

/// Appointments on [day] for [staffId] (null = everyone), earliest first.
List<Appointment> appointmentsOnDay(
  Iterable<Appointment> all,
  DateTime day, {
  String? staffId,
}) {
  final range = DateRange.day(day);
  return all
      .where(
        (a) =>
            range.contains(a.startsAt) &&
            (staffId == null || a.staffId == staffId),
      )
      .toList()
    ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
}

/// How many of [dayList] fall under each filter chip.
Map<AppointmentFilter, int> filterCounts(List<Appointment> dayList) => {
  for (final f in AppointmentFilter.values) f: dayList.where(f.matches).length,
};

/// Names for showing appointments (inactive people included, so history
/// still reads correctly).
class PeopleNames {
  const PeopleNames({required this.customers, required this.staff});

  final Map<String, Customer> customers;
  final Map<String, Staff> staff;

  String client(Appointment a, AppLocalizations l10n) => a.customerId == null
      ? l10n.commonWalkInNamed(a.walkInName ?? l10n.commonGuest)
      : customers[a.customerId]?.name ?? l10n.commonCustomer;

  String stylist(Appointment a, AppLocalizations l10n) =>
      staff[a.staffId]?.name ?? l10n.commonStylist;
}

final peopleNamesProvider = FutureProvider.autoDispose<PeopleNames>((
  ref,
) async {
  ref.watch(dataVersionProvider);
  final customers = await ref
      .watch(customerRepositoryProvider)
      .list(includeInactive: true);
  final staff = await ref
      .watch(staffRepositoryProvider)
      .list(includeInactive: true);
  return PeopleNames(
    customers: {for (final c in customers) c.id: c},
    staff: {for (final s in staff) s.id: s},
  );
});

/// Appointments in the Monday-start week beginning [weekStart].
final weekAppointmentsProvider = FutureProvider.autoDispose
    .family<List<Appointment>, DateTime>((ref, weekStart) async {
      ref.watch(dataVersionProvider);
      return ref
          .watch(appointmentRepositoryProvider)
          .listInRange(
            DateRange(
              weekStart,
              DateTime(weekStart.year, weekStart.month, weekStart.day + 7),
            ),
          );
    });

/// Appointments on one day (used by the booking form for clashes).
final dayAppointmentsProvider = FutureProvider.autoDispose
    .family<List<Appointment>, DateTime>((ref, day) async {
      ref.watch(dataVersionProvider);
      return ref
          .watch(appointmentRepositoryProvider)
          .listInRange(DateRange.day(day));
    });

class AppointmentDetail {
  const AppointmentDetail({
    required this.appointment,
    required this.customer,
    required this.staff,
    required this.invoice,
  });

  final Appointment appointment;
  final Customer? customer;
  final Staff? staff;

  /// The non-void bill for this appointment, if any.
  final Invoice? invoice;

  String clientName(AppLocalizations l10n) =>
      customer?.name ?? appointment.walkInName ?? l10n.commonGuest;
  String? get phone => customer?.phone ?? appointment.walkInPhone;
}

final appointmentDetailProvider = FutureProvider.autoDispose
    .family<AppointmentDetail?, String>((ref, id) async {
      ref.watch(dataVersionProvider);
      final a = await ref.watch(appointmentRepositoryProvider).getById(id);
      if (a == null) return null;
      final customer = a.customerId == null
          ? null
          : await ref.watch(customerRepositoryProvider).getById(a.customerId!);
      return AppointmentDetail(
        appointment: a,
        customer: customer,
        staff: await ref.watch(staffRepositoryProvider).getById(a.staffId),
        invoice: await ref
            .watch(invoiceRepositoryProvider)
            .findByAppointment(a.id),
      );
    });

/// What the New / Reschedule form needs.
class BookingData {
  const BookingData({
    required this.parlour,
    required this.customers,
    required this.services,
    required this.staff,
    this.existing,
    this.existingCustomer,
  });

  final Parlour parlour;

  /// Active customers, A–Z.
  final List<Customer> customers;

  /// Active services.
  final List<ServiceItem> services;

  /// Active staff.
  final List<Staff> staff;

  /// Set when rescheduling.
  final Appointment? existing;

  /// The rescheduled appointment's customer (even if now inactive).
  final Customer? existingCustomer;
}

/// [appointmentId] set = reschedule that appointment.
final bookingDataProvider = FutureProvider.autoDispose
    .family<BookingData, String?>((ref, appointmentId) async {
      final existing = appointmentId == null
          ? null
          : await ref
                .watch(appointmentRepositoryProvider)
                .getById(appointmentId);
      return BookingData(
        parlour: await ref.watch(parlourRepositoryProvider).get(),
        customers: await ref.watch(customerRepositoryProvider).list(),
        services: await ref.watch(serviceRepositoryProvider).list(),
        staff: await ref.watch(staffRepositoryProvider).list(),
        existing: existing,
        existingCustomer: existing?.customerId == null
            ? null
            : await ref
                  .watch(customerRepositoryProvider)
                  .getById(existing!.customerId!),
      );
    });

class AppointmentActions {
  AppointmentActions(this._ref);

  final Ref _ref;

  String newId() => _ref.read(idGeneratorProvider)();
  DateTime now() => _ref.read(clockProvider)();

  Future<Appointment> save(Appointment appointment) =>
      _ref.read(appointmentRepositoryProvider).save(appointment);

  Future<Appointment> changeStatus(
    String id,
    AppointmentStatus to, {
    String? cancelReason,
  }) => _ref
      .read(appointmentRepositoryProvider)
      .changeStatus(id, to, cancelReason: cancelReason);
}

final appointmentActionsProvider = Provider<AppointmentActions>(
  AppointmentActions.new,
);
