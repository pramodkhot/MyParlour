/// Problems the business rules and repositories report. Each has a [code]
/// (plus details in [DomainError.args]) so the app can show it in the
/// user's language; [DomainError.message] is the English text.
enum ErrorCode {
  customerNameRequired,
  serviceNameRequired,
  priceNegative,
  serviceDurationRequired,
  staffNameRequired,
  productNameRequired,
  lowStockNegative,
  openingStockNegative,
  expenseAmountZero,
  categoryRequired,
  appointmentNoServices,
  appointmentNoClient,
  appointmentEndBeforeStart,
  appointmentFinished,

  /// args: from, to (AppointmentStatus names)
  statusChange,
  customerNotFound,
  serviceNotFound,
  staffNotFound,
  appointmentNotFound,
  billNotFound,
  productNotFound,
  billProductMissing,
  billNoLines,

  /// args: name
  lineQtyInvalid,

  /// args: name
  linePriceInvalid,
  discountNegative,
  discountOverSubtotal,
  discountOverHundred,
  billAlreadyFinalised,

  /// args: invoiceNo (optional)
  appointmentAlreadyBilled,
  paymentNeedsFinalisedBill,
  billIsVoid,
  paymentMethodRequired,
  paymentAmountZero,
  paymentOverBalance,

  /// args: name
  outOfStock,

  /// args: name, qty
  notEnoughStock,
  stockChangeZero,
  stockSalesViaBills,
}

/// A rule broken, with the details needed to explain it.
class DomainError {
  const DomainError(this.code, [this.args = const {}]);

  final ErrorCode code;
  final Map<String, Object> args;

  String _arg(String key) => '${args[key] ?? ''}';

  /// English text (used in logs and as a fallback).
  String get message => switch (code) {
    ErrorCode.customerNameRequired => 'Enter the customer name.',
    ErrorCode.serviceNameRequired => 'Enter the service name.',
    ErrorCode.priceNegative => 'Price cannot be negative.',
    ErrorCode.serviceDurationRequired => 'Choose how long the service takes.',
    ErrorCode.staffNameRequired => 'Enter the staff member’s name.',
    ErrorCode.productNameRequired => 'Enter the product name.',
    ErrorCode.lowStockNegative => 'Low-stock alert cannot be negative.',
    ErrorCode.openingStockNegative => 'Opening stock cannot be negative.',
    ErrorCode.expenseAmountZero => 'Enter an amount more than ₹0.',
    ErrorCode.categoryRequired => 'Choose a category.',
    ErrorCode.appointmentNoServices => 'Choose at least one service.',
    ErrorCode.appointmentNoClient => 'Choose a customer or enter a name.',
    ErrorCode.appointmentEndBeforeStart => 'End time must be after start time.',
    ErrorCode.appointmentFinished => 'Finished appointments cannot be changed.',
    ErrorCode.statusChange =>
      'This appointment cannot change from ${_arg('from')} to ${_arg('to')}.',
    ErrorCode.customerNotFound => 'Customer not found.',
    ErrorCode.serviceNotFound => 'Service not found.',
    ErrorCode.staffNotFound => 'Staff member not found.',
    ErrorCode.appointmentNotFound => 'Appointment not found.',
    ErrorCode.billNotFound => 'Bill not found.',
    ErrorCode.productNotFound => 'Product not found.',
    ErrorCode.billProductMissing => 'A product on this bill no longer exists.',
    ErrorCode.billNoLines => 'Add at least one service or product.',
    ErrorCode.lineQtyInvalid =>
      'Quantity for ${_arg('name')} must be at least 1.',
    ErrorCode.linePriceInvalid => 'Check the price of ${_arg('name')}.',
    ErrorCode.discountNegative => 'Discount cannot be negative.',
    ErrorCode.discountOverSubtotal =>
      'Discount cannot be more than the subtotal.',
    ErrorCode.discountOverHundred => 'Discount cannot be more than 100%.',
    ErrorCode.billAlreadyFinalised => 'This bill is already finalised.',
    ErrorCode.appointmentAlreadyBilled =>
      args['invoiceNo'] == null
          ? 'This appointment already has a bill.'
          : 'This appointment already has a bill (${_arg('invoiceNo')}).',
    ErrorCode.paymentNeedsFinalisedBill =>
      'Finalise the bill before taking payment.',
    ErrorCode.billIsVoid => 'This bill is void.',
    ErrorCode.paymentMethodRequired => 'Choose how the customer paid.',
    ErrorCode.paymentAmountZero => 'Enter an amount more than ₹0.',
    ErrorCode.paymentOverBalance => 'Amount is more than the balance due.',
    ErrorCode.outOfStock => '${_arg('name')} is out of stock.',
    ErrorCode.notEnoughStock =>
      'Only ${_arg('qty')} ${_arg('name')} left in stock.',
    ErrorCode.stockChangeZero => 'Enter a quantity more than 0.',
    ErrorCode.stockSalesViaBills => 'Sales change stock through bills.',
  };

  @override
  String toString() => message;
}

/// Errors raised by business rules and repositories.
sealed class DomainException implements Exception {
  const DomainException(this.code, [this.args = const {}]);

  final ErrorCode code;
  final Map<String, Object> args;

  DomainError get error => DomainError(code, args);

  /// English text; screens show `context.errorText(e)` instead.
  String get message => error.message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Input breaks a rule (e.g. payment more than the balance).
class ValidationException extends DomainException {
  const ValidationException(super.code, [super.args]);
}

/// The record does not exist (or no longer exists).
class NotFoundException extends DomainException {
  const NotFoundException(super.code, [super.args]);
}

/// Selling or using more stock than is available.
class InsufficientStockException extends DomainException {
  const InsufficientStockException(super.code, [super.args]);
}

/// An appointment or bill cannot move to the requested status.
class InvalidStatusChangeException extends DomainException {
  const InvalidStatusChangeException(super.code, [super.args]);
}
