import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, Object?>;

/// Placeholder names used in a message, e.g. {name} and {count, plural, …}.
Set<String> _placeholders(String text) => {
  for (final m in RegExp(r'\{(\w+)\s*[,}]').allMatches(text)) m.group(1)!,
};

void main() {
  final en = _arb('en');
  final keys = [
    for (final k in en.keys)
      if (!k.startsWith('@')) k,
  ];

  for (final lang in ['mr', 'hi']) {
    group('app_$lang.arb', () {
      final other = _arb(lang);

      test('has every English message and no extra ones', () {
        final otherKeys = {
          for (final k in other.keys)
            if (!k.startsWith('@')) k,
        };
        expect(otherKeys.difference(keys.toSet()), isEmpty);
        expect(keys.toSet().difference(otherKeys), isEmpty);
      });

      test('keeps the same placeholders and is never empty', () {
        for (final k in keys) {
          final text = other[k]! as String;
          expect(text.trim(), isNotEmpty, reason: k);
          expect(
            _placeholders(text),
            _placeholders(en[k]! as String),
            reason: k,
          );
        }
      });

      test('uses 0–9 digits only', () {
        for (final k in keys) {
          expect(
            other[k]! as String,
            isNot(matches(RegExp('[०-९]'))),
            reason: k,
          );
        }
      });
    });
  }
}
