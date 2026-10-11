import 'package:flutter/material.dart';

import '../../domain/models/payment.dart';

/// Icons for payment methods. Names come from
/// `context.l10n.paymentMethod(m)` / `paymentReference(m)`.
extension PaymentMethodUi on PaymentMethod {
  IconData get icon => switch (this) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.upi => Icons.qr_code_2_rounded,
    PaymentMethod.card => Icons.credit_card_rounded,
    PaymentMethod.other => Icons.more_horiz_rounded,
  };
}
