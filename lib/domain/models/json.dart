/// Small JSON helpers shared by the models. Pure Dart.
library;

typedef Json = Map<String, Object?>;

/// Timestamps are stored as ISO-8601 UTC strings.
String instantToJson(DateTime value) => value.toUtc().toIso8601String();

DateTime instantFromJson(Object? value) => DateTime.parse(value! as String);

DateTime? optionalInstant(Object? value) =>
    value == null ? null : instantFromJson(value);

/// Calendar dates (no time) are stored as `yyyy-MM-dd` and read back as
/// local midnight.
String dateToJson(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

DateTime dateFromJson(Object? value) {
  final parts = (value! as String).split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

T enumFromJson<T extends Enum>(List<T> values, Object? name) =>
    values.byName(name! as String);

T? optionalEnum<T extends Enum>(List<T> values, Object? name) =>
    name == null ? null : values.byName(name as String);

List<Json> jsonList(Object? value) =>
    (value as List<Object?>? ?? const []).cast<Json>();

List<String> stringList(Object? value) =>
    (value as List<Object?>? ?? const []).cast<String>();

List<int> intList(Object? value) =>
    (value as List<Object?>? ?? const []).cast<int>();

/// Drops null values so the stored file stays compact.
Json compact(Json json) => {
  for (final entry in json.entries)
    if (entry.value != null) entry.key: entry.value,
};
