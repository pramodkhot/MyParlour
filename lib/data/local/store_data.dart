import '../../domain/models/appointment.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/json.dart';
import '../../domain/models/parlour.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/product.dart';
import '../../domain/models/service_item.dart';
import '../../domain/models/staff.dart';
import '../../domain/models/stock_movement.dart';

/// Everything the demo stores, as one JSON document.
///
/// Models are immutable, so [copy] only copies the lists. Repositories
/// change a copy and `LocalStore` swaps it in after a successful save.
class StoreData {
  StoreData({
    required this.parlour,
    List<Customer>? customers,
    List<ServiceItem>? services,
    List<Staff>? staff,
    List<Appointment>? appointments,
    List<Invoice>? invoices,
    List<Payment>? payments,
    List<Product>? products,
    List<StockMovement>? stockMovements,
    List<Expense>? expenses,
    Map<String, int>? invoiceSerials,
  }) : customers = customers ?? [],
       services = services ?? [],
       staff = staff ?? [],
       appointments = appointments ?? [],
       invoices = invoices ?? [],
       payments = payments ?? [],
       products = products ?? [],
       stockMovements = stockMovements ?? [],
       expenses = expenses ?? [],
       invoiceSerials = invoiceSerials ?? {};

  factory StoreData.fromJson(Json json) => StoreData(
    parlour: Parlour.fromJson(json['parlour']! as Json),
    customers: jsonList(json['customers']).map(Customer.fromJson).toList(),
    services: jsonList(json['services']).map(ServiceItem.fromJson).toList(),
    staff: jsonList(json['staff']).map(Staff.fromJson).toList(),
    appointments: jsonList(
      json['appointments'],
    ).map(Appointment.fromJson).toList(),
    invoices: jsonList(json['invoices']).map(Invoice.fromJson).toList(),
    payments: jsonList(json['payments']).map(Payment.fromJson).toList(),
    products: jsonList(json['products']).map(Product.fromJson).toList(),
    stockMovements: jsonList(
      json['stockMovements'],
    ).map(StockMovement.fromJson).toList(),
    expenses: jsonList(json['expenses']).map(Expense.fromJson).toList(),
    invoiceSerials: (json['invoiceSerials'] as Map<String, Object?>? ?? {}).map(
      (key, value) => MapEntry(key, value! as int),
    ),
  );

  static const schemaVersion = 1;

  Parlour parlour;
  final List<Customer> customers;
  final List<ServiceItem> services;
  final List<Staff> staff;
  final List<Appointment> appointments;
  final List<Invoice> invoices;
  final List<Payment> payments;
  final List<Product> products;
  final List<StockMovement> stockMovements;
  final List<Expense> expenses;

  /// Last invoice serial used per financial year, e.g. {"2026-27": 42}.
  /// Serials only go up, so a number is never reused.
  final Map<String, int> invoiceSerials;

  StoreData copy() => StoreData(
    parlour: parlour,
    customers: List.of(customers),
    services: List.of(services),
    staff: List.of(staff),
    appointments: List.of(appointments),
    invoices: List.of(invoices),
    payments: List.of(payments),
    products: List.of(products),
    stockMovements: List.of(stockMovements),
    expenses: List.of(expenses),
    invoiceSerials: Map.of(invoiceSerials),
  );

  Json toJson() => {
    'schemaVersion': schemaVersion,
    'parlour': parlour.toJson(),
    'customers': customers.map((e) => e.toJson()).toList(),
    'services': services.map((e) => e.toJson()).toList(),
    'staff': staff.map((e) => e.toJson()).toList(),
    'appointments': appointments.map((e) => e.toJson()).toList(),
    'invoices': invoices.map((e) => e.toJson()).toList(),
    'payments': payments.map((e) => e.toJson()).toList(),
    'products': products.map((e) => e.toJson()).toList(),
    'stockMovements': stockMovements.map((e) => e.toJson()).toList(),
    'expenses': expenses.map((e) => e.toJson()).toList(),
    'invoiceSerials': invoiceSerials,
  };
}

/// Replaces the element with the same id, or adds it at the end.
void upsertById<T>(List<T> list, T item, String Function(T) idOf) {
  final id = idOf(item);
  final index = list.indexWhere((e) => idOf(e) == id);
  if (index == -1) {
    list.add(item);
  } else {
    list[index] = item;
  }
}

T? findById<T>(Iterable<T> list, String id, String Function(T) idOf) {
  for (final item in list) {
    if (idOf(item) == id) return item;
  }
  return null;
}
