import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/core/format/phone.dart';
import 'package:myparlour/domain/models/customer.dart';
import 'package:myparlour/domain/services/customer_rules.dart';

void main() {
  group('normalise', () {
    test('accepts +91, spaces, dashes and a leading 0', () {
      for (final input in [
        '9876543210',
        '98765 43210',
        '+91 98765 43210',
        '+919876543210',
        '919876543210',
        '09876543210',
        '098765-43210',
        '(+91) 98765-43210',
      ]) {
        expect(PhoneNumber.normalise(input), '9876543210', reason: input);
      }
    });

    test('rejects numbers that are not 10 digits', () {
      for (final input in [
        '',
        '12345',
        '98765432101',
        '+44 98765 43210',
        'abc',
      ]) {
        expect(PhoneNumber.normalise(input), isNull, reason: input);
      }
    });

    test('mobile numbers start with 6–9', () {
      expect(PhoneNumber.isValidMobile('+91 98765 43210'), isTrue);
      expect(PhoneNumber.isValidMobile('12345 67890'), isFalse);
    });

    test('display and WhatsApp link', () {
      expect(PhoneNumber.display('+919876543210'), '98765 43210');
      expect(
        PhoneNumber.whatsAppUri('098765 43210').toString(),
        'https://wa.me/919876543210',
      );
      expect(PhoneNumber.whatsAppUri('123'), isNull);
    });
  });

  group('duplicate check', () {
    final customers = [
      Customer(
        id: 'c1',
        parlourId: 'p',
        name: 'Priya Sharma',
        phone: '98765 43210',
        createdAt: DateTime.utc(2026),
      ),
    ];

    test('finds the same number typed differently', () {
      expect(
        CustomerRules.findDuplicate(
          phone: '+91 9876543210',
          customers: customers,
        )?.name,
        'Priya Sharma',
      );
    });

    test('skips the customer being edited', () {
      expect(
        CustomerRules.findDuplicate(
          phone: '9876543210',
          customers: customers,
          excludeId: 'c1',
        ),
        isNull,
      );
    });

    test('no match for a different number', () {
      expect(
        CustomerRules.findDuplicate(phone: '9123456789', customers: customers),
        isNull,
      );
    });
  });
}
