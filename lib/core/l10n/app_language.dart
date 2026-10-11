/// The app's languages. Pure Dart, so the data layer (demo seed) can use
/// it too.
enum AppLanguage {
  en('English'),
  mr('मराठी'),
  hi('हिन्दी');

  const AppLanguage(this.nativeName);

  /// The language's name in its own script, as shown in the picker.
  final String nativeName;

  /// Locale tag for intl ("en_IN", "mr_IN", "hi_IN").
  String get intlLocale => '${name}_IN';

  static AppLanguage fromCode(Object? code) =>
      AppLanguage.values.where((l) => l.name == code).firstOrNull ??
      AppLanguage.en;
}
