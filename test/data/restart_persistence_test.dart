import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/demo/demo_seed.dart';
import 'package:myparlour/data/local/local_customer_repository.dart';
import 'package:myparlour/data/local/local_service_repository.dart';
import 'package:myparlour/data/local/local_staff_repository.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/data/local/store_file.dart';
import 'package:myparlour/domain/models/customer.dart';
import 'package:myparlour/domain/models/service_item.dart';
import 'package:myparlour/domain/models/staff.dart';
import 'package:myparlour/domain/models/value_types.dart';

import '../helpers/test_data.dart';

/// Creates, edits and deactivates records on the real file, then opens a
/// fresh store from the same folder (an app restart) and checks them.
void main() {
  test('customers, services and staff survive an app restart', () async {
    final store = await openTestStore(
      seeder: (now) => DemoSeed.build(now, sequentialIds('seed')),
    );
    final dir = storeDirectory(store);
    final customers = LocalCustomerRepository(store);
    final services = LocalServiceRepository(store);
    final staff = LocalStaffRepository(store);

    await customers.save(
      Customer(
        id: 'new-cust',
        parlourId: '',
        name: 'Zoya Khan',
        phone: '99001 22334',
        birthday: const DayMonth(3, 9),
        notes: 'Likes cool water',
        createdAt: testNow,
      ),
    );
    final priya = (await customers.list()).firstWhere(
      (c) => c.name == 'Priya Sharma',
    );
    await customers.setActive(priya.id, isActive: false);

    await services.save(
      const ServiceItem(
        id: 'new-svc',
        parlourId: '',
        name: 'Bridal makeup',
        category: 'Bridal',
        pricePaise: 800000,
        durationMin: 120,
        taxRateBp: 1800,
      ),
    );
    final haircut = (await services.list()).firstWhere(
      (s) => s.name == 'Haircut',
    );
    await services.setActive(haircut.id, isActive: false);

    await staff.save(
      const Staff(
        id: 'new-staff',
        parlourId: '',
        name: 'Sana',
        phone: '98765 55555',
        roleTitle: 'Receptionist',
        serviceIds: [],
        workingDays: [1, 2, 3],
        startTime: ClockTime(9, 0),
        endTime: ClockTime(17, 0),
      ),
    );
    await store.dispose();

    // Restart: a brand-new store reading the same folder.
    final reopened = LocalStore(
      storage: DiskStoreFile(dir),
      seeder: (_) => throw StateError('must not reseed'),
    );
    await reopened.load();
    expect(reopened.seededOnLoad, isFalse);

    final zoya = await LocalCustomerRepository(reopened).getById('new-cust');
    expect(zoya!.name, 'Zoya Khan');
    expect(zoya.birthday, const DayMonth(3, 9));
    expect(zoya.notes, 'Likes cool water');
    expect(
      (await LocalCustomerRepository(reopened).getById(priya.id))!.isActive,
      isFalse,
    );

    final bridal = await LocalServiceRepository(reopened).getById('new-svc');
    expect(bridal!.category, 'Bridal');
    expect(
      (await LocalServiceRepository(reopened).getById(haircut.id))!.isActive,
      isFalse,
    );

    final sana = await LocalStaffRepository(reopened).getById('new-staff');
    expect(sana!.roleTitle, 'Receptionist');
    expect(sana.startTime, const ClockTime(9, 0));

    await deleteTestStore(reopened);
  });
}
