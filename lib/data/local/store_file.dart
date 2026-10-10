import 'dart:io';

/// Where `LocalStore` keeps its JSON text.
abstract interface class StoreFile {
  /// The saved text, or null when nothing has been saved yet.
  Future<String?> read();

  /// Replaces the saved text in one step.
  Future<void> write(String text);

  /// Keeps unreadable data aside (so it is not lost) and clears the slot.
  Future<void> setAside(String suffix);
}

/// The real file: `myparlour_demo.json` in [directory]. Writes go to a
/// temp file which is then renamed over the real one, so a crash mid-write
/// never leaves a half-written file.
class DiskStoreFile implements StoreFile {
  DiskStoreFile(this.directory);

  static const fileName = 'myparlour_demo.json';

  final Directory directory;

  File get file => File('${directory.path}${Platform.pathSeparator}$fileName');

  @override
  Future<String?> read() async =>
      await file.exists() ? await file.readAsString() : null;

  @override
  Future<void> write(String text) async {
    await directory.create(recursive: true);
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(text, flush: true);
    await temp.rename(file.path);
  }

  @override
  Future<void> setAside(String suffix) async {
    if (await file.exists()) await file.rename('${file.path}.$suffix');
  }
}
