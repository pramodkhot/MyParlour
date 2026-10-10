import 'package:flutter/material.dart';

import '../design/typography.dart';
import '../format/money.dart';

/// Shows an amount stored in paise as rupees, e.g. `₹1,23,456`.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.paise, {
    super.key,
    this.style = AppText.bodyStrong,
    this.textAlign,
  });

  final int paise;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      Money.format(paise),
      style: style,
      textAlign: textAlign,
      maxLines: 1,
    );
  }
}
