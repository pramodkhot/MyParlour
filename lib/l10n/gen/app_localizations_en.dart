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
}
