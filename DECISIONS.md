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

## Phase 2

- **Repository interfaces** live in one file, `domain/repositories/repositories.dart`, together with
  the small input types screens submit (`BillDraft`, `BillLine`, `PaymentInput`). Providers for all
  of them are in `data/providers.dart`; swapping to Supabase means changing only that file.
- **Ids are created by the caller** (UUID v4 via `idGeneratorProvider`). This is what makes a
  double tap harmless: submitting the same bill id or payment id twice records nothing extra.
- **Drafts have no invoice number.** The number is assigned on finalise, so abandoned drafts never
  use up a serial.
- **Invoice serials restart each financial year** (`BBP/2026-27/0001`, then `BBP/2027-28/0001`)
  and only go up within a year, so a number is never reused. "Reset demo data" starts the counters
  again together with the data.
- **Voiding a bill also voids its payments** and puts sold stock back (`voidReversal`). Sales
  reports therefore drop the voided money. A void bill shows paid ₹0 and balance ₹0.
- **One bill per appointment**: a second bill for the same appointment is refused unless the first
  one was voided.
- **"Prices include GST"** (a Settings option in S18) is supported by the calculator: tax is backed
  out of the price instead of added on top. Default stays "prices exclude tax".
- **Tax on a bill is a snapshot**: each invoice stores whether GST was on when it was calculated,
  so changing the setting later does not change old bills.
- **Percent discounts** are stored in basis points (10% = 1000) and rounded half-up to the paisa.
- **Dashboard "still to come"** counts today's appointments that are still *booked*. Checked-in
  customers are already in the parlour, so they are not counted. "Appointments" counts today's
  appointments except cancelled ones.
- **Next appointments** on the dashboard are checked-in ones plus booked ones that have not ended
  yet, earliest first.
- **Top services** are ranked by revenue (line totals of service lines in bills finalised in the
  range). Share % is of all service revenue in that range.
- **Weeks start on Monday** for the "This week" report.
- **Expenses can be deleted** because no other record refers to them.
- **"Start empty"** keeps the parlour profile (name, hours, billing settings) and clears
  everything else, including services and staff.
- **A damaged data file** is renamed to `myparlour_demo.json.broken-<time>` and the demo seed is
  loaded, so the app always opens.
- **Seed content is fixed** (no randomness); only the ids change per reset. Past visits fall on
  Monday–Saturday. Today's six appointments are always created, even on a Sunday, so the demo
  always has something to show. One customer (Pooja Mehta) has a birthday today, so the bell
  shows an alert.
- **Seed product sales**: four past bills include a product (Hair Serum ×2, Face Wash, Shampoo).
  Opening purchases 31 days ago are sized so stock ends at the spec's figures.
- **`path_provider_android` is pinned to 2.2.22.** Version 2.3.x switched to JNI and compiles
  native code with the Android NDK during the APK build; on GitHub Actions that step ran past the
  30-minute limit. 2.2.22 does the same job over a plain platform channel. Revisit when upgrading.
- **Seed partial payments**: the three most recent bills from 3+ days ago that are big enough
  are left with balances of ₹1,000, ₹700 and ₹450 (₹2,150 total). Bills from the last two days
  are fully paid, so "vs yesterday" on the dashboard looks like a normal day.

## Phase 3

- **Illustrations** (`assets/illustrations/`) are original SVGs drawn for this app: the leaf mark,
  the woman's profile with a leaf crown, and the salon tools row. `tool/render_svgs_test.dart`
  renders them to PNG for checking and regenerates the iOS launch images.
- **Native splash**: Android uses a vector leaf mark on blush, both before Android 12
  (`launch_background.xml`) and with the Android 12 splash API (`values-v31`). Night mode uses the
  same blush splash because the app is light-only. The window behind Flutter is blush too, so
  there is no white flash. iOS uses the same leaf as 1×/2×/3× PNGs on a blush launch screen.
- **First launch** means "the data file was just created". Only then does the Welcome screen fade
  in (illustration, then text, 400 ms each). Later launches show it at once with the button focused.
- **Short screens**: on phones under about 760 px tall the Welcome artwork scales down, so the
  "Explore MyParlour" button is visible without scrolling (checked on 360 × 640).
- **Dashboard avatar** uses the first letters of the first two words of the parlour name ("BB").
- **"vs yesterday"** uses an arrow icon rather than a ▲ character, which Manrope does not include.
- **Sheets** (parlour, alerts) open above the bottom navigation bar.
- **Dashboard links to sections built later** (Reports, Customers, Billing open bills, Inventory
  low stock, and the quick actions) already open those sections. For now some of those are still
  the phase placeholder screens; each phase replaces its own.
- **`tool/screenshots_test.dart`** captures phone-sized screenshots with the real fonts for
  design checks. It is not part of the normal `flutter test` run.

## Phase 4

- **Deactivating** customers, services and staff hides them from lists used for new bookings and
  bills; their history stays. Customers: More → Deactivate on the customer screen, and an
  "Inactive (n)" chip on the list shows them. Services: link at the bottom of the edit form.
  Staff: button at the bottom of the staff screen. Each can be reactivated.
- **Customer "More"** opens a small sheet: Share contact, Edit customer, Deactivate/Reactivate.
- **Mobile numbers** are typed after a fixed `+91` and saved as `98765 43210`. Search accepts
  name, part of the number, or a number typed with `+91` / a leading 0.
- **Visits** = completed appointments. **Total spent** = money actually paid (non-void payments on
  non-void bills). **History** shows each appointment once with its bill total if billed, plus
  bills made without an appointment; void bills are hidden.
- **Staff "this month"**: services done and amount billed come from service lines credited to that
  stylist on bills finalised this calendar month.
- **"New appointment" / "Save & book appointment"** open the Appointments tab for now; Phase 5
  connects them to the booking form with the customer filled in.
- **Service GST rate** defaults to the parlour's default rate (18%) and is only used when GST is on.
- **Duration "Custom"** takes any number of minutes.
- **New staff** default to all active services, the parlour's open days and hours.
- **Messages** (snackbars) show for 3 seconds.
- **Storage is behind a small `StoreFile` interface**: the app uses the real file
  (`DiskStoreFile`); widget tests use an in-memory one, because real file writes cannot complete
  on the widget test's fake clock. A separate test saves to a real file, opens a fresh store from
  the same folder and checks everything survived (an app restart).
- **Contact actions** (call, SMS, WhatsApp, share) go through one `ContactActions` service, so
  tests can use a fake. If no app can open the link, a message says so.

## Phase 5

- **Week strip** weeks start on Monday. Dots mark days with any booking (any status). Today has a
  rose outline when it is not the selected day.
- **Filter icon** filters the day by stylist (inactive stylists are listed too, so past days can be
  checked). A dot on the icon shows a filter is on.
- **Filter chips** count the selected day only. "Upcoming" means status *booked*.
- **Stylists offered** are active staff who work that weekday and do every chosen service. If
  nobody does all of them, everyone working that day is offered, so the owner can still book.
- **Next free slot**: the first slot from now (or from opening time on future days) where at least
  one offered stylist is free for the whole duration; the first free stylist is preselected. Once
  the user picks a time or stylist themselves, it is kept.
- **Availability text**: "Free", "Busy until 11:30 AM" (already busy at that time) or "Busy from
  5:30 PM" (another booking starts before this one would end).
- **Overlap**: completed appointments also count as taking the stylist's time; cancelled and
  no-show do not.
- **Closed days**: booking on a day the parlour is normally closed is allowed, with a warning.
- **Past times** are not offered for today; dates before today cannot be chosen.
- **Reschedule** keeps the same customer; only upcoming (booked) appointments can be rescheduled.
- **Cancel** asks for an optional reason (quick chips or typed). Cancelled and no-show
  appointments stay in the day list and the customer's history.
- **Create bill / View bill** on a completed appointment open the Billing tab; Phase 6 opens the
  bill itself.
- **Messages float above bottom action buttons**, so they never hide "Check in" or "Save".
- **Customer history entries** open the appointment.

## Phase 6

- **Open bills** = drafts plus finalised bills with money still due. "All bills" includes paid and
  void ones. The Dashboard's "Pending payments" card opens Open bills.
- **A bill's id is chosen when the Create bill screen opens**, and a payment's id when the Payment
  screen opens. Tapping "Proceed to payment" or "Confirm" twice therefore creates one bill and one
  payment (also covered by tests).
- **Save draft** keeps the bill without a number and without touching stock. Drafts reopen in the
  editor from the bills list; "Proceed to payment" finalises them.
- **Proceed to payment** finalises the bill (number assigned, stock reduced) and opens Payment. A
  ₹0 bill is paid at once and opens the bill instead.
- **Bill from an appointment** fills the customer, services, prices (from the booking) and the
  stylist, and links the bill to the appointment. The customer cannot be changed there. Lines can
  still be added, changed or removed.
- **New lines** added on a bill from an appointment are credited to that appointment's stylist.
- **Products** without a selling price, or out of stock, cannot be added. Quantity is capped at the
  stock on hand; the final check happens when the bill is finalised.
- **Discount** is entered as ₹ or %; percent accepts decimals (12.5%). It cannot exceed the
  subtotal.
- **Lines are removed by swiping left** (as specified), with a hint under the list.
- **Bill view** (opened from the list or "View bill") shows items, totals, paid, balance and the
  payment list, with Record payment, Share, Print, Download and Void.
- **Payment reference** label changes with the method: "UPI ref", "Card last 4" (4 digits) or
  "Reference".
- **Receipt PDF** is A5, uses the app's fonts (₹ sign included), and says "RECEIPT" with "This is a
  payment receipt, not a GST tax invoice" unless GST was on for that bill *and* a GSTIN is set,
  in which case it says "TAX INVOICE" and shows the GSTIN.
- **Share** sends the PDF through the phone's share sheet (WhatsApp, email…). **Print** opens the
  phone's print screen. **Download PDF** opens the same screen, where "Save as PDF" saves the file
  to Downloads (no storage permission needed on any Android version).
- **Void bill** (bill menu) asks first, then voids the bill and its payments and returns sold
  products to stock.
- **`image` is pinned to 4.9.2.** `pdf` 3.12 allows only `archive` < 4.1, but `image` 4.10+ calls
  an `archive` method added later, so it fails to compile. `pdf` 3.13.1 fixes this but needs
  Dart 3.12, newer than the Flutter on the build PC. Revisit when upgrading Flutter.
- **Walk-in bills with no name** show as "Walk-in customer".

## Phase 7

- **Inventory tabs**: Low stock = at or below the alert level but not zero; Out of stock = zero.
  Inactive products appear only on "All items" (dimmed). The Dashboard's "Restock" opens Low stock.
- **Adjust stock**: Stock in adds, Used in service and Damaged/expired remove, and Count correction
  takes the number actually counted and records the difference. The sheet shows the new stock
  before saving and refuses to go below zero.
- **Product stock is only changed through Adjust stock or bills.** The edit form shows the current
  stock but does not change it; a new product's opening stock is recorded as a "Stock in".
- **Expenses** can be edited and deleted (nothing else refers to them). The month arrows do not
  go past the current month. "Paid by" defaults to Cash.
- **Reports**: the period menu offers Today, This week (Mon–Sun), This month and Custom range. For a
  single day the chart shows hours (opening to closing time); otherwise days. The line stops at
  today, so future days are not drawn as ₹0. Net profit is labelled "(estimate)" and turns red
  when negative.
- **Report check**: a test sums the raw sample data with plain loops and compares it with the
  report (sales, expenses, profit, bills, payment methods, top service) on three different dates.
- **More** shows live figures: customers, active staff, services, low-stock count (amber when not
  zero) and this month's expenses.
- **Settings**: Parlour profile, Business hours and Billing & tax open their own forms. The parlour
  **logo** is not editable in this demo: it would need a photo-picker plugin, and the receipt does
  not use a logo yet. GSTIN is checked for 15 letters/numbers. The receipt becomes a "Tax invoice"
  only with GST on and a GSTIN set. Changing the invoice prefix affects new bills only.
- **Start empty** keeps the parlour profile, hours and billing settings and removes everything
  else. **Reset demo data** brings back the full sample data dated around today. Both ask first.
- **App version** in About comes from the installed build (`package_info_plus`), e.g.
  "0.1.0 (12)" where 12 is the GitHub build number.
- **Seed expenses** (changed): rent ₹12,000 on the 1st of this month and salaries on the last day
  of last month, so "This month" shows a believable profit. Both are still within the last 30 days.
- **Dashboard header fix (Phase 7)**: the burgundy band now continues *behind* the top metric cards instead
  of the cards being shifted up over it. Before, the top 56 px of the "Today's sales" and
  "Appointments" cards could not be tapped.

## Phase 8

- **Launcher icon**: the leaf mark on blush. Android 8+ uses an adaptive icon (vector leaf inside
  the safe zone, blush background, plus a monochrome layer for Android 13 themed icons); older
  Android and iOS use PNGs generated by `tool/render_svgs_test.dart --plain-name icons`. iOS icons
  are square and opaque (iOS rounds them).
- **Small phones**: a test opens all 36 screens on a 360 × 640 phone with text at 130% and fails
  on any overflow. It found and fixed three: the More list's right-side figures, the stylist row
  on New appointment ("Free / Busy until" now sits under the name), and the Call/WhatsApp/SMS/More
  row on the customer screen.
- **Tap targets**: choice chips look 40 px tall but have 4 px of invisible tap margin above and
  below, so the tappable area is 48 px (Flutter's Android tap-target check now passes on the main
  screens, together with the label and text-contrast checks).
- **List rows** let their right-hand part shrink (up to half the row) on narrow screens.
- **Start-up errors**: if the data file cannot be opened (e.g. storage full), a friendly screen
  explains it with a "Try again" button instead of the app crashing. In release builds, an
  unexpected error inside a screen shows a short message instead of Flutter's grey error box.
