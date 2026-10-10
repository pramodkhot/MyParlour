# MyParlour — Demo App Build Prompt (Flutter, no login, no database)

> **How to use this file**
> 1. Create an empty GitHub repository (e.g. `myparlour-app`) and open it in VS Code.
> 2. Put this file in the repo root as `MYPARLOUR_DEMO_BUILD_PROMPT.md`.
> 3. Put the design image in the repo root as `design_reference.png`.
> 4. Open Claude Code in VS Code and say:
>    **"Read MYPARLOUR_DEMO_BUILD_PROMPT.md and build the app phase by phase. Start with Phase 1."**
> 5. Push to GitHub. The workflow in Section 12 builds the APK automatically. Download it from the **Actions** tab (or from **Releases** when you push a version tag).

---

## 1. Prompt for Claude Code

You are a senior Flutter developer and mobile UI designer. Build **MyParlour**, a beauty parlour management app for Android and iOS, as a **demo build (v0.1)**.

This demo is used to show the app to parlour owners and collect feedback. It must look premium, feel real, and work end to end. It has:

- **No login.** The app opens on a welcome screen; one tap takes the user into the app.
- **No server or cloud database.** All data is stored on the phone in a local JSON file, preloaded with realistic sample data.
- **Real business logic.** Bills, discounts, payments, appointment statuses, stock and reports are calculated by real, tested Dart code, never hardcoded in screens.

Later (not now) the app will get Supabase login and a cloud PostgreSQL database. Build it so that change replaces only the data layer: screens and logic must not need rewriting.

Work rules:

- Read this whole file and look at `design_reference.png` before writing code. If the image is missing, ask for it.
- Work phase by phase (Section 11). After each phase, run `flutter analyze` and `flutter test`, fix all errors, then report: files changed, what works, test results, open issues.
- Small files with one job each. No giant files. No widget calls storage directly.
- No empty `onPressed` on any visible button. If a feature is not in this demo, don't show the button.
- Never claim something builds or works without running it.
- Make sensible low-cost choices for anything unclear and record them in `DECISIONS.md`. Ask only if truly blocked.

---

## 2. Product summary

| Item | Value |
|---|---|
| App name (launcher + splash) | MyParlour |
| Android application ID | `com.creativeandroworld.myparlour` (change in `DECISIONS.md` if needed) |
| Platforms | Android (demo via APK), iOS (later via TestFlight) |
| Users in demo | One person, acting as owner. No roles yet. |
| Currency / locale | INR, Indian number grouping (₹1,23,456), `en_IN`, time zone of the phone |
| Demo parlour | "Beauty Bliss Parlour", owner "Kavita" (both editable in Settings) |

Demo-mode rules:

- A small **"Demo"** pill shows in the Settings screen and on the welcome screen. Not on every screen.
- Settings has **"Reset demo data"** (with confirmation) to restore the original sample data.
- Sample data dates are **relative to today**, so the demo always looks current (today's appointments are always today).

---

## 3. Tech stack

Use the current stable Flutter and Dart 3. Keep dependencies minimal:

| Need | Package |
|---|---|
| State | `flutter_riverpod` |
| Navigation | `go_router` (bottom-nav shell with `StatefulShellRoute`) |
| Local file location | `path_provider` |
| IDs | `uuid` (v4 now; fine for later sync) |
| Formatting | `intl` |
| Charts | `fl_chart` |
| PDF receipt | `pdf` + `printing` |
| Share / call / WhatsApp / SMS | `share_plus`, `url_launcher` |
| SVG illustration | `flutter_svg` |
| Tests | `flutter_test`, `mocktail` |

Fonts: **Playfair Display** (headings) and **Manrope** (body), both OFL-licensed from Google Fonts. Bundle the `.ttf` files in `assets/fonts/` (no runtime downloading). If you cannot download them in this environment, use the `google_fonts` package temporarily and note it in `DECISIONS.md`.

No Firebase, no analytics, no ads, no network calls.

---

## 4. Architecture (built so Supabase can replace storage later)

```
Screens (widgets)  →  Controllers (Riverpod)  →  Repository interfaces  →  Local* repositories (now)
                                                                       →  Supabase* repositories (later)
```

- `domain/` holds pure Dart models, repository **interfaces** and services such as `InvoiceCalculator`, `AppointmentRules`, `ReportService`. No Flutter imports.
- `data/local/` holds `LocalStore` (loads/saves one JSON file `myparlour_demo.json` in the app documents folder, writes atomically: write temp file, then rename) and `Local*Repository` classes implementing the interfaces.
- `data/demo/demo_seed.dart` builds the sample dataset (Section 7).
- One Riverpod provider per repository. Swapping to Supabase later = changing those providers only.
- Every multi-step action (create bill + reduce stock, record payment + update bill) is one repository method that updates memory and saves the file once, so it fully happens or not at all.

Folder structure:

```
lib/
  main.dart
  app/            app.dart, router.dart, theme.dart
  core/
    design/       colors.dart, spacing.dart, typography.dart
    widgets/      shared components (Section 8)
    format/       money.dart, dates.dart, phone.dart
    validation/
  domain/
    models/       parlour, customer, service, staff, appointment, invoice, payment, product, stock_movement, expense
    repositories/ interfaces
    services/     invoice_calculator.dart, appointment_rules.dart, report_service.dart
  data/
    local/        local_store.dart, local_*_repository.dart
    demo/         demo_seed.dart
  features/
    welcome/ dashboard/ appointments/ customers/ billing/ payments/
    staff/ inventory/ services/ expenses/ reports/ more/ settings/
assets/
  fonts/  illustrations/welcome_woman.svg  illustrations/salon_tools.svg
test/
.github/workflows/build-apk.yml
```

---

## 5. Data model (same shape as the future database)

All ids are UUID strings. **All money is `int` paise** (₹499.00 = 49900); never `double` for money. Every record carries `parlourId`. Timestamps stored as ISO-8601 UTC strings; shown in local time.

| Model | Fields |
|---|---|
| Parlour | id, name, ownerName, phone, area, address?, logoPath?, currency "INR", openDays, openTime, closeTime, slotMinutes, invoicePrefix, taxEnabled, defaultTaxRateBp, gstin? |
| Customer | id, parlourId, name, phone (string), email?, birthday (day+month)?, notes?, isActive, createdAt, lastVisitAt? |
| ServiceItem | id, parlourId, name, category, pricePaise, durationMin, taxRateBp, isActive |
| Staff | id, parlourId, name, phone, roleTitle, serviceIds, workingDays, startTime, endTime, isActive |
| Appointment | id, parlourId, customerId?, walkInName?, staffId, startsAt, endsAt, status (booked, checkedIn, completed, cancelled, noShow), notes?, cancelReason?, services: list of {serviceId, name, pricePaise, durationMin} snapshot |
| Invoice | id, parlourId, invoiceNo, customerId?, walkInName?, appointmentId?, status (draft, finalised, partiallyPaid, paid, void), items, subtotal, discount, taxable, tax, total, paid, balance, createdAt, finalisedAt? |
| InvoiceItem | id, type (service, product), refId, name, unitPricePaise, qty, itemDiscountPaise, allocatedDiscountPaise, taxRateBp, taxPaise, lineTotalPaise, staffId? |
| Payment | id, parlourId, invoiceId, amountPaise, method (cash, upi, card, other), reference?, note?, receivedAt, isVoid |
| Product | id, parlourId, name, category?, unit (pcs, ml, g), sellingPricePaise?, costPricePaise?, stockQty, lowStockAt, isActive |
| StockMovement | id, parlourId, productId, qtyChange, reason (purchase, sale, usedInService, damaged, correction, voidReversal), invoiceId?, note?, createdAt |
| Expense | id, parlourId, category, amountPaise, spentOn (date), method?, note? |

Never hard-delete anything that history refers to: deactivate customers, services, staff and products; void bills and payments.

---

## 6. Business rules (put in `domain/services`, unit-test all of them)

**Invoice calculation** (prices exclude tax by default):

1. Line gross = unit price × qty.
2. Line net = gross − item discount (not below 0).
3. Subtotal = Σ line net.
4. Invoice discount (₹ or %) split across lines in proportion to line net; rounding leftovers go to the largest lines so the split adds up exactly. Discount cannot exceed subtotal.
5. Line taxable = line net − its share; line tax = taxable × rate ÷ 10,000, rounded half-up. Tax only when GST is enabled in Settings.
6. Total = Σ taxable + Σ tax. Paid = Σ non-void payments. Balance = total − paid.
7. Status: paid 0 → finalised; between → partiallyPaid; paid = total → paid; voided → void. A ₹0 bill is paid at once.

**Invoice number**: `{prefix}/{financial year}/{4-digit serial}`, e.g. `BBP/2026-27/0042`; financial year runs April–March; serial never repeats.

**Payments**: amount > 0 and ≤ balance; method required; default amount = balance; default method = Cash. UPI means "record a UPI payment" — the app never claims to verify it.

**Appointment statuses**: booked → checkedIn, cancelled, noShow; checkedIn → completed, cancelled; completed, cancelled, noShow are final. Only one bill per appointment (opening "Create bill" again opens the existing one).

**Overlap**: when the same stylist already has an overlapping booking, show a sheet with the clash and two buttons, "Pick another time" and "Book anyway".

**Stock**: selling a product on a bill reduces stock and writes a `sale` movement in the same save; stock can't go below 0 (show a clear error); voiding a bill restores stock with `voidReversal`.

**Reports** (for Today / This week / This month / Custom range):
- Sales = non-void payments received in the range (money actually collected).
- Bills = invoices finalised in the range, excluding void.
- Expenses = expenses dated in the range.
- Net profit (estimate) = sales − expenses. Always labelled "estimate".

**Dashboard**: today's sales (payments today), today's appointments (with "x still to come"), pending payments (sum of balances of open bills + count), active customers, low-stock products (stockQty ≤ lowStockAt).

**Phone numbers**: accept `+91`, spaces, leading 0; store as entered, normalise to the last 10 digits for duplicate checks. Duplicate → warning "Already saved as Priya Sharma – Open", never blocks saving.

---

## 7. Demo seed data (`demo_seed.dart`)

Create on first launch and on "Reset demo data". All dates relative to today.

- **Parlour**: Beauty Bliss Parlour · owner Kavita · +91 98765 00000 · area "MG Road, Pune" · Mon–Sat 10:00–20:00 · 30-min slots · prefix `BBP` · GST off.
- **Services (10)**: Haircut ₹500/30m · Hair Spa ₹800/60m · Smoothening ₹2,500/90m · Hair Colour ₹1,500/90m · Facial ₹1,200/60m · Cleanup ₹600/30m · Threading ₹50/10m · Waxing (full arms) ₹400/30m · Manicure ₹600/45m · Pedicure ₹700/45m. Categories: Hair, Skin, Nails, Waxing.
- **Staff (4)**: Anita (Senior Beautician), Riya (Beautician), Meena (Beautician), Pooja (Junior, inactive).
- **Customers (14)**: Indian names with distinct 10-digit numbers, a few with birthdays this month and notes (e.g. "Prefers less heat in smoothening").
- **Appointments**: today 6 (2 completed and billed, 1 checked in, 3 booked), next 7 days 8 booked, past 30 days ~40 completed, 2 cancelled, 1 no-show.
- **Invoices & payments**: one paid invoice per past completed appointment; 3 partially paid (pending balance ≈ ₹2,150 total); mixed methods (≈60% UPI, 30% Cash, 10% Card).
- **Products (8)**: Hair Serum (2 left, alert at 3), Face Cream (3 left), Shampoo 15, Conditioner 8, Hair Colour 0, Wax Strips 40, Nail Polish 12, Face Wash 6.
- **Expenses (last 30 days)**: Rent, Salary ×3, Electricity, Products purchase, Tea/Snacks ×6.

Reports and charts must have visible data for this month from this seed.

---

## 8. Design system

Visual style: premium, feminine, calm. Blush backgrounds, white rounded cards, burgundy actions, serif headings. Follow `design_reference.png`; where this file and the image differ, **this file wins**.

**Colours**

| Token | Hex | Use |
|---|---|---|
| primary | `#A92750` | Primary buttons, header band, active nav, links |
| primaryDark | `#79142F` | Pressed states, app title |
| rose | `#D75D85` | Accents, illustration details |
| blush | `#FFF6F7` | Screen background |
| blushDeep | `#FBE3EA` | Decorative circles, selected chip background `#FCE8EE` |
| surface | `#FFFFFF` | Cards, inputs, sheets |
| text | `#282126` | Main text |
| textMuted | `#6F6268` | Labels, secondary text (passes contrast on white) |
| border | `#F0E1E5` | Card and input borders; dividers `#F6ECEF` |
| success | `#1F7550` on `#E3F3EB` | "Paid", "Checked in", "In stock" |
| warning | `#8A5414` on `#FDF1E1` | "Low stock", "Partially paid" |
| error | `#B3263A` on `#FBE6E8` | "Out of stock", "Cancelled", errors |
| info chip | `#8E1F43` on `#FCE8EE` | "Upcoming" |

White text only on `primary` or `primaryDark`.

**Type**: Playfair Display 700 for screen titles (24–30), greetings and the logo; Manrope for everything else — body 15, labels 13 (600), captions 12, chips 11–12 (700), big numbers 24 (700).

**Shape and spacing**: cards radius 18, inputs and buttons radius 14, chips fully rounded, bottom sheets radius 24 top. Spacing 4/8/12/16/20/24/32; screen padding 16–20. Cards: 1 px border + soft shadow `rgba(121,20,47,0.08)` blur 22 y 8.

**Touch and text**: every tap target ≥ 48 px; respect safe areas; support text scale up to 130% without overflow; works on 360 px wide phones.

**Icons**: one outlined icon set (Material Symbols Rounded via Flutter's `Icons.*_outlined` / `*_rounded` is fine), 20–24 px. **No emoji** anywhere.

**Shared widgets** (`core/widgets`): `AppTopBar`, `HeaderBand` (burgundy header with rounded bottom), `MetricCard`, `PrimaryButton` (burgundy, 54 high, white bold text), `SecondaryButton` (white, burgundy 1.5 px border), `AppTextField` (label above, icon left, 52 high, burgundy border on focus), `SearchField`, `StatusChip`, `MoneyText`, `QtyStepper`, `ChoiceChips`, `SectionHeader` (title + "See all" link), `ListRowCard`, `EmptyState` (small line illustration + one sentence + one button), `ConfirmDialog`, `AvatarInitials` (pink circle, burgundy initials), `BottomNav`.

---

## 9. Screens (design + behaviour)

Bottom navigation (4 tabs, white bar, burgundy active icon inside a pink pill): **Dashboard · Appointments · Billing · More**. Every screen opened from More keeps **More** highlighted.

Field rules for every form: only the fields marked * are required; optional ones say "(optional)"; extra fields hide under "+ More details"; correct keyboard per field; inline plain-language errors; one full-width primary button at the bottom named after the result ("Save customer").

### S1 — Welcome (splash), no login

Layout top to bottom on `blush`:
- Two soft decorative circles (`blushDeep`) top-right and left, behind content.
- **Illustration** (`assets/illustrations/welcome_woman.svg`): an **original** single-line-art drawing of a woman's profile with closed eyes and a crown of leaves flowing from her hair, burgundy strokes (`#A92750`, 1.5–2 px) with a few rose (`#D75D85`) leaves. About 220 px tall. Create the SVG yourself in this spirit; do not copy any existing artwork.
- App name **"MyParlour"** in Playfair Display 36, `primaryDark`, with a small rose leaf mark before "My".
- Tagline: **"Manage your parlour business easily"** (Playfair 20, `primary`, centred, two lines max).
- Sub-text (Manrope 14, `textMuted`): "Appointments, billing, customers, staff, inventory & reports — all in one place."
- Row of **salon tools** line drawing (`salon_tools.svg`): comb, brush, cream jar, pump bottle, scissors — thin burgundy/rose outlines, about 70 px tall.
- **PrimaryButton "Explore MyParlour"** → Dashboard (replace the route so Back does not return here).
- Below it a small "Demo" pill + text "Sample data · no sign-in needed".
- First launch: gentle fade-in (400 ms) of illustration then text. Later launches: still show this screen (it is the demo's front door) but the button is focused immediately. No Login button in this demo.
- Native splash (Android 12 splash API / iOS launch screen): blush background with the leaf mark only, so there is no white flash.

### S2 — Dashboard

- **Header band** (`primary`, rounded bottom 28): initials avatar "BB" (translucent white circle), parlour name (white, 17 bold) with a down-chevron (opens a sheet showing the parlour name and "More branches in the full version" — no switching in demo), today's date ("Tuesday, 14 May" format), bell button (opens an Alerts sheet listing low-stock items and today's birthdays; dot shows when there are alerts). Greeting in Playfair 25 white: "Good morning, Kavita" (morning/afternoon/evening by time).
- **Metric cards** 2×2, overlapping the header by ~56 px: Today's sales (₹, "▲/▼ x% vs yesterday" in success/error colour), Appointments (count, "x still to come"), Pending payments (₹, "x bills due" in warning colour), Customers (count, "Active clients"). Each card has a small burgundy outline icon top-right and opens: Reports(today) / Appointments(today) / Billing(open bills filter) / Customers.
- **Quick actions** (4): New appointment (filled burgundy tile), Add customer, Create bill, Add expense (white tiles with border). 56 px tiles, label below.
- **Next appointments**: up to 3 rows in one card — time (burgundy bold) + "AM · 1 h 30", customer name, "services · stylist", status chip. "See all" → Appointments.
- **Low stock**: card with product rows and "x left" warning chips; "Restock" → Inventory (Low stock tab).
- Pull to refresh. Empty states when there is no data.

### S3 — Appointments

- Top bar "Appointments" with calendar icon (date picker) and filter icon.
- Month label + **week strip** (7 days, selected day in burgundy pill, dots under days with bookings), left/right arrows change week.
- Scrollable filter chips: All · Upcoming · Checked in · Completed · Cancelled · No-show, each with count.
- List of **AppointmentCard**: time column, customer name (or "Walk-in · name"), services, stylist, status chip. Tap → S4.
- FAB (burgundy circle, plus icon) → S5 with the selected date.
- Empty day: "No appointments on this day" + "Book appointment".

### S4 — Appointment details

- Customer block: avatar initials, name, phone, Call and WhatsApp icon buttons.
- Rows with icons: date, time range, stylist, **status chip (read-only, no dropdown)**.
- Services card: numbered services with prices and total.
- Notes card.
- Bottom actions depend on status: booked → "Reschedule" (secondary) + "Check in" (primary); checkedIn → "Complete" (primary); completed → "Create bill" or "View bill". Overflow menu (⋯): Cancel (asks reason), Mark no-show, Open customer.

### S5 — New / edit appointment

Fields: Customer* (search name/phone, "+ New" opens S8 as a sheet, "Walk-in" link switches to Walk-in name* + mobile (optional)) · Services* (search + removable chips) · Date* (today default) · Time* (slot chips from business hours, next free slot preselected) · Stylist* (list with "Free" / "Busy until 11:30"; first free stylist preselected; inactive hidden) · Summary card (tinted): "Duration 1 h 30 min · ends 11:30 AM", "Estimate ₹3,000" · Notes (optional). Button: **"Book appointment"**. Overlap sheet per Section 6.

### S6 — Customers

Search field ("Search name or phone"), sort chip (Recent visit / A–Z), list rows: initials avatar, name, phone, "x visits · last 12 May". FAB/plus → S8. Empty state for no matches.

### S7 — Customer details

Header: large initials avatar, name, phone, edit icon. Action row of 4 round buttons: Call, WhatsApp, SMS, More (Share contact). Tabs: **History** (appointments and bills with date, services, final amount, status) · **Details** (phone, email, birthday, customer since, total spent) · **Notes** (editable). Bottom: PrimaryButton "+ New appointment". WhatsApp opens `https://wa.me/91XXXXXXXXXX`; if no app can open a link, show a snackbar.

### S8 — Add / edit customer

Name* · Mobile number* (+91 fixed prefix, number pad, duplicate warning banner in warning colours with "Open") · Birthday (optional, day/month) · Notes (optional, multi-line) · "+ More details" → Email, Anniversary. Buttons: **"Save customer"** (primary) and "Save & book appointment" (secondary).

### S9 — Billing tab and Create bill

Billing tab home: segmented "Open bills / All bills", list of bills (number, customer, date, total, status chip), FAB "New bill".

Create bill screen:
- Customer row with "Change" (or Walk-in); prefilled when opened from an appointment.
- Items list: name, "Stylist: Anita" caption, price, `QtyStepper` (− 1 +), swipe to remove. "+ Add service or product" opens a searchable sheet with Services / Products tabs.
- Discount (optional): ₹ / % toggle + amount field.
- Totals card (tinted): Subtotal, Discount (−), GST (only when tax on), divider, **Total** (Manrope 18 bold).
- Buttons: "Save draft" (secondary, narrow) + **"Proceed to payment"** (primary, wide).

### S10 — Record payment

- Balance card: Bill total · Already received · divider · **Balance due** (bold).
- Payment method* chips: Cash (default) · UPI · Card · Other. Under UPI: "Records the payment; the app does not verify UPI."
- Amount received* (₹, prefilled with balance, caption "Full balance" or "Partial").
- Reference (optional; label changes to "UPI ref / Card last 4") · Note (optional).
- Button shows the amount live: **"Confirm ₹1,700"**. Disabled while saving (no double tap).

### S11 — Payment success

Green check circle, "Payment recorded", "₹1,700 by Cash · 14 May, 4:12 PM", receipt card (invoice number, status chip, balance). Buttons: **"Share receipt on WhatsApp"** (primary; shares the PDF via the share sheet), "Print receipt" (`printing`), "Download PDF". Links: "Book next visit", "Back to dashboard".

PDF receipt (A5 or 80 mm-friendly): parlour name, area, phone, invoice number, date, customer, items table, discount, tax (if on), total, paid, balance, payment method, footer "Thank you! Visit again." Clearly not marked as a GST tax invoice unless GST is on.

### S12 — Staff (from More)

List rows: initials or photo, name, role, phone, status chip (Active green / Inactive grey); inactive grouped at bottom. Search + plus. Tap → staff detail: details, today's and upcoming appointments, this month's services done and amount billed, Activate/Deactivate. Form: Name* · Mobile* · Role (chips: Senior Beautician, Beautician, Junior, Receptionist) · Services they do (tick list, all ticked) · Working days + hours (parlour hours default).

### S13 — Inventory (from More)

Tabs: All items · Low stock · Out of stock (with counts). Search + plus. Rows: product line-icon tile, name, "Stock: 2", price, chip (In stock / Low stock / Out of stock). Tap → product detail with stock movement history and **"Adjust stock"** sheet: Type* (Stock in, Used in service, Damaged/expired, Count correction) · Quantity* (stepper) · Note. Product form: Name* · Opening stock* + unit chips (pcs/ml/g) · Low-stock alert at* (default 2) · Selling price (optional) · More details: category, cost price.

### S14 — Reports (from More)

Period dropdown: Today · This week · This month (default) · Custom range. Cards 2×2: Total sales, Total expenses, **Net profit (estimate)**, Total bills. **Sales overview** line chart (`fl_chart`, burgundy line with dots, light pink area, day labels). **Top services** list with share % and burgundy progress bars. **Payment methods** small bar or donut (Cash / UPI / Card / Other). Empty state when the range has no data.

### S15 — More

Title "More", subtitle "Beauty Bliss Parlour · Owner". Rows with icon, label, right-side meta and chevron: Customers (count) · Staff (x active) · Services · Inventory (x low) · Expenses · Reports · Settings.

### S16 — Services (from More)

Grouped by category; rows with name, duration, price; inactive dimmed. Form: Service name* · Category* (chips, can add new) · Price* · Duration* (chips 15/30/45/60/90/120 or custom) · More details: description, GST rate.

### S17 — Expenses (from More)

Month selector, total at top, list grouped by date. Form: Amount* (first, large) · Category* (chips: Rent, Salary, Products, Electricity, Tea/Snacks, Other) · Date* (today) · Paid by (chips, Cash default) · Note.

### S18 — Settings (from More)

Sections: **Parlour profile** (name, owner, phone, area, address, logo) · **Business hours** (days, open/close, slot) · **Billing & tax** (invoice prefix, GST on/off, GSTIN, default rate, prices include GST, receipt footer) · **Demo** ("Demo" pill, **Reset demo data** with confirm dialog, "Start empty" option that clears all data for a blank-parlour demo) · **About** (app version from build, "Sign-in and cloud backup arrive in the full version").

---

## 10. Navigation map

```
Welcome ──▶ Shell (bottom nav)
            ├─ Dashboard ─▶ Alerts sheet, Reports, Appointments, Billing (open), Customers, quick actions
            ├─ Appointments ─▶ Appointment details ─▶ Reschedule (S5), Create/View bill (S9) ─▶ Payment (S10) ─▶ Success (S11)
            │                └─ New appointment (S5) ─▶ Add customer sheet (S8)
            ├─ Billing ─▶ Create bill (S9) ─▶ Payment (S10) ─▶ Success (S11)
            └─ More ─▶ Customers ─▶ Customer details ─▶ New appointment / Edit customer
                     ├─ Staff ─▶ Staff details / form
                     ├─ Services, Inventory ─▶ Product / Adjust stock
                     ├─ Expenses, Reports, Settings
```

System Back always goes up one level; leaving a half-filled form asks "Discard changes?".

---

## 11. Build phases (do them in order)

| Phase | Build | Done when |
|---|---|---|
| 1 | `flutter create` (org `com.creativeandroworld`, name `myparlour`), app name "MyParlour", fonts, theme, shared widgets, router + bottom nav, **GitHub Actions workflow (Section 12)** | App runs; all 4 tabs open; `flutter analyze` clean; workflow file present |
| 2 | Models, `LocalStore`, repositories, demo seed, `InvoiceCalculator`, `AppointmentRules`, `ReportService` + unit tests | All rule tests in Section 6 pass |
| 3 | Welcome screen with SVG illustrations, native splash, Dashboard | Dashboard shows seed figures that match the data |
| 4 | Customers (S6–S8), Services (S16), Staff (S12) | Create, edit, deactivate, search all work and survive app restart |
| 5 | Appointments (S3–S5) with overlap check and status flow | Book → check in → complete works; cancelled stays in history |
| 6 | Billing, Payment, Success, PDF/share/print (S9–S11) | Bill with discount totals correctly; two partial payments close it; stock drops for products; double tap creates nothing extra |
| 7 | Inventory, Expenses, Reports, More, Settings incl. Reset demo data | Reports match a hand check of the seed; reset restores data |
| 8 | Polish: empty/error states, text scaling, 360 px phones, launcher icon (burgundy leaf mark on blush), widget tests, README | `flutter test` green; release APK built by GitHub Actions installs on a real phone |

Tests required: invoice maths (discount split, rounding, tax on/off, zero bill), payment limits and statuses, appointment transitions and overlap, stock never negative and void reversal, report figures for a fixed dataset, phone normalisation, `LocalStore` save/load round-trip, and widget tests for Welcome → Dashboard and the bill → payment → success flow.

---

## 12. GitHub Actions — build the APK

Create `.github/workflows/build-apk.yml` with the content below.

What it does:
- Runs on every push to `main`, on pull requests, and manually (**Actions → Build APK → Run workflow**).
- Runs `flutter analyze` and `flutter test`, then builds a release APK.
- Uploads the APK as a downloadable **artifact** (Actions → the run → Artifacts → `myparlour-apk`).
- When you push a tag like `v0.1.0`, it also creates a **GitHub Release** with the APK attached.
- Uses your signing key if the secrets exist; otherwise falls back to the debug key so the build still works.

```yaml
name: Build APK

on:
  push:
    branches: [main]
    tags: ['v*']
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: write   # needed to create a Release on tag pushes

concurrency:
  group: build-apk-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 30

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Java 17
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      - name: Install packages
        run: flutter pub get

      - name: Analyze
        run: flutter analyze

      - name: Test
        run: flutter test

      - name: Set up signing key (only if secrets exist)
        env:
          KEYSTORE_BASE64: ${{ secrets.KEYSTORE_BASE64 }}
          KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
        if: ${{ env.KEYSTORE_BASE64 != '' }}
        run: |
          echo "$KEYSTORE_BASE64" | base64 --decode > android/app/upload-keystore.jks
          cat > android/key.properties <<EOF
          storePassword=$KEYSTORE_PASSWORD
          keyPassword=$KEY_PASSWORD
          keyAlias=$KEY_ALIAS
          storeFile=upload-keystore.jks
          EOF

      - name: Build release APK
        run: flutter build apk --release --build-number=${{ github.run_number }}

      - name: Rename APK
        run: |
          mkdir -p dist
          cp build/app/outputs/flutter-apk/app-release.apk "dist/MyParlour-demo-${{ github.run_number }}.apk"

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: myparlour-apk
          path: dist/*.apk
          retention-days: 30

      - name: Create GitHub Release (tags only)
        if: startsWith(github.ref, 'refs/tags/v')
        uses: softprops/action-gh-release@v2
        with:
          files: dist/*.apk
          generate_release_notes: true
```

**Android signing setup (Claude Code must do this in Phase 1):**

In `android/app/build.gradle.kts` (or `build.gradle` if the project uses Groovy), load `android/key.properties` if it exists and use it for the `release` signing config; if it does not exist, keep signing release builds with the debug key. Add these lines to `.gitignore`:

```
android/key.properties
android/app/upload-keystore.jks
*.jks
```

**Why the signing key matters:** without a fixed key, each GitHub build is signed with a different temporary debug key, so installing a new APK over an old one fails with "App not installed" and testers must uninstall first (losing their demo data). Create one key now and reuse it forever:

1. On your computer (needs Java): `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias myparlour`
2. Convert it: `base64 -w 0 upload-keystore.jks > keystore.txt` (macOS: `base64 -i upload-keystore.jks -o keystore.txt`).
3. GitHub repo → **Settings → Secrets and variables → Actions → New repository secret**, add: `KEYSTORE_BASE64` (contents of keystore.txt), `KEYSTORE_PASSWORD`, `KEY_ALIAS` (`myparlour`), `KEY_PASSWORD`.
4. Keep `upload-keystore.jks` and the passwords in a safe place (password manager + offline backup). If you lose them you can never update the app on the Play Store under the same listing.

Never commit the keystore or passwords to the repository.

**Installing the APK on a phone:** download it from the Actions artifact or Release, open it on the Android phone, allow "Install unknown apps" for the browser or file manager when asked, then install.

---

## 13. Not in this demo (planned for the full version)

Login and accounts · Supabase cloud database and sync between phones · staff roles and permissions · subscription/licence · phone OTP · Bluetooth thermal printer · Hindi/Marathi · iOS TestFlight builds. Keep the code ready for these (repository interfaces, ids, paise, `parlourId`), but don't build them now.
