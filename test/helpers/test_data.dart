import 'dart:io';

import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/data/local/store_data.dart';
import 'package:myparlour/data/local/store_file.dart';
import 'package:myparlour/domain/models/appointment.dart';
import 'package:myparlour/domain/models/customer.dart';
import 'package:myparlour/domain/models/invoice.dart';
import 'package:myparlour/domain/models/parlour.dart';
import 'package:myparlour/domain/models/product.dart';
import 'package:myparlour/domain/models/service_item.dart';
import 'package:myparlour/domain/models/value_types.dart';
import 'package:myparlour/domain/repositories/repositories.dart';

/// Sequential ids so tests are readable and repeatable.
String Function() sequentialIds([String prefix = 'id']) {
  var n = 0;
  return () => '$prefix-${++n}';
}

/// Thursday 14 May 2026, 4:12 PM local.
final testNow = DateTime(2026, 5, 14, 16, 12);

Parlour testParlour({bool taxEnabled = false}) => Parlour(
  id: 'parlour-1',
  name: 'Test Parlour',
  ownerName: 'Kavita',
  phone: '9876500000',
  area: 'Pune',
  openDays: const [1, 2, 3, 4, 5, 6],
  openTime: const ClockTime(10, 0),
  closeTime: const ClockTime(20, 0),
  slotMinutes: 30,
  invoicePrefix: 'BBP',
  taxEnabled: taxEnabled,
  defaultTaxRateBp: 1800,
);

const haircut = ServiceItem(
  id: 'svc-haircut',
  parlourId: 'parlour-1',
  name: 'Haircut',
  category: 'Hair',
  pricePaise: 50000,
  durationMin: 30,
  taxRateBp: 1800,
);

const smoothening = ServiceItem(
  id: 'svc-smooth',
  parlourId: 'parlour-1',
  name: 'Smoothening',
  category: 'Hair',
  pricePaise: 250000,
  durationMin: 90,
  taxRateBp: 1800,
);

const serum = Product(
  id: 'prod-serum',
  parlourId: 'parlour-1',
  name: 'Hair Serum',
  unit: ProductUnit.pcs,
  sellingPricePaise: 45000,
  stockQty: 2,
  lowStockAt: 3,
);

final priya = Customer(
  id: 'cust-priya',
  parlourId: 'parlour-1',
  name: 'Priya Sharma',
  phone: '98765 43210',
  createdAt: DateTime.utc(2026, 1, 5),
);

Appointment testAppointment({
  String id = 'appt-1',
  String staffId = 'staff-anita',
  DateTime? start,
  int minutes = 30,
  AppointmentStatus status = AppointmentStatus.booked,
}) {
  final s = start ?? DateTime(2026, 5, 14, 10);
  return Appointment(
    id: id,
    parlourId: 'parlour-1',
    customerId: 'cust-priya',
    staffId: staffId,
    startsAt: s,
    endsAt: s.add(Duration(minutes: minutes)),
    status: status,
    services: [
      AppointmentService(
        serviceId: haircut.id,
        name: haircut.name,
        pricePaise: haircut.pricePaise,
        durationMin: minutes,
      ),
    ],
  );
}

/// A small data set for repository tests.
StoreData smallData({bool taxEnabled = false}) => StoreData(
  parlour: testParlour(taxEnabled: taxEnabled),
  services: [haircut, smoothening],
  products: [serum],
  customers: [priya],
  appointments: [testAppointment(status: AppointmentStatus.completed)],
);

BillLine serviceLine(ServiceItem s, {int qty = 1}) => BillLine(
  type: InvoiceItemType.service,
  refId: s.id,
  name: s.name,
  unitPricePaise: s.pricePaise,
  qty: qty,
  taxRateBp: s.taxRateBp,
);

BillLine productLine(Product p, {int qty = 1}) => BillLine(
  type: InvoiceItemType.product,
  refId: p.id,
  name: p.name,
  unitPricePaise: p.sellingPricePaise!,
  qty: qty,
  taxRateBp: 1800,
);

/// A loaded [LocalStore] on a real file in a fresh temp folder.
Future<LocalStore> openTestStore({
  StoreData Function(DateTime now)? seeder,
  DateTime Function()? clock,
}) async {
  final dir = await Directory.systemTemp.createTemp('myparlour_test_');
  final store = LocalStore(
    storage: DiskStoreFile(dir),
    seeder: seeder ?? (_) => smallData(),
    clock: clock ?? () => testNow,
  );
  await store.load();
  return store;
}

/// The temp folder behind a store from [openTestStore].
Directory storeDirectory(LocalStore store) =>
    (store.storage as DiskStoreFile).directory;

/// The data file behind a store from [openTestStore].
File storeFile(LocalStore store) => (store.storage as DiskStoreFile).file;

Future<void> deleteTestStore(LocalStore store) async {
  await store.dispose();
  final dir = storeDirectory(store);
  if (await dir.exists()) await dir.delete(recursive: true);
}
