import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/core/format/money.dart';

void main() {
  group('Money.format', () {
    test('whole rupees use Indian grouping without decimals', () {
      expect(Money.format(0), '₹0');
      expect(Money.format(49900), '₹499');
      expect(Money.format(845000), '₹8,450');
      expect(Money.format(12345600), '₹1,23,456');
      expect(Money.format(1000000000), '₹1,00,00,000');
    });

    test('shows paise when present', () {
      expect(Money.format(49950), '₹499.50');
      expect(Money.format(5), '₹0.05');
      expect(Money.format(12345601), '₹1,23,456.01');
    });

    test('negative amounts', () {
      expect(Money.format(-30000), '-₹300');
    });
  });

  group('Money.parseRupees', () {
    test('parses typed amounts into paise', () {
      expect(Money.parseRupees('499'), 49900);
      expect(Money.parseRupees('499.5'), 49950);
      expect(Money.parseRupees('499.05'), 49905);
      expect(Money.parseRupees('₹1,23,456'), 12345600);
      expect(Money.parseRupees(' 0 '), 0);
    });

    test('rejects invalid input', () {
      expect(Money.parseRupees(''), isNull);
      expect(Money.parseRupees('abc'), isNull);
      expect(Money.parseRupees('-5'), isNull);
      expect(Money.parseRupees('1.234'), isNull);
    });
  });
}
