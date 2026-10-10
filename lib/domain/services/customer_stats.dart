import '../models/appointment.dart';
import '../models/invoice.dart';
import '../models/payment.dart';
import 'invoice_rules.dart';

/// One line in a customer's History tab: an appointment (with its bill,
/// if any) or a bill made without an appointment.
class HistoryEntry {
  const HistoryEntry({
    required this.at,
    required this.services,
    required this.amountPaise,
    this.appointment,
    this.invoice,
  });

  final DateTime at;
  final String services;

  /// The bill total when billed, otherwise the booked services' price.
  final int amountPaise;
  final Appointment? appointment;
  final Invoice? invoice;
}

abstract final class CustomerStats {
  /// Appointments and bills merged, newest first. A bill linked to an
  /// appointment is shown on that appointment's line. Void bills are left
  /// out.
  static List<HistoryEntry> history({
    required Iterable<Appointment> appointments,
    required Iterable<Invoice> invoices,
  }) {
    final live = invoices.where((i) => !i.isVoid).toList();
    final byAppointment = {
      for (final i in live)
        if (i.appointmentId != null) i.appointmentId!: i,
    };
    final entries = <HistoryEntry>[
      for (final a in appointments)
        HistoryEntry(
          at: a.startsAt,
          services: a.services.map((s) => s.name).join(', '),
          amountPaise: byAppointment[a.id]?.totalPaise ?? a.totalPricePaise,
          appointment: a,
          invoice: byAppointment[a.id],
        ),
      for (final i in live)
        if (i.appointmentId == null ||
            !appointments.any((a) => a.id == i.appointmentId))
          HistoryEntry(
            at: i.finalisedAt ?? i.createdAt,
            services: i.items.map((item) => item.name).join(', '),
            amountPaise: i.totalPaise,
            invoice: i,
          ),
    ]..sort((a, b) => b.at.compareTo(a.at));
    return entries;
  }

  /// Money the customer has actually paid: non-void payments on their
  /// non-void bills.
  static int totalSpentPaise({
    required Iterable<Invoice> invoices,
    required Iterable<Payment> payments,
  }) {
    final ids = {
      for (final i in invoices)
        if (!i.isVoid) i.id,
    };
    return InvoiceRules.paidPaise(
      payments.where((p) => ids.contains(p.invoiceId)),
    );
  }

  /// Completed appointments.
  static int visits(Iterable<Appointment> appointments) =>
      appointments.where((a) => a.status == AppointmentStatus.completed).length;
}
