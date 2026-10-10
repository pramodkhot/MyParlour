import '../../core/format/phone.dart';
import '../models/customer.dart';

abstract final class CustomerRules {
  /// An existing customer with the same mobile number (compared on the last
  /// 10 digits), or null. Used for a warning only; it never blocks saving.
  static Customer? findDuplicate({
    required String phone,
    required Iterable<Customer> customers,
    String? excludeId,
  }) {
    final target = PhoneNumber.normalise(phone);
    if (target == null) return null;
    for (final customer in customers) {
      if (customer.id == excludeId) continue;
      if (PhoneNumber.normalise(customer.phone) == target) return customer;
    }
    return null;
  }
}
