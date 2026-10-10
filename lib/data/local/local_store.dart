import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'store_data.dart';

/// Builds a fresh data set, e.g. the demo seed for "now".
typedef StoreSeeder = StoreData Function(DateTime now);

/// Keeps all app data in memory and in one JSON file
/// (`myparlour_demo.json`) inside [directory].
///
/// Writes are atomic: the JSON goes to a temp file which is then renamed
/// over the real file. Each [transact] call changes a copy of the data,
/// saves once, and only then makes the copy current, so a change either
/// fully happens or not at all.
class LocalStore {
  LocalStore({
    required this.directory,
    required this.seeder,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  static const fileName = 'myparlour_demo.json';

  final Directory directory;
  final StoreSeeder seeder;
  final DateTime Function() clock;

  StoreData? _data;
  Future<void> _queue = Future.value();
  final _changes = StreamController<void>.broadcast();

  File get file => File('${directory.path}${Platform.pathSeparator}$fileName');
  File get _tempFile => File('${file.path}.tmp');

  /// Emits after every successful change.
  Stream<void> get changes => _changes.stream;

  StoreData get data {
    final data = _data;
    if (data == null) throw StateError('LocalStore.load() was not called.');
    return data;
  }

  /// Reads the file, or seeds and saves when there is none. A damaged
  /// file is kept as `.broken` and the seed is used instead.
  Future<void> load() async {
    if (await file.exists()) {
      try {
        final text = await file.readAsString();
        _data = StoreData.fromJson(jsonDecode(text) as Map<String, Object?>);
        return;
      } on Object {
        await file.rename(
          '${file.path}.broken-${clock().millisecondsSinceEpoch}',
        );
      }
    }
    final seeded = seeder(clock());
    await _write(seeded);
    _data = seeded;
  }

  /// Runs [change] on a copy of the data, saves it, then makes it current.
  /// If [change] throws or the save fails, nothing changes.
  Future<T> transact<T>(T Function(StoreData working) change) =>
      _serialised(() async {
        final working = data.copy();
        final result = change(working);
        await _write(working);
        _data = working;
        _changes.add(null);
        return result;
      });

  /// Replaces all data (reset demo / start empty).
  Future<void> replaceAll(StoreData next) => _serialised(() async {
    await _write(next);
    _data = next;
    _changes.add(null);
  });

  Future<void> dispose() => _changes.close();

  Future<T> _serialised<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  Future<void> _write(StoreData data) async {
    await directory.create(recursive: true);
    final temp = _tempFile;
    await temp.writeAsString(jsonEncode(data.toJson()), flush: true);
    await temp.rename(file.path);
  }
}
