import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/local/prefs_store.dart';
import 'app_language.dart';

/// Overridden in `main` with the loaded preferences (and in tests).
final prefsStoreProvider = Provider<PrefsStore>(
  (ref) => throw UnimplementedError('prefsStoreProvider must be overridden'),
);

/// The language the app is shown in. Changing it updates every screen at
/// once and is remembered on the phone.
final languageProvider = NotifierProvider<LanguageController, AppLanguage>(
  LanguageController.new,
);

class LanguageController extends Notifier<AppLanguage> {
  static const _key = 'language';

  @override
  AppLanguage build() {
    final language = AppLanguage.fromCode(ref.watch(prefsStoreProvider)[_key]);
    Intl.defaultLocale = language.intlLocale;
    return language;
  }

  Future<void> choose(AppLanguage language) async {
    if (language == state) return;
    Intl.defaultLocale = language.intlLocale;
    state = language;
    await ref.read(prefsStoreProvider).set(_key, language.name);
  }
}

extension AppLanguageLocale on AppLanguage {
  Locale get locale => Locale(name, 'IN');
}
