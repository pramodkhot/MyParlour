# Decisions

Low-cost choices made where the spec left room. Newest at the bottom of each phase.

## Phase 1

- **Android application ID** stays `com.creativeandroworld.myparlour`, as in the spec.
- **App version** is `0.1.0` (demo v0.1). CI sets the build number from the GitHub run number.
- **Fonts** are bundled in `assets/fonts/` (no runtime download). Google publishes Manrope and
  Playfair Display only as variable fonts, and Flutter does not reliably map `FontWeight` onto a
  variable font's weight axis, so static weights were cut from the official files
  (`google/fonts` repo) with fontTools: Manrope 400/500/600/700/800, Playfair Display 400/600/700.
  All include the ₹ glyph. Licences: `assets/fonts/OFL-*.txt`.
- **Font family names** in code: `Manrope`, `PlayfairDisplay` (see `core/design/typography.dart`).
- **`intl` is `^0.20.2`** because `flutter_localizations` pins that exact version.
- **Locale** is fixed to `en_IN` for number and date formatting; time zone is the phone's.
- **Money formatting**: whole rupees show without decimals (`₹1,23,456`); amounts with paise
  show two decimals (`₹499.50`). Formatting never goes through `double`.
- **Text scaling** is capped at 130% in `MaterialApp.builder`, matching the spec's upper limit.
- **Bottom navigation** uses Material 3 `NavigationBar` themed to the spec (white bar, pink pill
  behind the active burgundy icon).
- **Routes for More sections** live under `/more/...` inside the More branch, so the More tab
  stays highlighted and Back returns to More.
- **Phase placeholders**: tabs and More sections not built yet open a simple screen saying which
  build phase delivers them. They have no buttons, so no button does nothing. Each one is replaced
  in its phase.
- **Release signing**: `android/app/build.gradle.kts` uses `android/key.properties` when present
  (written by CI from repository secrets) and otherwise signs release builds with the debug key.
- **No local Android build**: APKs are built only by GitHub Actions. Local checks are
  `flutter analyze` and `flutter test`.
