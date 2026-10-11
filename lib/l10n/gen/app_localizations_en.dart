// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MyParlour';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navAppointments => 'Appointments';

  @override
  String get navBilling => 'Billing';

  @override
  String get navMore => 'More';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaveChanges => 'Save changes';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDone => 'Done';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonClose => 'Close';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonOptional => '(optional)';

  @override
  String get commonClearSearch => 'Clear search';

  @override
  String commonClearField(String label) {
    return 'Clear $label';
  }

  @override
  String get commonDecrease => 'Decrease';

  @override
  String get commonIncrease => 'Increase';

  @override
  String get commonMoreDetails => 'More details';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonNone => 'None';

  @override
  String get commonNotAdded => 'Not added';

  @override
  String get commonInactive => 'Inactive';

  @override
  String get commonActive => 'Active';

  @override
  String get commonDeactivate => 'Deactivate';

  @override
  String get commonReactivate => 'Reactivate';

  @override
  String get commonWalkIn => 'Walk-in';

  @override
  String commonWalkInNamed(String name) {
    return 'Walk-in · $name';
  }

  @override
  String get commonWalkInCustomer => 'Walk-in customer';

  @override
  String get commonGuest => 'Guest';

  @override
  String get commonCustomer => 'Customer';

  @override
  String get commonStylist => 'Stylist';

  @override
  String commonNoAppFor(String what) {
    return 'No app on this phone can open $what.';
  }

  @override
  String get commonAppCalls => 'calls';

  @override
  String get commonAppWhatsApp => 'WhatsApp links';

  @override
  String get commonAppMessages => 'messages';

  @override
  String get commonAppSharing => 'sharing';

  @override
  String get commonCall => 'Call';

  @override
  String get commonWhatsApp => 'WhatsApp';

  @override
  String get commonSms => 'SMS';

  @override
  String get commonFillRequired => 'Please fill the fields marked *.';

  @override
  String commonMinutes(int count) {
    return '$count min';
  }

  @override
  String commonHours(int count) {
    return '$count h';
  }

  @override
  String commonHoursMinutes(int hours, String minutes) {
    return '$hours h $minutes';
  }

  @override
  String get discardTitle => 'Discard changes?';

  @override
  String get discardMessage =>
      'What you entered on this screen will not be saved.';

  @override
  String get discardConfirm => 'Discard';

  @override
  String get discardKeep => 'Keep editing';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusCheckedIn => 'Checked in';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusNoShow => 'No-show';

  @override
  String get billStatusDraft => 'Draft';

  @override
  String get billStatusUnpaid => 'Unpaid';

  @override
  String get billStatusPartiallyPaid => 'Partially paid';

  @override
  String get billStatusPaid => 'Paid';

  @override
  String get billStatusVoid => 'Void';

  @override
  String get payCash => 'Cash';

  @override
  String get payUpi => 'UPI';

  @override
  String get payCard => 'Card';

  @override
  String get payOther => 'Other';

  @override
  String get payRefUpi => 'UPI ref';

  @override
  String get payRefCard => 'Card last 4';

  @override
  String get payRefOther => 'Reference';

  @override
  String get stockInStock => 'In stock';

  @override
  String get stockLow => 'Low stock';

  @override
  String get stockOut => 'Out of stock';

  @override
  String stockLeft(int count) {
    return '$count left';
  }

  @override
  String get reasonPurchase => 'Stock in';

  @override
  String get reasonSale => 'Sold on bill';

  @override
  String get reasonUsedInService => 'Used in service';

  @override
  String get reasonDamaged => 'Damaged / expired';

  @override
  String get reasonCorrection => 'Count correction';

  @override
  String get reasonVoidReversal => 'Bill voided (returned)';

  @override
  String get periodToday => 'Today';

  @override
  String get periodThisWeek => 'This week';

  @override
  String get periodThisMonth => 'This month';

  @override
  String get periodCustom => 'Custom range';

  @override
  String get unitPcs => 'pcs';

  @override
  String get unitMl => 'ml';

  @override
  String get unitG => 'g';

  @override
  String get catHair => 'Hair';

  @override
  String get catSkin => 'Skin';

  @override
  String get catNails => 'Nails';

  @override
  String get catWaxing => 'Waxing';

  @override
  String get expRent => 'Rent';

  @override
  String get expSalary => 'Salary';

  @override
  String get expProducts => 'Products';

  @override
  String get expElectricity => 'Electricity';

  @override
  String get expTeaSnacks => 'Tea/Snacks';

  @override
  String get expOther => 'Other';

  @override
  String get roleSeniorBeautician => 'Senior Beautician';

  @override
  String get roleBeautician => 'Beautician';

  @override
  String get roleJunior => 'Junior';

  @override
  String get roleReceptionist => 'Receptionist';

  @override
  String get prodCatHairCare => 'Hair care';

  @override
  String get prodCatSkinCare => 'Skin care';

  @override
  String get errCustomerNameRequired => 'Enter the customer name.';

  @override
  String get errServiceNameRequired => 'Enter the service name.';

  @override
  String get errPriceNegative => 'Price cannot be negative.';

  @override
  String get errServiceDurationRequired => 'Choose how long the service takes.';

  @override
  String get errStaffNameRequired => 'Enter the staff member’s name.';

  @override
  String get errProductNameRequired => 'Enter the product name.';

  @override
  String get errLowStockNegative => 'Low-stock alert cannot be negative.';

  @override
  String get errOpeningStockNegative => 'Opening stock cannot be negative.';

  @override
  String get errAmountZero => 'Enter an amount more than ₹0.';

  @override
  String get errCategoryRequired => 'Choose a category.';

  @override
  String get errAppointmentNoServices => 'Choose at least one service.';

  @override
  String get errAppointmentNoClient => 'Choose a customer or enter a name.';

  @override
  String get errAppointmentEndBeforeStart =>
      'End time must be after start time.';

  @override
  String get errAppointmentFinished =>
      'Finished appointments cannot be changed.';

  @override
  String errStatusChange(String from, String to) {
    return 'This appointment cannot change from $from to $to.';
  }

  @override
  String get errCustomerNotFound => 'Customer not found.';

  @override
  String get errServiceNotFound => 'Service not found.';

  @override
  String get errStaffNotFound => 'Staff member not found.';

  @override
  String get errAppointmentNotFound => 'Appointment not found.';

  @override
  String get errBillNotFound => 'Bill not found.';

  @override
  String get errProductNotFound => 'Product not found.';

  @override
  String get errBillProductMissing =>
      'A product on this bill no longer exists.';

  @override
  String get errBillNoLines => 'Add at least one service or product.';

  @override
  String errLineQtyInvalid(String name) {
    return 'Quantity for $name must be at least 1.';
  }

  @override
  String errLinePriceInvalid(String name) {
    return 'Check the price of $name.';
  }

  @override
  String get errDiscountNegative => 'Discount cannot be negative.';

  @override
  String get errDiscountOverSubtotal =>
      'Discount cannot be more than the subtotal.';

  @override
  String get errDiscountOverHundred => 'Discount cannot be more than 100%.';

  @override
  String get errBillAlreadyFinalised => 'This bill is already finalised.';

  @override
  String get errAppointmentAlreadyBilled =>
      'This appointment already has a bill.';

  @override
  String errAppointmentAlreadyBilledNo(String invoiceNo) {
    return 'This appointment already has a bill ($invoiceNo).';
  }

  @override
  String get errPaymentNeedsFinalisedBill =>
      'Finalise the bill before taking payment.';

  @override
  String get errBillIsVoid => 'This bill is void.';

  @override
  String get errPaymentMethodRequired => 'Choose how the customer paid.';

  @override
  String get errPaymentOverBalance => 'Amount is more than the balance due.';

  @override
  String errOutOfStock(String name) {
    return '$name is out of stock.';
  }

  @override
  String errNotEnoughStock(String qty, String name) {
    return 'Only $qty $name left in stock.';
  }

  @override
  String get errStockChangeZero => 'Enter a quantity more than 0.';

  @override
  String get errStockSalesViaBills => 'Sales change stock through bills.';

  @override
  String get uiDay => 'Day';

  @override
  String get uiMonth => 'Month';

  @override
  String get uiDemo => 'Demo';

  @override
  String get welcomeArtLabel =>
      'Line drawing of a woman with leaves in her hair';

  @override
  String get welcomeTagline => 'Manage your parlour\nbusiness easily';

  @override
  String get welcomeFeatures =>
      'Appointments, billing, customers, staff, inventory & reports — all in one place.';

  @override
  String get welcomeExplore => 'Explore MyParlour';

  @override
  String get welcomeSampleData => 'Sample data · no sign-in needed';

  @override
  String get startupErrorTitle => 'MyParlour could not open its data';

  @override
  String get startupErrorMessage =>
      'Please check that the phone has free storage space, then try again.';

  @override
  String get startupScreenError =>
      'Something went wrong on this screen. Please go back and try again.';

  @override
  String dashLoadError(String error) {
    return 'Could not load the dashboard. $error';
  }

  @override
  String get dashQuickActions => 'Quick actions';

  @override
  String get dashGreetingMorning => 'Good morning';

  @override
  String dashGreetingMorningNamed(String name) {
    return 'Good morning, $name';
  }

  @override
  String get dashGreetingAfternoon => 'Good afternoon';

  @override
  String dashGreetingAfternoonNamed(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String get dashGreetingEvening => 'Good evening';

  @override
  String dashGreetingEveningNamed(String name) {
    return 'Good evening, $name';
  }

  @override
  String get dashYourParlour => 'Your parlour';

  @override
  String get dashMoreBranches => 'More branches in the full version';

  @override
  String get dashAlerts => 'Alerts';

  @override
  String get dashAlertsNew => 'Alerts (new)';

  @override
  String get dashNoSalesYesterday => 'No sales yesterday';

  @override
  String dashVsYesterday(int percent) {
    return '$percent% vs yesterday';
  }

  @override
  String get dashTodaysSales => 'Today\'s sales';

  @override
  String dashStillToCome(int count) {
    return '$count still to come';
  }

  @override
  String get dashPendingPayments => 'Pending payments';

  @override
  String dashBillsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bills due',
      one: '1 bill due',
    );
    return '$_temp0';
  }

  @override
  String get dashCustomers => 'Customers';

  @override
  String get dashActiveClients => 'Active clients';

  @override
  String get dashNothingNeedsAttention =>
      'Nothing needs your attention right now.';

  @override
  String get dashBirthdaysToday => 'Birthdays today';

  @override
  String get dashWishBirthday => 'Wish them a happy birthday';

  @override
  String dashAlertAt(int qty, String unit) {
    return 'Alert at $qty $unit';
  }

  @override
  String get dashRestock => 'Restock';

  @override
  String get dashAllWellStocked => 'All products are well stocked.';

  @override
  String get dashNextAppointments => 'Next appointments';

  @override
  String get dashNoMoreToday => 'No more appointments today.';

  @override
  String get dashBook => 'Book';

  @override
  String get dashNewAppointment => 'New appointment';

  @override
  String get dashAddCustomer => 'Add customer';

  @override
  String get dashCreateBill => 'Create bill';

  @override
  String moreOwnerSubtitle(String parlour) {
    return '$parlour · Owner';
  }

  @override
  String get moreCustomers => 'Customers';

  @override
  String moreCustomerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count customers',
      one: '1 customer',
    );
    return '$_temp0';
  }

  @override
  String get moreStaff => 'Staff';

  @override
  String moreActiveStaff(int count) {
    return '$count active';
  }

  @override
  String get moreServices => 'Services';

  @override
  String moreServiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '1 service',
    );
    return '$_temp0';
  }

  @override
  String get moreInventory => 'Inventory';

  @override
  String moreLowCount(int count) {
    return '$count low';
  }

  @override
  String moreExpensesThisMonth(String amount) {
    return '$amount this month';
  }

  @override
  String get moreReports => 'Reports';

  @override
  String get settingsTitle => 'Settings';

  @override
  String settingsLoadError(String error) {
    return 'Could not load settings. $error';
  }

  @override
  String get settingsResetTitle => 'Reset demo data?';

  @override
  String get settingsResetMessage =>
      'All changes are replaced with the original sample data for Beauty Bliss Parlour, dated around today. This cannot be undone.';

  @override
  String get settingsResetConfirm => 'Reset';

  @override
  String get settingsResetDone => 'Demo data restored';

  @override
  String get settingsEmptyTitle => 'Start with an empty parlour?';

  @override
  String settingsEmptyMessage(String resetLabel) {
    return 'All customers, services, staff, appointments, bills, products and expenses are removed. Your parlour profile, hours and billing settings are kept. You can bring the sample data back with \"$resetLabel\".';
  }

  @override
  String get settingsStartEmpty => 'Start empty';

  @override
  String get settingsEmptyDone => 'Started with an empty parlour';

  @override
  String get settingsProfile => 'Parlour profile';

  @override
  String get settingsName => 'Name';

  @override
  String get settingsOwner => 'Owner';

  @override
  String get settingsPhone => 'Phone';

  @override
  String get settingsArea => 'Area';

  @override
  String get settingsAddress => 'Address';

  @override
  String get settingsBusinessHours => 'Business hours';

  @override
  String get settingsOpenDays => 'Open days';

  @override
  String get settingsHours => 'Hours';

  @override
  String settingsTimeRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get settingsBookingSlots => 'Booking slots';

  @override
  String get settingsBillingTax => 'Billing & tax';

  @override
  String get settingsInvoicePrefix => 'Invoice prefix';

  @override
  String get settingsGst => 'GST';

  @override
  String get settingsOn => 'On';

  @override
  String get settingsOff => 'Off';

  @override
  String get settingsGstin => 'GSTIN';

  @override
  String get settingsDefaultRate => 'Default rate';

  @override
  String get settingsPricesIncludeGst => 'Prices include GST';

  @override
  String get settingsYes => 'Yes';

  @override
  String get settingsNo => 'No';

  @override
  String get settingsReceiptFooter => 'Receipt footer';

  @override
  String get settingsDemoNote =>
      'This is a demo. Data stays on this phone only.';

  @override
  String get settingsResetDemo => 'Reset demo data';

  @override
  String get settingsResetDemoHint => 'Restore the original sample data';

  @override
  String get settingsStartEmptyHint =>
      'Clear everything to try a blank parlour';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutNote =>
      'Sign-in and cloud backup arrive in the full version.';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get settingsParlourName => 'Parlour name';

  @override
  String get settingsEnterParlourName => 'Enter the parlour name.';

  @override
  String get settingsOwnerName => 'Owner name';

  @override
  String get settingsEnterOwnerName => 'Enter the owner’s name.';

  @override
  String get settingsEnterPhone => 'Enter a phone number.';

  @override
  String get settingsAreaHint => 'e.g. MG Road, Pune';

  @override
  String get settingsEnterArea => 'Enter the area.';

  @override
  String get settingsProfileNote =>
      'The name, area and phone appear on receipts.';

  @override
  String get settingsNoOpenDay => 'Choose at least one open day.';

  @override
  String get settingsCloseBeforeOpen =>
      'Closing time must be after opening time.';

  @override
  String get settingsOpens => 'Opens';

  @override
  String get settingsOpeningTime => 'Opening time';

  @override
  String get settingsCloses => 'Closes';

  @override
  String get settingsClosingTime => 'Closing time';

  @override
  String get settingsSlotsNote =>
      'New appointments are offered at these intervals.';

  @override
  String get settingsPrefixHint => 'e.g. BBP';

  @override
  String get settingsEnterPrefix => 'Enter a prefix.';

  @override
  String settingsNumberingNote(String example) {
    return 'Bills are numbered like $example. Numbers already used do not change.';
  }

  @override
  String get settingsChargeGst => 'Charge GST';

  @override
  String get settingsChargeGstHint => 'Adds GST to new bills';

  @override
  String get settingsGstinHint => '15 characters';

  @override
  String get settingsGstinInvalid => 'A GSTIN has 15 letters and numbers.';

  @override
  String get settingsGstinNote =>
      'Receipts become \"Tax invoices\" only when a GSTIN is added.';

  @override
  String get settingsDefaultGstRate => 'Default GST rate';

  @override
  String get settingsPricesIncludeGstHint =>
      'Take GST out of the price instead of adding it';

  @override
  String get settingsEnterFooter => 'Enter a footer.';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get expensesAdd => 'Add expense';

  @override
  String get expensesPreviousMonth => 'Previous month';

  @override
  String get expensesNextMonth => 'Next month';

  @override
  String get expensesTotalSpent => 'Total spent';

  @override
  String get expensesEmpty => 'No expenses in this month.';

  @override
  String get expensesExpense => 'Expense';

  @override
  String get expensesNotFound => 'This expense no longer exists.';

  @override
  String get expensesUpdated => 'Expense updated';

  @override
  String get expensesAdded => 'Expense added';

  @override
  String get expensesDeleteTitle => 'Delete this expense?';

  @override
  String expensesDeleteMessage(String category, String amount) {
    return '$category · $amount will be removed.';
  }

  @override
  String get expensesDeleted => 'Expense deleted';

  @override
  String get expensesEdit => 'Edit expense';

  @override
  String get expensesDelete => 'Delete expense';

  @override
  String get expensesAmount => 'Amount';

  @override
  String get expensesEnterAmount => 'Enter the amount.';

  @override
  String get expensesCategory => 'Category';

  @override
  String get expensesDate => 'Date';

  @override
  String get expensesChooseDate => 'Choose a date';

  @override
  String get expensesPaidBy => 'Paid by';

  @override
  String get expensesNote => 'Note';

  @override
  String get expensesNoteHint => 'e.g. Shop rent for May';

  @override
  String get expensesSave => 'Save expense';

  @override
  String get apptTitle => 'Appointment';

  @override
  String get apptListTitle => 'Appointments';

  @override
  String get apptBook => 'Book appointment';

  @override
  String get apptPickDate => 'Pick a date';

  @override
  String get apptFilterByStylist => 'Filter by stylist';

  @override
  String apptShowingStylist(String name) {
    return 'Showing $name';
  }

  @override
  String get apptShowFor => 'Show appointments for';

  @override
  String get apptAllStylists => 'All stylists';

  @override
  String apptStaffInactive(String name) {
    return '$name (inactive)';
  }

  @override
  String get apptFilterAll => 'All';

  @override
  String apptFilterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String apptLoadFailed(String error) {
    return 'Could not load appointments. $error';
  }

  @override
  String get apptNoneOnDay => 'No appointments on this day';

  @override
  String get apptNoneUpcomingOnDay => 'No upcoming appointments on this day';

  @override
  String get apptNoneCheckedInOnDay => 'No checked in appointments on this day';

  @override
  String get apptNoneCompletedOnDay => 'No completed appointments on this day';

  @override
  String get apptNoneCancelledOnDay => 'No cancelled appointments on this day';

  @override
  String get apptNoneNoShowOnDay => 'No no-show appointments on this day';

  @override
  String get apptPreviousWeek => 'Previous week';

  @override
  String get apptNextWeek => 'Next week';

  @override
  String apptDayHasBookings(String day) {
    return '$day, has bookings';
  }

  @override
  String get apptNoLongerExists => 'This appointment no longer exists.';

  @override
  String apptDetailLoadFailed(String error) {
    return 'Could not load this appointment. $error';
  }

  @override
  String get apptMoreActions => 'More actions';

  @override
  String get apptCancelAppointment => 'Cancel appointment';

  @override
  String get apptMarkNoShow => 'Mark no-show';

  @override
  String get apptOpenCustomer => 'Open customer';

  @override
  String get apptCancelledDone => 'Appointment cancelled';

  @override
  String get apptNoShowTitle => 'Mark as no-show?';

  @override
  String apptNoShowMessage(String name) {
    return '$name did not come. This cannot be undone.';
  }

  @override
  String get apptNoShowDone => 'Marked as no-show';

  @override
  String get apptServices => 'Services';

  @override
  String get apptTotal => 'Total';

  @override
  String get apptNotes => 'Notes';

  @override
  String get apptReschedule => 'Reschedule';

  @override
  String get apptCheckIn => 'Check in';

  @override
  String get apptCheckedInDone => 'Checked in';

  @override
  String get apptComplete => 'Complete';

  @override
  String get apptCompletedDone => 'Appointment completed';

  @override
  String get apptCreateBill => 'Create bill';

  @override
  String get apptViewBill => 'View bill';

  @override
  String get apptCancelTitle => 'Cancel appointment?';

  @override
  String get apptCancelReasonLabel => 'Reason (optional)';

  @override
  String get apptCancelReasonHint => 'Or type a reason';

  @override
  String get apptCancelKeep => 'Keep it';

  @override
  String get apptReasonCustomerCancelled => 'Customer cancelled';

  @override
  String get apptReasonCustomerUnwell => 'Customer unwell';

  @override
  String get apptReasonRescheduledByCustomer => 'Rescheduled by customer';

  @override
  String get apptReasonStylistUnavailable => 'Stylist unavailable';

  @override
  String get apptChooseCustomer => 'Choose customer';

  @override
  String get apptNewCustomerShort => 'New';

  @override
  String get apptSearchCustomer => 'Search name or phone';

  @override
  String get apptNoCustomerMatch => 'No customer matches your search.';

  @override
  String get apptAddNewCustomer => 'Add new customer';

  @override
  String get apptChooseServices => 'Choose services';

  @override
  String get apptSearchServices => 'Search services';

  @override
  String apptAddServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count services',
      one: 'Add 1 service',
    );
    return '$_temp0';
  }

  @override
  String apptAlreadyBooked(String name) {
    return '$name is already booked';
  }

  @override
  String get apptPickAnotherTime => 'Pick another time';

  @override
  String get apptBookAnyway => 'Book anyway';

  @override
  String get bookingOnlyUpcoming =>
      'Only upcoming appointments can be rescheduled.';

  @override
  String bookingLoadFailed(String error) {
    return 'Could not open the form. $error';
  }

  @override
  String get bookingRescheduled => 'Appointment rescheduled';

  @override
  String get bookingBooked => 'Appointment booked';

  @override
  String get bookingNewTitle => 'New appointment';

  @override
  String get bookingDate => 'Date';

  @override
  String get bookingChooseDate => 'Choose a date';

  @override
  String bookingClosedOn(String weekday) {
    return 'The parlour is usually closed on ${weekday}s.';
  }

  @override
  String get bookingTime => 'Time';

  @override
  String get bookingNoTimesLeft =>
      'No times left on this day. Choose another date.';

  @override
  String get bookingNoStylist => 'No stylist works on this day.';

  @override
  String get bookingNotesHint => 'e.g. Prefers less heat in smoothening';

  @override
  String get bookingWalkInName => 'Walk-in name';

  @override
  String get bookingWalkInNameRequired => 'Enter the customer’s name.';

  @override
  String get bookingMobileNumber => 'Mobile number';

  @override
  String get bookingPhoneInvalid => 'Enter a 10-digit mobile number.';

  @override
  String get bookingChooseSavedCustomer => 'Choose a saved customer instead';

  @override
  String get bookingCustomerRequired => 'Choose a customer or add a walk-in.';

  @override
  String bookingRemoveService(String name) {
    return 'Remove $name';
  }

  @override
  String get bookingAddServices => 'Add services';

  @override
  String get bookingAddMore => 'Add more';

  @override
  String get bookingChooseTimeFirst => 'Choose a time first';

  @override
  String get bookingFree => 'Free';

  @override
  String bookingBusyUntil(String time) {
    return 'Busy until $time';
  }

  @override
  String bookingBusyFrom(String time) {
    return 'Busy from $time';
  }

  @override
  String bookingDurationEnds(String duration, String time) {
    return 'Duration $duration · ends $time';
  }

  @override
  String bookingEstimate(String amount) {
    return 'Estimate $amount';
  }

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsChoosePeriod => 'Choose period';

  @override
  String reportsLoadFailed(String error) {
    return 'Could not build the report. $error';
  }

  @override
  String get reportsEmpty => 'No sales, bills or expenses in this period.';

  @override
  String get reportsTotalSales => 'Total sales';

  @override
  String get reportsMoneyReceived => 'Money received';

  @override
  String get reportsTotalExpenses => 'Total expenses';

  @override
  String get reportsNetProfit => 'Net profit (estimate)';

  @override
  String get reportsSalesMinusExpenses => 'Sales − expenses';

  @override
  String get reportsTotalBills => 'Total bills';

  @override
  String get reportsBillsCaption => 'Finalised, not void';

  @override
  String get reportsSalesOverview => 'Sales overview';

  @override
  String get reportsTopServices => 'Top services';

  @override
  String get reportsNoServices => 'No services billed in this period.';

  @override
  String get reportsPaymentMethods => 'Payment methods';

  @override
  String reportsServiceCount(int count, String amount) {
    return '$count × · $amount';
  }

  @override
  String reportsCompactThousands(String value) {
    return '₹${value}k';
  }

  @override
  String reportsCompactLakhs(String value) {
    return '₹${value}L';
  }

  @override
  String get custTitle => 'Customers';

  @override
  String get custAdd => 'Add customer';

  @override
  String get custEdit => 'Edit customer';

  @override
  String get custSearchHint => 'Search name or phone';

  @override
  String get custViewRecent => 'Recent visit';

  @override
  String get custViewAz => 'A–Z';

  @override
  String custViewInactive(int count) {
    return 'Inactive ($count)';
  }

  @override
  String custLoadError(String error) {
    return 'Could not load customers. $error';
  }

  @override
  String get custNoMatch => 'No customer matches your search.';

  @override
  String get custNoInactive => 'No inactive customers.';

  @override
  String get custEmpty => 'No customers yet.';

  @override
  String custRowCaption(int visits, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      visits,
      locale: localeName,
      other: '$visits visits · $last',
      one: '1 visit · $last',
      zero: 'No visits yet',
    );
    return '$_temp0';
  }

  @override
  String custLastVisit(String date) {
    return 'last $date';
  }

  @override
  String get custNoVisitsYet => 'no visits yet';

  @override
  String get custNotFound => 'This customer no longer exists.';

  @override
  String custLoadOneError(String error) {
    return 'Could not load this customer. $error';
  }

  @override
  String get custShareContact => 'Share contact';

  @override
  String get custDeactivate => 'Deactivate customer';

  @override
  String get custReactivate => 'Reactivate customer';

  @override
  String custDeactivateTitle(String name) {
    return 'Deactivate $name?';
  }

  @override
  String get custDeactivateMessage =>
      'They will be hidden from the customer list and booking. Their history is kept, and you can reactivate them later.';

  @override
  String get custDeactivated => 'Customer deactivated';

  @override
  String get custReactivated => 'Customer reactivated';

  @override
  String get custActionMore => 'More';

  @override
  String get custTabHistory => 'History';

  @override
  String get custTabDetails => 'Details';

  @override
  String get custNotes => 'Notes';

  @override
  String get custNewAppointment => 'New appointment';

  @override
  String get custSaved => 'Customer saved';

  @override
  String get custUpdated => 'Customer updated';

  @override
  String get custFieldName => 'Name';

  @override
  String get custNameHint => 'e.g. Priya Sharma';

  @override
  String get custNameRequired => 'Enter the customer’s name.';

  @override
  String get custFieldMobile => 'Mobile number';

  @override
  String get custMobileRequired => 'Enter the mobile number.';

  @override
  String get custMobileInvalid => 'Enter a 10-digit mobile number.';

  @override
  String get custBirthday => 'Birthday';

  @override
  String get custAnniversary => 'Anniversary';

  @override
  String get custDayMonthHint => 'Day and month';

  @override
  String get custNotesHint => 'e.g. Prefers less heat in smoothening';

  @override
  String get custEmail => 'Email';

  @override
  String get custEmailInvalid => 'Enter a valid email address.';

  @override
  String get custSave => 'Save customer';

  @override
  String get custSaveAndBook => 'Save & book appointment';

  @override
  String custAlreadySaved(String name) {
    return 'Already saved as $name';
  }

  @override
  String get custOpen => 'Open';

  @override
  String get custMobile => 'Mobile';

  @override
  String get custSince => 'Customer since';

  @override
  String get custVisits => 'Visits';

  @override
  String get custTotalSpent => 'Total spent';

  @override
  String get custHistoryEmpty => 'No visits or bills yet.';

  @override
  String get custNotesSaved => 'Notes saved';

  @override
  String get custNotesTabHint =>
      'Preferences, allergies, favourite stylist… (e.g. Prefers less heat in smoothening)';

  @override
  String get custSaveNotes => 'Save notes';

  @override
  String get servicesTitle => 'Services';

  @override
  String get servicesAdd => 'Add service';

  @override
  String get servicesEdit => 'Edit service';

  @override
  String get servicesEmpty => 'No services yet. Add what your parlour offers.';

  @override
  String servicesLoadError(String error) {
    return 'Could not load services. $error';
  }

  @override
  String get servicesNewCategory => 'New category';

  @override
  String get servicesNewCategoryHint => 'e.g. Bridal';

  @override
  String get servicesAdded => 'Service added';

  @override
  String get servicesUpdated => 'Service updated';

  @override
  String servicesDeactivateTitle(String name) {
    return 'Deactivate $name?';
  }

  @override
  String get servicesDeactivateMessage =>
      'It will no longer be offered for new bookings or bills. Past appointments and bills keep it.';

  @override
  String get servicesDeactivated => 'Service deactivated';

  @override
  String get servicesReactivated => 'Service reactivated';

  @override
  String get servicesFieldName => 'Service name';

  @override
  String get servicesNameHint => 'e.g. Haircut';

  @override
  String get servicesCategory => 'Category';

  @override
  String get servicesPrice => 'Price';

  @override
  String get servicesPriceInvalid => 'Enter the price in rupees.';

  @override
  String get servicesDuration => 'Duration';

  @override
  String get servicesCustomDuration => 'Custom';

  @override
  String get servicesMinutes => 'Minutes';

  @override
  String get servicesMinutesHint => 'e.g. 75';

  @override
  String get servicesMinutesRequired => 'Enter the minutes.';

  @override
  String get servicesDescription => 'Description';

  @override
  String get servicesGstRate => 'GST rate';

  @override
  String get servicesGstNote => 'Used only when GST is turned on in Settings.';

  @override
  String get servicesDeactivate => 'Deactivate service';

  @override
  String get servicesReactivate => 'Reactivate service';

  @override
  String get servicesSave => 'Save service';

  @override
  String get servicesService => 'Service';

  @override
  String get servicesNotFound => 'This service no longer exists.';

  @override
  String servicesLoadOneError(String error) {
    return 'Could not load this service. $error';
  }

  @override
  String get staffTitle => 'Staff';

  @override
  String get staffAdd => 'Add staff';

  @override
  String get staffEdit => 'Edit staff';

  @override
  String get staffSearchHint => 'Search name, role or phone';

  @override
  String staffLoadError(String error) {
    return 'Could not load staff. $error';
  }

  @override
  String get staffNoMatch => 'No staff member matches your search.';

  @override
  String get staffEmpty => 'No staff yet.';

  @override
  String get staffNotFound => 'This staff member no longer exists.';

  @override
  String staffDeactivateTitle(String name) {
    return 'Deactivate $name?';
  }

  @override
  String staffDeactivateMessage(String name) {
    return '$name will not be offered for new bookings. Past appointments and bills keep their name. You can reactivate later.';
  }

  @override
  String get staffDeactivated => 'Staff deactivated';

  @override
  String get staffActivated => 'Staff activated';

  @override
  String get staffActivate => 'Activate';

  @override
  String get staffMobile => 'Mobile';

  @override
  String get staffWorks => 'Works';

  @override
  String get staffHours => 'Hours';

  @override
  String get staffServices => 'Services';

  @override
  String staffHoursRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get staffServicesDone => 'Services done';

  @override
  String get staffAmountBilled => 'Amount billed';

  @override
  String get staffTodayAndUpcoming => 'Today and upcoming';

  @override
  String get staffNoAppointments => 'No appointments booked.';

  @override
  String get staffFormLoadError =>
      'Could not load this form. Please try again.';

  @override
  String get staffAdded => 'Staff added';

  @override
  String get staffUpdated => 'Staff updated';

  @override
  String get staffFieldName => 'Name';

  @override
  String get staffFieldMobile => 'Mobile number';

  @override
  String get staffMobileInvalid => 'Enter a 10-digit mobile number.';

  @override
  String get staffRole => 'Role';

  @override
  String get staffServicesTheyDo => 'Services they do';

  @override
  String get staffClearAll => 'Clear all';

  @override
  String get staffTickAll => 'Tick all';

  @override
  String get staffWorkingDays => 'Working days';

  @override
  String get staffStarts => 'Starts';

  @override
  String get staffStartHint => 'Start';

  @override
  String get staffEnds => 'Ends';

  @override
  String get staffEndHint => 'End';

  @override
  String get staffNoWorkingDay => 'Choose at least one working day.';

  @override
  String get staffSave => 'Save staff';

  @override
  String get billingNewBill => 'New bill';

  @override
  String get billingOpenBills => 'Open bills';

  @override
  String get billingAllBills => 'All bills';

  @override
  String billingLoadError(String error) {
    return 'Could not load bills. $error';
  }

  @override
  String get billingNoOpenBills => 'No open bills. Everything is paid.';

  @override
  String get billingNoBills => 'No bills yet.';

  @override
  String get billingDraftBill => 'Draft bill';

  @override
  String billingDue(String amount) {
    return 'Due $amount';
  }

  @override
  String get billingBill => 'Bill';

  @override
  String get billingOpenBill => 'Open bill';

  @override
  String get billingNoLongerDraft => 'This bill is no longer a draft.';

  @override
  String billingOpenError(String error) {
    return 'Could not open the bill. $error';
  }

  @override
  String get billingEnterNumber => 'Enter a number.';

  @override
  String get billingChooseSavedCustomer => 'Choose a saved customer';

  @override
  String get billingWalkInName => 'Walk-in name';

  @override
  String get billingWalkInNameHint => 'e.g. Kiran';

  @override
  String get billingCheckDiscount => 'Check the discount.';

  @override
  String get billingDraftSaved => 'Draft saved';

  @override
  String billingSavedNothingToPay(String invoiceNo) {
    return '$invoiceNo saved. Nothing to pay.';
  }

  @override
  String get billingCreateBill => 'Create bill';

  @override
  String get billingChange => 'Change';

  @override
  String get billingItems => 'Items';

  @override
  String get billingSwipeToRemove => 'Swipe a line left to remove it.';

  @override
  String get billingAddItem => 'Add service or product';

  @override
  String get billingDiscount => 'Discount';

  @override
  String get billingDiscountHintPercent => 'e.g. 10';

  @override
  String get billingDiscountHintAmount => 'e.g. 300';

  @override
  String get billingSaveDraft => 'Save draft';

  @override
  String get billingProceedToPayment => 'Proceed to payment';

  @override
  String get billingBillGone => 'This bill no longer exists.';

  @override
  String billingLoadBillError(String error) {
    return 'Could not load this bill. $error';
  }

  @override
  String get billingVoidTitle => 'Void this bill?';

  @override
  String get billingVoidMessage =>
      'The bill and its payments will be marked void and any products sold go back into stock. The bill number is not reused.';

  @override
  String get billingVoidBill => 'Void bill';

  @override
  String get billingVoided => 'Bill voided';

  @override
  String get billingMoreActions => 'More actions';

  @override
  String get billingPrintReceipt => 'Print receipt';

  @override
  String get billingDownloadPdf => 'Download PDF';

  @override
  String get billingVoidBanner =>
      'This bill is void. Its payments are not counted and its products went back into stock.';

  @override
  String get billingPaidAmount => 'Paid';

  @override
  String get billingBalanceDue => 'Balance due';

  @override
  String get billingPayments => 'Payments';

  @override
  String get billingVoidTag => 'void';

  @override
  String get billingShare => 'Share';

  @override
  String get billingRecordPayment => 'Record payment';

  @override
  String get billingShareReceiptWhatsApp => 'Share receipt on WhatsApp';

  @override
  String billingStylistName(String name) {
    return 'Stylist: $name';
  }

  @override
  String get billingAddToBill => 'Add to bill';

  @override
  String get billingSearchItems => 'Search services or products';

  @override
  String get billingServicesTab => 'Services';

  @override
  String get billingProductsTab => 'Products';

  @override
  String get billingNoSellingPrice => 'No selling price set';

  @override
  String billingInStockCount(int count) {
    return 'In stock: $count';
  }

  @override
  String get billingNoMatch => 'Nothing matches your search.';

  @override
  String billingReceiptShareText(String parlour) {
    return 'Receipt from $parlour';
  }

  @override
  String get billingShareFailed => 'Could not open sharing on this phone.';

  @override
  String get billingPrintFailed => 'Could not open printing on this phone.';

  @override
  String get billingDownloadFailed => 'Could not save the PDF on this phone.';

  @override
  String get billingReceiptFailed => 'Could not create the receipt.';

  @override
  String get billingSubtotal => 'Subtotal';

  @override
  String get billingGst => 'GST';

  @override
  String get billingTotal => 'Total';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentFinishBillFirst => 'Finish the bill before taking payment.';

  @override
  String get paymentFullyPaid => 'This bill is fully paid.';

  @override
  String get paymentEnterAmount => 'Enter the amount received.';

  @override
  String get paymentFullBalance => 'Full balance';

  @override
  String paymentPartial(String amount) {
    return 'Partial · $amount will still be due';
  }

  @override
  String get paymentBillTotal => 'Bill total';

  @override
  String get paymentAlreadyReceived => 'Already received';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get paymentUpiNote =>
      'Records the payment; the app does not verify UPI.';

  @override
  String get paymentAmountReceived => 'Amount received';

  @override
  String get paymentNote => 'Note';

  @override
  String get paymentConfirm => 'Confirm';

  @override
  String paymentConfirmAmount(String amount) {
    return 'Confirm $amount';
  }

  @override
  String get paymentNotFound => 'This payment could not be found.';

  @override
  String get paymentRecorded => 'Payment recorded';

  @override
  String paymentAmountByMethod(String amount, String method) {
    return '$amount by $method';
  }

  @override
  String paymentTotalAmount(String amount) {
    return 'Total $amount';
  }

  @override
  String get paymentBalance => 'Balance';

  @override
  String get paymentBookNextVisit => 'Book next visit';

  @override
  String get paymentBackToDashboard => 'Back to dashboard';

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String get inventoryAddProduct => 'Add product';

  @override
  String get inventorySearch => 'Search products';

  @override
  String get inventoryAllItems => 'All items';

  @override
  String inventoryTabCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String inventoryLoadError(String error) {
    return 'Could not load products. $error';
  }

  @override
  String get inventoryEmpty => 'No products yet.';

  @override
  String get inventoryNoneLow => 'Nothing is running low.';

  @override
  String get inventoryNoneOut => 'Nothing is out of stock.';

  @override
  String get inventoryProduct => 'Product';

  @override
  String get inventoryProductGone => 'This product no longer exists.';

  @override
  String get inventoryEditProduct => 'Edit product';

  @override
  String get inventoryInStockLabel => 'In stock';

  @override
  String get inventoryLowStockAlertAt => 'Low-stock alert at';

  @override
  String get inventorySellingPrice => 'Selling price';

  @override
  String get inventoryNotSet => 'Not set';

  @override
  String get inventoryCostPrice => 'Cost price';

  @override
  String get inventoryStockHistory => 'Stock history';

  @override
  String get inventoryNoStockChanges => 'No stock changes yet.';

  @override
  String get inventoryAdjustStock => 'Adjust stock';

  @override
  String get inventoryProductUpdated => 'Product updated';

  @override
  String get inventoryProductAdded => 'Product added';

  @override
  String inventoryDeactivateTitle(String name) {
    return 'Deactivate $name?';
  }

  @override
  String get inventoryDeactivateMessage =>
      'It will no longer be offered on bills. Its stock history is kept.';

  @override
  String get inventoryDeactivated => 'Product deactivated';

  @override
  String get inventoryReactivated => 'Product reactivated';

  @override
  String get inventoryEnterOpeningStock => 'Enter the opening stock.';

  @override
  String get inventoryEnterAlertLevel => 'Enter the alert level.';

  @override
  String get inventoryEnterPrice => 'Enter a price in rupees.';

  @override
  String get inventoryName => 'Name';

  @override
  String get inventoryNameHint => 'e.g. Hair Serum';

  @override
  String inventoryStockInfo(int qty, String unit) {
    return 'In stock: $qty $unit. Use \"Adjust stock\" on the product screen to change it.';
  }

  @override
  String get inventoryOpeningStock => 'Opening stock';

  @override
  String get inventoryOpeningStockHint => 'e.g. 10';

  @override
  String get inventoryUnit => 'Unit';

  @override
  String get inventoryCategory => 'Category';

  @override
  String get inventoryCategoryHint => 'e.g. Hair care';

  @override
  String get inventoryDeactivateProduct => 'Deactivate product';

  @override
  String get inventoryReactivateProduct => 'Reactivate product';

  @override
  String get inventorySaveProduct => 'Save product';

  @override
  String inventoryOnlyInStock(int count) {
    return 'Only $count in stock.';
  }

  @override
  String get inventorySameAsCurrent => 'That is the same as the current stock.';

  @override
  String get inventoryStockUpdated => 'Stock updated';

  @override
  String inventoryAdjustSubtitle(String name, int qty, String unit) {
    return '$name · now $qty $unit';
  }

  @override
  String get inventoryAdjustType => 'Type';

  @override
  String get inventoryCountedQty => 'Counted quantity';

  @override
  String get inventoryQty => 'Quantity';

  @override
  String inventoryNewStock(int qty, String unit) {
    return 'New stock: $qty $unit';
  }

  @override
  String get inventoryNote => 'Note';

  @override
  String get inventoryNoteHint => 'e.g. Bought from supplier';

  @override
  String inventoryStockLine(int qty, String unit) {
    return 'Stock: $qty $unit';
  }

  @override
  String receiptPhone(String phone) {
    return 'Phone $phone';
  }

  @override
  String receiptGstin(String gstin) {
    return 'GSTIN $gstin';
  }

  @override
  String get receiptTaxInvoice => 'TAX INVOICE';

  @override
  String get receiptHeading => 'RECEIPT';

  @override
  String get receiptItem => 'Item';

  @override
  String get receiptQty => 'Qty';

  @override
  String get receiptRate => 'Rate';

  @override
  String get receiptAmount => 'Amount';

  @override
  String receiptStylist(String name) {
    return 'Stylist: $name';
  }

  @override
  String get receiptSubtotal => 'Subtotal';

  @override
  String get receiptDiscount => 'Discount';

  @override
  String get receiptGst => 'GST';

  @override
  String get receiptTotal => 'Total';

  @override
  String get receiptPaid => 'Paid';

  @override
  String get receiptBalance => 'Balance';

  @override
  String get receiptPayments => 'Payments';

  @override
  String get receiptNotTaxInvoice =>
      'This is a payment receipt, not a GST tax invoice.';
}
