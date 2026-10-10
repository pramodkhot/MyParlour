import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/core/format/dates.dart';
import 'package:myparlour/core/widgets/avatar_initials.dart';

void main() {
  test('AvatarInitials.initialsOf', () {
    expect(AvatarInitials.initialsOf('Priya Sharma'), 'PS');
    expect(AvatarInitials.initialsOf('  neha   kumari verma '), 'NV');
    expect(AvatarInitials.initialsOf('Anita'), 'AN');
    expect(AvatarInitials.initialsOf('A'), 'A');
    expect(AvatarInitials.initialsOf(''), '?');
  });

  test('Greeting.forTime', () {
    expect(Greeting.forTime(DateTime(2026, 5, 14, 9)), 'Good morning');
    expect(
      Greeting.forTime(DateTime(2026, 5, 14, 12), name: 'Kavita'),
      'Good afternoon, Kavita',
    );
    expect(Greeting.forTime(DateTime(2026, 5, 14, 16, 59)), 'Good afternoon');
    expect(Greeting.forTime(DateTime(2026, 5, 14, 17)), 'Good evening');
  });
}
