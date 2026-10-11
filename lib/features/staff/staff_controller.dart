import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/phone.dart';
import '../../core/l10n/l10n.dart';
import '../../data/providers.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/parlour.dart';
import '../../domain/models/service_item.dart';
import '../../domain/models/staff.dart';
import '../../domain/services/report_service.dart';
import '../../domain/services/staff_stats.dart';

const staffRoles = [
  'Senior Beautician',
  'Beautician',
  'Junior',
  'Receptionist',
];

/// All staff: active first, then inactive.
final allStaffProvider = FutureProvider.autoDispose<List<Staff>>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(staffRepositoryProvider).list(includeInactive: true);
});

/// Search by name, role or phone. Keeps the active-first order.
List<Staff> filterStaff(List<Staff> staff, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return staff;
  final digits = PhoneNumber.searchDigits(q);
  return staff.where((s) {
    if (s.name.toLowerCase().contains(q)) return true;
    if (s.roleTitle.toLowerCase().contains(q)) return true;
    if (digits.isEmpty) return false;
    final phone =
        PhoneNumber.normalise(s.phone) ?? s.phone.replaceAll(RegExp(r'\D'), '');
    return phone.contains(digits);
  }).toList();
}

class StaffDetail {
  const StaffDetail({
    required this.staff,
    required this.now,
    required this.upcoming,
    required this.month,
    required this.customerNames,
    required this.serviceNames,
  });

  final Staff staff;
  final DateTime now;

  /// Today's appointments (any status except cancelled) and later booked
  /// ones, earliest first.
  final List<Appointment> upcoming;

  /// Services done and amount billed this calendar month.
  final StaffPeriodStats month;
  final Map<String, String> customerNames;
  final Map<String, String> serviceNames;

  String clientName(Appointment a, AppLocalizations l10n) =>
      a.customerId == null
      ? l10n.commonWalkInNamed(a.walkInName ?? l10n.commonGuest)
      : customerNames[a.customerId] ?? l10n.commonCustomer;
}

final staffDetailProvider = FutureProvider.autoDispose
    .family<StaffDetail?, String>((ref, id) async {
      ref.watch(dataVersionProvider);
      final staff = await ref.watch(staffRepositoryProvider).getById(id);
      if (staff == null) return null;
      final now = ref.watch(clockProvider)();
      final today = DateRange.day(now);
      final appointments = await ref
          .watch(appointmentRepositoryProvider)
          .listInRange(
            DateRange(
              today.start,
              DateTime(
                today.start.year,
                today.start.month,
                today.start.day + 31,
              ),
            ),
          );
      final upcoming = appointments
          .where(
            (a) =>
                a.staffId == id &&
                (today.contains(a.startsAt)
                    ? a.status != AppointmentStatus.cancelled
                    : a.status == AppointmentStatus.booked),
          )
          .toList();
      final invoices = await ref.watch(invoiceRepositoryProvider).list();
      final customers = await ref
          .watch(customerRepositoryProvider)
          .list(includeInactive: true);
      final services = await ref
          .watch(serviceRepositoryProvider)
          .list(includeInactive: true);
      return StaffDetail(
        staff: staff,
        now: now,
        upcoming: upcoming,
        month: StaffStats.forRange(
          staffId: id,
          range: ReportService.rangeFor(ReportPeriod.thisMonth, now),
          invoices: invoices,
        ),
        customerNames: {for (final c in customers) c.id: c.name},
        serviceNames: {for (final s in services) s.id: s.name},
      );
    });

/// What the staff form needs: parlour hours (defaults) and active services.
class StaffFormData {
  const StaffFormData({required this.parlour, required this.services});

  final Parlour parlour;
  final List<ServiceItem> services;
}

final staffFormDataProvider = FutureProvider.autoDispose<StaffFormData>((
  ref,
) async {
  return StaffFormData(
    parlour: await ref.watch(parlourRepositoryProvider).get(),
    services: await ref.watch(serviceRepositoryProvider).list(),
  );
});

class StaffActions {
  StaffActions(this._ref);

  final Ref _ref;

  String newId() => _ref.read(idGeneratorProvider)();

  Future<Staff> save(Staff staff) =>
      _ref.read(staffRepositoryProvider).save(staff);

  Future<void> setActive(String id, {required bool isActive}) =>
      _ref.read(staffRepositoryProvider).setActive(id, isActive: isActive);
}

final staffActionsProvider = Provider<StaffActions>(StaffActions.new);
