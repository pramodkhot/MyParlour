/// Repository interfaces. Screens and controllers depend only on these;
/// local JSON storage implements them now, Supabase will later.
///
/// Rules every implementation follows:
/// - `save` creates or updates by id and stamps the current parlour id.
/// - Nothing that history refers to is hard-deleted; use `setActive` or void.
/// - Each method that changes several records does so all-or-nothing.
library;

import '../models/appointment.dart';
import '../models/customer.dart';
import '../models/date_range.dart';
import '../models/expense.dart';
import '../models/invoice.dart';
import '../models/parlour.dart';
import '../models/payment.dart';
import '../models/product.dart';
import '../models/service_item.dart';
import '../models/staff.dart';
import '../models/stock_movement.dart';
import '../services/invoice_calculator.dart';

abstract interface class ParlourRepository {
  Future<Parlour> get();
  Future<Parlour> save(Parlour parlour);
}

abstract interface class CustomerRepository {
  Future<List<Customer>> list({bool includeInactive = false});
  Future<Customer?> getById(String id);
  Future<Customer> save(Customer customer);
  Future<void> setActive(String id, {required bool isActive});

  /// Existing customer with the same mobile number, for a warning.
  Future<Customer?> findDuplicate(String phone, {String? excludeId});
}

abstract interface class ServiceRepository {
  Future<List<ServiceItem>> list({bool includeInactive = false});
  Future<ServiceItem?> getById(String id);
  Future<ServiceItem> save(ServiceItem service);
  Future<void> setActive(String id, {required bool isActive});
}

abstract interface class StaffRepository {
  Future<List<Staff>> list({bool includeInactive = false});
  Future<Staff?> getById(String id);
  Future<Staff> save(Staff staff);
  Future<void> setActive(String id, {required bool isActive});
}

abstract interface class AppointmentRepository {
  /// Appointments starting inside [range], earliest first.
  Future<List<Appointment>> listInRange(DateRange range);
  Future<List<Appointment>> listForCustomer(String customerId);
  Future<Appointment?> getById(String id);

  /// Completed appointments per customer id (for "x visits").
  Future<Map<String, int>> completedVisitCounts();

  /// Creates or reschedules. Overlaps are allowed here; the screen warns.
  Future<Appointment> save(Appointment appointment);

  /// Follows the status flow in `AppointmentRules`.
  Future<Appointment> changeStatus(
    String id,
    AppointmentStatus to, {
    String? cancelReason,
  });
}

/// One line the user put on a bill, before calculation.
class BillLine {
  const BillLine({
    required this.type,
    required this.refId,
    required this.name,
    required this.unitPricePaise,
    required this.qty,
    this.itemDiscountPaise = 0,
    required this.taxRateBp,
    this.staffId,
  });

  final InvoiceItemType type;
  final String refId;
  final String name;
  final int unitPricePaise;
  final int qty;
  final int itemDiscountPaise;
  final int taxRateBp;
  final String? staffId;
}

/// What the Create bill screen submits.
class BillDraft {
  const BillDraft({
    required this.id,
    this.customerId,
    this.walkInName,
    this.appointmentId,
    required this.lines,
    this.discount = const BillDiscount.none(),
  });

  /// Chosen by the caller so a repeated submit updates the same bill.
  final String id;
  final String? customerId;
  final String? walkInName;
  final String? appointmentId;
  final List<BillLine> lines;
  final BillDiscount discount;
}

/// What the Record payment screen submits.
class PaymentInput {
  const PaymentInput({
    required this.id,
    required this.invoiceId,
    required this.amountPaise,
    required this.method,
    this.reference,
    this.note,
  });

  /// Chosen once per screen: a double tap with the same id records nothing
  /// extra.
  final String id;
  final String invoiceId;
  final int amountPaise;
  final PaymentMethod method;
  final String? reference;
  final String? note;
}

abstract interface class InvoiceRepository {
  /// All bills, newest first.
  Future<List<Invoice>> list();
  Future<Invoice?> getById(String id);

  /// The non-void bill for an appointment, if one exists.
  Future<Invoice?> findByAppointment(String appointmentId);
  Future<List<Invoice>> listForCustomer(String customerId);

  /// Creates or updates a draft bill (no number, no stock change).
  Future<Invoice> saveDraft(BillDraft draft);

  /// Saves and finalises in one step: assigns the invoice number, reduces
  /// stock for products and records `sale` movements.
  Future<Invoice> finalise(BillDraft draft);

  /// Records a payment and updates the bill's paid, balance and status.
  Future<Invoice> recordPayment(PaymentInput input);

  /// Voids a bill and its payments and puts sold stock back.
  Future<Invoice> voidInvoice(String id);
}

abstract interface class PaymentRepository {
  /// Payments received inside [range] (including void ones).
  Future<List<Payment>> listInRange(DateRange range);
  Future<List<Payment>> listForInvoice(String invoiceId);
}

abstract interface class ProductRepository {
  Future<List<Product>> list({bool includeInactive = false});
  Future<Product?> getById(String id);

  /// Creating a product with stock records a `purchase` movement. Updating
  /// never changes stock; use [adjustStock].
  Future<Product> save(Product product);
  Future<void> setActive(String id, {required bool isActive});

  /// Adds or removes stock with a reason. Never lets stock go below 0.
  Future<Product> adjustStock(
    String productId, {
    required int qtyChange,
    required StockReason reason,
    String? note,
  });

  /// Movement history for one product, newest first.
  Future<List<StockMovement>> movements(String productId);
}

abstract interface class ExpenseRepository {
  /// Expenses dated inside [range], newest first.
  Future<List<Expense>> listInRange(DateRange range);
  Future<Expense?> getById(String id);
  Future<Expense> save(Expense expense);
  Future<void> delete(String id);
}

abstract interface class DemoDataRepository {
  /// Restores the original sample data, dated relative to today.
  Future<void> resetDemo();

  /// Keeps the parlour profile and clears everything else.
  Future<void> startEmpty();
}
