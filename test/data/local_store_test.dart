import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/data/local/store_data.dart';
import 'package:myparlour/data/local/store_file.dart';
import 'package:myparlour/domain/errors.dart';

import '../helpers/memory_store_file.dart';
import '../helpers/test_data.dart';

void main() {
  late LocalStore store;

  setUp(() async => store = await openTestStore());
  tearDown(() => deleteTestStore(store));

  test('first load seeds and writes the file', () async {
    expect(await storeFile(store).exists(), isTrue);
    expect(store.data.parlour.name, 'Test Parlour');
    expect(store.data.customers.single.name, 'Priya Sharma');
  });

  test('save/load round-trip keeps every field', () async {
    await store.transact((data) {
      data.invoiceSerials['2026-27'] = 7;
      data.customers.add(priya.copyWith(name: 'Second'));
    });
    final before = jsonEncode(store.data.toJson());

    final reopened = LocalStore(
      storage: DiskStoreFile(storeDirectory(store)),
      seeder: (_, _) => throw StateError('should not seed again'),
    );
    await reopened.load();
    expect(jsonEncode(reopened.data.toJson()), before);
    expect(reopened.data.invoiceSerials['2026-27'], 7);
    await reopened.dispose();
  });

  test('model JSON round-trip for the demo-sized data', () {
    final data = smallData();
    final copy = StoreData.fromJson(
      jsonDecode(jsonEncode(data.toJson())) as Map<String, Object?>,
    );
    expect(jsonEncode(copy.toJson()), jsonEncode(data.toJson()));
  });

  test('a failed change leaves memory and file untouched', () async {
    final fileBefore = await storeFile(store).readAsString();
    await expectLater(
      store.transact((data) {
        data.customers.clear();
        throw const ValidationException(ErrorCode.billNoLines);
      }),
      throwsA(isA<ValidationException>()),
    );
    expect(store.data.customers, hasLength(1));
    expect(await storeFile(store).readAsString(), fileBefore);
  });

  test('writes leave no temp file behind', () async {
    await store.transact((data) => data.invoiceSerials['x'] = 1);
    final names = storeDirectory(
      store,
    ).listSync().map((e) => e.uri.pathSegments.last);
    expect(names, [DiskStoreFile.fileName]);
  });

  test('changes stream fires after a successful change', () async {
    final events = <void>[];
    final sub = store.changes.listen(events.add);
    await store.transact((data) => data.invoiceSerials['x'] = 1);
    await Future<void>.delayed(Duration.zero);
    expect(events, hasLength(1));
    await sub.cancel();
  });

  test('concurrent changes are applied one after another', () async {
    // In memory: this checks ordering, not the disk. (On Windows, 20 rapid
    // renames of one file can briefly hit an antivirus lock.)
    final memory = LocalStore(
      storage: MemoryStoreFile(),
      seeder: (_, _) => smallData(),
    );
    await memory.load();
    await Future.wait([
      for (var i = 0; i < 20; i++)
        memory.transact((data) {
          data.invoiceSerials['n'] = (data.invoiceSerials['n'] ?? 0) + 1;
        }),
    ]);
    expect(memory.data.invoiceSerials['n'], 20);
    await memory.dispose();
  });

  test('a damaged file is set aside and the seed is used', () async {
    final dir = await Directory.systemTemp.createTemp('myparlour_broken_');
    await File('${dir.path}/${DiskStoreFile.fileName}').writeAsString('{oops');
    final broken = LocalStore(
      storage: DiskStoreFile(dir),
      seeder: (_, _) => smallData(),
    );
    await broken.load();
    expect(broken.data.parlour.name, 'Test Parlour');
    expect(dir.listSync().any((e) => e.path.contains('.broken-')), isTrue);
    await broken.dispose();
    await dir.delete(recursive: true);
  });
}
