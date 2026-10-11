# MyParlour — demo v0.1

A beauty parlour management app for Android (and later iOS), built with Flutter. This demo is for
showing the app to parlour owners and collecting feedback:

- **No login.** The app opens on a welcome screen; one tap goes in.
- **No server.** Everything is stored on the phone in one JSON file, preloaded with sample data
  for "Beauty Bliss Parlour", dated around today so the demo always looks current.
- **Real logic.** Bills, discounts, GST, payments, appointment statuses, stock and reports are
  worked out by tested Dart code, not typed into the screens.

Full specification: [MYPARLOUR_DEMO_BUILD_PROMPT.md](MYPARLOUR_DEMO_BUILD_PROMPT.md) ·
Choices made along the way: [DECISIONS.md](DECISIONS.md)

## What it does

| Area | Highlights |
|---|---|
| Dashboard | Today's sales vs yesterday, appointments still to come, pending payments, customers, quick actions, next appointments, low stock, alerts (low stock, birthdays) |
| Appointments | Week strip, status filters, book with next free slot and free/busy stylists, overlap warning, check in → complete, reschedule, cancel with reason, no-show |
| Billing | Bills from appointments or from scratch, services and products, ₹ or % discount, GST on/off, drafts, partial payments (Cash/UPI/Card/Other), void, A5 PDF receipt to share, print or save |
| Customers | Search, visits, history, notes, call/WhatsApp/SMS, duplicate-number warning |
| Staff & services | Roles, services, working days and hours, this month's work; service menu by category |
| Inventory | Low/out of stock, stock history, adjust stock, stock drops automatically when products are billed |
| Expenses & reports | Monthly expenses; sales, expenses, profit estimate, chart, top services, payment methods |
| Settings | Parlour profile, hours, billing & tax, **Reset demo data**, **Start empty** |

## Run and test (on a computer)

Needs Flutter (stable). The Android SDK is only needed to run on a phone or emulator from the
computer; APKs are normally built by GitHub (see below).

```
flutter pub get
flutter analyze        # should say "No issues found!"
flutter test           # all tests should pass
flutter run            # on a connected phone or emulator
```

The tests include the business rules, data storage, a check that report figures match a hand
calculation of the sample data, full screen flows (book → bill → pay → receipt), every screen on a
360 px phone with 130% text, and Flutter's accessibility checks (48 px tap targets, labels,
contrast).

Extra tools (not part of `flutter test`):

```
flutter test tool/screenshots_test.dart --dart-define=OUT=<folder>   # phone screenshots
flutter test tool/receipt_preview_test.dart --dart-define=OUT=<folder> # sample receipt PDF
flutter test tool/render_svgs_test.dart --plain-name icons            # regenerate launcher icons
```

## Getting the APK

Every push to `main` runs **Actions → Build APK** (analyze, test, release build). Open the latest
run and download the **myparlour-apk** artifact. Pushing a tag such as `v0.1.0` also creates a
GitHub **Release** with the APK attached.

On the phone: open the APK, allow "Install unknown apps" for the browser or file manager when
asked, then install.

### Keep updates installable: add a signing key (once)

Without your own key, each build is signed with a different temporary key, so a new APK will not
install over an old one ("App not installed") and testers must uninstall first, losing their demo
data. To fix this for good:

1. On a computer with Java: `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias myparlour`
2. Convert it to text: `base64 -w 0 upload-keystore.jks > keystore.txt` (on Windows PowerShell:
   `[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) > keystore.txt`).
3. GitHub repository → **Settings → Secrets and variables → Actions → New repository secret**, add
   `KEYSTORE_BASE64` (contents of keystore.txt), `KEYSTORE_PASSWORD`, `KEY_ALIAS` (`myparlour`) and
   `KEY_PASSWORD`.
4. Keep `upload-keystore.jks` and the passwords safe (password manager plus an offline copy). They
   can never be recovered, and the Play Store listing depends on them. Never commit them; the
   repository ignores `*.jks` and `key.properties`.

After adding the secrets, uninstall the old app once and install the next build. From then on,
every new build installs over the previous one and keeps the data.

## How the code is organised

```
lib/
  app/        app, router (bottom-nav shell), theme, routes
  core/       design tokens, shared widgets, formatting (money, dates, phone), platform actions
  domain/     models, repository interfaces, business rules (pure Dart, no Flutter)
  data/       local JSON storage, Local* repositories, demo seed, Riverpod providers
  features/   one folder per area: screens, their controller (providers) and widgets
test/         unit, data and widget tests      tool/  screenshot and asset tools
```

Screens → controllers (Riverpod) → repository interfaces → local repositories. Screens never touch
storage. Money is always integer paise; ids are UUIDs; every record carries `parlourId`.

### Moving to Supabase later

Only `lib/data/providers.dart` needs to change: point each repository provider at a Supabase
implementation of the same interface in `lib/domain/repositories/repositories.dart`. Screens,
controllers and business rules stay as they are. Multi-step actions (finalise bill + reduce stock,
record payment + update bill) are single repository methods, which map to database transactions.

## Known limits of this demo

- Data lives only on the phone; uninstalling the app removes it.
- No logo upload, no thermal printer, English only, no iOS build yet.
- "Download PDF" uses the phone's print screen ("Save as PDF").
- Two packages are pinned for build compatibility (`path_provider_android`, `image`); see
  [DECISIONS.md](DECISIONS.md) before upgrading Flutter or packages.
