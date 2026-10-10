import 'package:myparlour/data/local/store_file.dart';

/// Keeps the store's text in memory. Widget tests use it because real file
/// IO cannot complete on the test's fake clock.
class MemoryStoreFile implements StoreFile {
  MemoryStoreFile([this.text]);

  String? text;
  final setAsideTexts = <String>[];

  @override
  Future<String?> read() async => text;

  @override
  Future<void> write(String value) async => text = value;

  @override
  Future<void> setAside(String suffix) async {
    if (text != null) setAsideTexts.add(text!);
    text = null;
  }
}
