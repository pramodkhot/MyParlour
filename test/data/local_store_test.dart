import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/data/local/local_store.dart';
import 'package:myparlour/data/local/store_data.dart';
import 'package:myparlour/domain/errors.dart';

import '../helpers/test_data.dart';

void main() {
  late LocalStore store;

  setUp(() async => store = await openTestStore());
  tearDown(() => deleteTestStore(store));

  test('first load seeds and writes the file', () async {
    expect(await store.file.exists(), isTrue);
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
      directory: store.directory,
      seeder: (_) => throw StateError('should not seed again'),
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
    final fileBefore = await store.file.readAsString();
    await expectLater(
      store.transact((data) {
        data.customers.clear();
        throw const ValidationException('nope');
      }),
      throwsA(isA<ValidationException>()),
    );
    expect(store.data.customers, hasLength(1));
    expect(await store.file.readAsString(), fileBefore);
  });

  test('writes leave no temp file behind', () async {
    await store.transact((data) => data.invoiceSerials['x'] = 1);
    final names = store.directory.listSync().map(
      (e) => e.uri.pathSegments.last,
    );
    expect(names, [LocalStore.fileName]);
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
    await Future.wait([
      for (var i = 0; i < 20; i++)
        store.transact((data) {
          data.invoiceSerials['n'] = (data.invoiceSerials['n'] ?? 0) + 1;
        }),
    ]);
    expect(store.data.invoiceSerials['n'], 20);
  });

  test('a damaged file is set aside and the seed is used', () async {
    final dir = await Directory.systemTemp.createTemp('myparlour_broken_');
    await File('${dir.path}/${LocalStore.fileName}').writeAsString('{oops');
    final broken = LocalStore(directory: dir, seeder: (_) => smallData());
    await broken.load();
    expect(broken.data.parlour.name, 'Test Parlour');
    expect(dir.listSync().any((e) => e.path.contains('.broken-')), isTrue);
    await broken.dispose();
    await dir.delete(recursive: true);
  });
}
