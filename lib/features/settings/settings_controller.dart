import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/providers.dart';
import '../../domain/models/parlour.dart';

final parlourProvider = FutureProvider.autoDispose<Parlour>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(parlourRepositoryProvider).get();
});

/// "0.1.0 (12)" from the installed build. Overridable in tests.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.buildNumber.isEmpty
      ? info.version
      : '${info.version} (${info.buildNumber})';
});

class SettingsActions {
  SettingsActions(this._ref);

  final Ref _ref;

  Future<Parlour> saveParlour(Parlour parlour) =>
      _ref.read(parlourRepositoryProvider).save(parlour);

  Future<void> resetDemo() => _ref.read(demoDataRepositoryProvider).resetDemo();

  Future<void> startEmpty() =>
      _ref.read(demoDataRepositoryProvider).startEmpty();
}

final settingsActionsProvider = Provider<SettingsActions>(SettingsActions.new);
