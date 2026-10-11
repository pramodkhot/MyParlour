import 'dart:convert';

import 'store_file.dart';

/// Small device preferences (currently the language), saved as JSON in
/// their own file so "Reset demo data" and "Start empty" never touch them.
class PrefsStore {
  PrefsStore(this._storage);

  final StoreFile _storage;
  Map<String, Object?> _values = {};

  /// Reads the saved values. Unreadable or missing files mean "defaults".
  Future<void> load() async {
    try {
      final text = await _storage.read();
      if (text != null) {
        _values = (jsonDecode(text) as Map<String, Object?>?) ?? {};
      }
    } on Object {
      _values = {};
    }
  }

  Object? operator [](String key) => _values[key];

  Future<void> set(String key, Object? value) {
    _values = {..._values, key: value};
    return _storage.write(jsonEncode(_values));
  }
}
