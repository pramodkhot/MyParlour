import 'dart:async';
import 'dart:convert';

import '../../core/l10n/app_language.dart';
import 'store_data.dart';
import 'store_file.dart';

/// Builds a fresh data set, e.g. the demo seed for "now" in a language.
typedef StoreSeeder = StoreData Function(DateTime now, AppLanguage language);

/// Keeps all app data in memory and saves it as one JSON document in
/// [storage] (on the phone: `myparlour_demo.json`, see [DiskStoreFile]).
///
/// Each [transact] call changes a copy of the data, saves once, and only
/// then makes the copy current, so a change either fully happens or not
/// at all. Changes run one after another, never interleaved.
class LocalStore {
  LocalStore({
    required this.storage,
    required this.seeder,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  final StoreFile storage;
  final StoreSeeder seeder;
  final DateTime Function() clock;

  StoreData? _data;
  bool _seededOnLoad = false;
  bool _pristine = false;
  Future<void> _queue = Future.value();
  final _changes = StreamController<void>.broadcast();

  /// Emits after every successful change.
  Stream<void> get changes => _changes.stream;

  /// True when [load] found no saved data and created it, i.e. the first
  /// launch after install.
  bool get seededOnLoad => _seededOnLoad;

  /// True while the data is exactly a fresh seed (nothing changed since),
  /// so it can be re-created in another language without losing anything.
  bool get isPristine => _pristine;

  StoreData get data {
    final data = _data;
    if (data == null) throw StateError('LocalStore.load() was not called.');
    return data;
  }

  /// Reads the saved data, or seeds and saves when there is none. Damaged
  /// data is set aside as `.broken-<time>` and the seed is used instead.
  Future<void> load({AppLanguage language = AppLanguage.en}) async {
    final text = await storage.read();
    if (text != null) {
      try {
        _data = StoreData.fromJson(jsonDecode(text) as Map<String, Object?>);
        return;
      } on Object {
        await storage.setAside('broken-${clock().millisecondsSinceEpoch}');
      }
    }
    final seeded = seeder(clock(), language);
    await _write(seeded);
    _data = seeded;
    _seededOnLoad = true;
    _pristine = true;
  }

  /// Runs [change] on a copy of the data, saves it, then makes it current.
  /// If [change] throws or the save fails, nothing changes.
  Future<T> transact<T>(T Function(StoreData working) change) =>
      _serialised(() async {
        final working = data.copy();
        final result = change(working);
        await _write(working);
        _data = working;
        _pristine = false;
        _changes.add(null);
        return result;
      });

  /// Replaces all data (reset demo / start empty). [pristine] marks a fresh
  /// seed.
  Future<void> replaceAll(StoreData next, {bool pristine = false}) =>
      _serialised(() async {
        await _write(next);
        _data = next;
        _pristine = pristine;
        _changes.add(null);
      });

  Future<void> dispose() => _changes.close();

  Future<T> _serialised<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  Future<void> _write(StoreData data) =>
      storage.write(jsonEncode(data.toJson()));
}
