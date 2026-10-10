/// Errors raised by business rules and repositories. [message] is plain
/// language and safe to show to the user.
sealed class DomainException implements Exception {
  const DomainException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Input breaks a rule (e.g. payment more than the balance).
class ValidationException extends DomainException {
  const ValidationException(super.message);
}

/// The record does not exist (or no longer exists).
class NotFoundException extends DomainException {
  const NotFoundException(super.message);
}

/// Selling or using more stock than is available.
class InsufficientStockException extends DomainException {
  const InsufficientStockException(super.message);
}

/// An appointment or bill cannot move to the requested status.
class InvalidStatusChangeException extends DomainException {
  const InvalidStatusChangeException(super.message);
}
