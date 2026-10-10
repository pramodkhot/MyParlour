import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/domain/models/customer.dart';
import 'package:myparlour/domain/models/service_item.dart';
import 'package:myparlour/domain/models/staff.dart';
import 'package:myparlour/domain/models/value_types.dart';
import 'package:myparlour/features/customers/customers_controller.dart';
import 'package:myparlour/features/services/services_controller.dart';
import 'package:myparlour/features/staff/staff_controller.dart';

CustomerRow row(
  String name,
  String phone, {
  DateTime? lastVisit,
  bool active = true,
  int visits = 0,
}) => CustomerRow(
  customer: Customer(
    id: name,
    parlourId: 'p',
    name: name,
    phone: phone,
    isActive: active,
    createdAt: DateTime.utc(2026),
    lastVisitAt: lastVisit,
  ),
  visits: visits,
);

void main() {
  group('customers', () {
    final rows = [
      row('Priya Sharma', '98765 43210', lastVisit: DateTime(2026, 5, 10)),
      row('Neha Verma', '91234 56789', lastVisit: DateTime(2026, 5, 12)),
      row('anjali Singh', '77665 44322'),
      row('Old Client', '90000 00000', active: false),
    ];

    List<String> names(List<CustomerRow> r) =>
        r.map((x) => x.customer.name).toList();

    test('recent visit first; never-visited last', () {
      expect(
        names(filterCustomers(rows, query: '', view: CustomerView.recentVisit)),
        ['Neha Verma', 'Priya Sharma', 'anjali Singh'],
      );
    });

    test('A–Z ignores case', () {
      expect(names(filterCustomers(rows, query: '', view: CustomerView.az)), [
        'anjali Singh',
        'Neha Verma',
        'Priya Sharma',
      ]);
    });

    test('search by name part or phone digits', () {
      expect(
        names(filterCustomers(rows, query: 'shar', view: CustomerView.az)),
        ['Priya Sharma'],
      );
      expect(
        names(filterCustomers(rows, query: '+91 9123', view: CustomerView.az)),
        ['Neha Verma'],
      );
      expect(
        filterCustomers(rows, query: 'zzz', view: CustomerView.az),
        isEmpty,
      );
    });

    test('inactive view shows only deactivated customers', () {
      expect(
        names(filterCustomers(rows, query: '', view: CustomerView.inactive)),
        ['Old Client'],
      );
    });
  });

  test('services grouped by category in the default order', () {
    ServiceItem s(String name, String cat, {bool active = true}) => ServiceItem(
      id: name,
      parlourId: 'p',
      name: name,
      category: cat,
      pricePaise: 100,
      durationMin: 30,
      taxRateBp: 0,
      isActive: active,
    );
    final groups = groupServices([
      s('Bridal makeup', 'Bridal'),
      s('Manicure', 'Nails'),
      s('Old cut', 'Hair', active: false),
      s('Haircut', 'Hair'),
    ]);
    expect(groups.map((g) => g.$1), ['Hair', 'Nails', 'Bridal']);
    expect(groups.first.$2.map((x) => x.name), ['Haircut', 'Old cut']);
  });

  test('staff search by name, role or phone', () {
    Staff s(String name, String role, String phone) => Staff(
      id: name,
      parlourId: 'p',
      name: name,
      phone: phone,
      roleTitle: role,
      serviceIds: const [],
      workingDays: const [1],
      startTime: const ClockTime(10, 0),
      endTime: const ClockTime(20, 0),
    );
    final staff = [
      s('Anita', 'Senior Beautician', '98765 11111'),
      s('Pooja', 'Junior', '98765 44444'),
    ];
    expect(filterStaff(staff, 'jun').map((x) => x.name), ['Pooja']);
    expect(filterStaff(staff, '11111').map((x) => x.name), ['Anita']);
    expect(filterStaff(staff, ''), hasLength(2));
  });
}
