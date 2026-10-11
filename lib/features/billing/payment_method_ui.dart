import 'package:flutter/material.dart';

import '../../domain/models/payment.dart';

/// Labels and icons for payment methods.
extension PaymentMethodUi on PaymentMethod {
  String get label => switch (this) {
    PaymentMethod.cash => 'Cash',
    PaymentMethod.upi => 'UPI',
    PaymentMethod.card => 'Card',
    PaymentMethod.other => 'Other',
  };

  IconData get icon => switch (this) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.upi => Icons.qr_code_2_rounded,
    PaymentMethod.card => Icons.credit_card_rounded,
    PaymentMethod.other => Icons.more_horiz_rounded,
  };

  /// Label for the optional reference field.
  String get referenceLabel => switch (this) {
    PaymentMethod.upi => 'UPI ref',
    PaymentMethod.card => 'Card last 4',
    _ => 'Reference',
  };
}
