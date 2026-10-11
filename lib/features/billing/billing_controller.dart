import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/parlour.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/product.dart';
import '../../domain/models/service_item.dart';
import '../../domain/models/staff.dart';
import '../../domain/repositories/repositories.dart';
import 'receipt/receipt_pdf.dart';

/// "Walk-in · Kiran", or "Walk-in customer" when no name was given.
String walkInLabel(String? name) {
  final n = name?.trim();
  return (n == null || n.isEmpty || n == 'Walk-in')
      ? 'Walk-in customer'
      : 'Walk-in · $n';
}

/// Segments on the Billing tab.
enum BillFilter { open, all }

class BillRow {
  const BillRow({required this.invoice, required this.clientName});

  final Invoice invoice;
  final String clientName;
}

/// All bills, newest first, with the client's name.
final billRowsProvider = FutureProvider.autoDispose<List<BillRow>>((ref) async {
  ref.watch(dataVersionProvider);
  final invoices = await ref.watch(invoiceRepositoryProvider).list();
  final customers = await ref
      .watch(customerRepositoryProvider)
      .list(includeInactive: true);
  final names = {for (final c in customers) c.id: c.name};
  return [
    for (final i in invoices)
      BillRow(
        invoice: i,
        clientName: i.customerId == null
            ? walkInLabel(i.walkInName)
            : names[i.customerId] ?? 'Customer',
      ),
  ];
});

/// "Open" = drafts and finalised bills with money still due.
List<BillRow> filterBills(List<BillRow> rows, BillFilter filter) =>
    filter == BillFilter.all
    ? rows
    : rows.where((r) => r.invoice.isDraft || r.invoice.isOpen).toList();

class BillDetail {
  const BillDetail({
    required this.invoice,
    required this.payments,
    required this.parlour,
    required this.customer,
    required this.staffNames,
  });

  final Invoice invoice;

  /// All payments on the bill (void ones included), oldest first.
  final List<Payment> payments;
  final Parlour parlour;
  final Customer? customer;
  final Map<String, String> staffNames;

  String get clientName => customer?.name ?? walkInLabel(invoice.walkInName);

  ReceiptData get receipt => ReceiptData(
    parlour: parlour,
    invoice: invoice,
    payments: payments.where((p) => !p.isVoid).toList(),
    customerName: customer?.name ?? invoice.walkInName ?? 'Walk-in',
    customerPhone: customer?.phone,
    staffNames: staffNames,
  );
}

final billDetailProvider = FutureProvider.autoDispose
    .family<BillDetail?, String>((ref, id) async {
      ref.watch(dataVersionProvider);
      final invoice = await ref.watch(invoiceRepositoryProvider).getById(id);
      if (invoice == null) return null;
      final staff = await ref
          .watch(staffRepositoryProvider)
          .list(includeInactive: true);
      return BillDetail(
        invoice: invoice,
        payments: await ref.watch(paymentRepositoryProvider).listForInvoice(id),
        parlour: await ref.watch(parlourRepositoryProvider).get(),
        customer: invoice.customerId == null
            ? null
            : await ref
                  .watch(customerRepositoryProvider)
                  .getById(invoice.customerId!),
        staffNames: {for (final s in staff) s.id: s.name},
      );
    });

/// Which bill the editor opens: a draft to continue, or a new bill
/// (optionally from an appointment or for a customer).
typedef BillEditorArgs = ({
  String? draftId,
  String? appointmentId,
  String? customerId,
});

class BillEditorData {
  const BillEditorData({
    required this.parlour,
    required this.services,
    required this.products,
    required this.customers,
    required this.staff,
    this.draft,
    this.appointment,
    this.existingBillForAppointment,
    this.presetCustomer,
  });

  final Parlour parlour;
  final List<ServiceItem> services;
  final List<Product> products;
  final List<Customer> customers;

  /// All staff (inactive too, for names on old lines).
  final List<Staff> staff;
  final Invoice? draft;
  final Appointment? appointment;

  /// Set when the appointment already has a bill: open that one instead.
  final Invoice? existingBillForAppointment;
  final Customer? presetCustomer;
}

final billEditorDataProvider = FutureProvider.autoDispose
    .family<BillEditorData, BillEditorArgs>((ref, args) async {
      final invoices = ref.watch(invoiceRepositoryProvider);
      final customers = ref.watch(customerRepositoryProvider);
      final draft = args.draftId == null
          ? null
          : await invoices.getById(args.draftId!);
      final appointmentId = args.appointmentId ?? draft?.appointmentId;
      final appointment = appointmentId == null
          ? null
          : await ref
                .watch(appointmentRepositoryProvider)
                .getById(appointmentId);
      final existing = args.appointmentId == null
          ? null
          : await invoices.findByAppointment(args.appointmentId!);
      final customerId =
          draft?.customerId ?? appointment?.customerId ?? args.customerId;
      return BillEditorData(
        parlour: await ref.watch(parlourRepositoryProvider).get(),
        services: await ref.watch(serviceRepositoryProvider).list(),
        products: await ref.watch(productRepositoryProvider).list(),
        customers: await customers.list(),
        staff: await ref
            .watch(staffRepositoryProvider)
            .list(includeInactive: true),
        draft: draft,
        appointment: appointment,
        existingBillForAppointment: existing,
        presetCustomer: customerId == null
            ? null
            : await customers.getById(customerId),
      );
    });

class BillingActions {
  BillingActions(this._ref);

  final Ref _ref;

  String newId() => _ref.read(idGeneratorProvider)();

  Future<Invoice> saveDraft(BillDraft draft) =>
      _ref.read(invoiceRepositoryProvider).saveDraft(draft);

  Future<Invoice> finalise(BillDraft draft) =>
      _ref.read(invoiceRepositoryProvider).finalise(draft);

  Future<Invoice> recordPayment(PaymentInput input) =>
      _ref.read(invoiceRepositoryProvider).recordPayment(input);

  Future<Invoice> voidBill(String id) =>
      _ref.read(invoiceRepositoryProvider).voidInvoice(id);
}

final billingActionsProvider = Provider<BillingActions>(BillingActions.new);
