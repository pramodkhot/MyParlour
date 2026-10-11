import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/l10n/app_language.dart';
import '../../core/l10n/language_controller.dart';
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

  /// Sample data comes back in the language the app is shown in.
  Future<void> resetDemo() => _ref
      .read(demoDataRepositoryProvider)
      .resetDemo(language: _ref.read(languageProvider));

  /// Switches the app's language. While the sample data is still as it was
  /// created (nothing saved yet, e.g. on first launch), it is created again
  /// in the new language so service and product names match.
  Future<void> chooseLanguage(AppLanguage language) async {
    await _ref.read(languageProvider.notifier).choose(language);
    final demo = _ref.read(demoDataRepositoryProvider);
    if (demo.isUntouchedSample) await demo.resetDemo(language: language);
  }

  Future<void> startEmpty() =>
      _ref.read(demoDataRepositoryProvider).startEmpty();
}

final settingsActionsProvider = Provider<SettingsActions>(SettingsActions.new);
