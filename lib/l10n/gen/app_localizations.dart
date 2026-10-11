import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MyParlour'**
  String get appName;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get navAppointments;

  /// No description provided for @navBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get navBilling;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get commonSaveChanges;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get commonOptional;

  /// No description provided for @commonClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get commonClearSearch;

  /// No description provided for @commonClearField.
  ///
  /// In en, this message translates to:
  /// **'Clear {label}'**
  String commonClearField(String label);

  /// No description provided for @commonDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get commonDecrease;

  /// No description provided for @commonIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get commonIncrease;

  /// No description provided for @commonMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get commonMoreDetails;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get commonNotAdded;

  /// No description provided for @commonInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get commonInactive;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get commonDeactivate;

  /// No description provided for @commonReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get commonReactivate;

  /// No description provided for @commonWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk-in'**
  String get commonWalkIn;

  /// No description provided for @commonWalkInNamed.
  ///
  /// In en, this message translates to:
  /// **'Walk-in · {name}'**
  String commonWalkInNamed(String name);

  /// No description provided for @commonWalkInCustomer.
  ///
  /// In en, this message translates to:
  /// **'Walk-in customer'**
  String get commonWalkInCustomer;

  /// No description provided for @commonGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get commonGuest;

  /// No description provided for @commonCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get commonCustomer;

  /// No description provided for @commonStylist.
  ///
  /// In en, this message translates to:
  /// **'Stylist'**
  String get commonStylist;

  /// No description provided for @commonNoAppFor.
  ///
  /// In en, this message translates to:
  /// **'No app on this phone can open {what}.'**
  String commonNoAppFor(String what);

  /// No description provided for @commonAppCalls.
  ///
  /// In en, this message translates to:
  /// **'calls'**
  String get commonAppCalls;

  /// No description provided for @commonAppWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp links'**
  String get commonAppWhatsApp;

  /// No description provided for @commonAppMessages.
  ///
  /// In en, this message translates to:
  /// **'messages'**
  String get commonAppMessages;

  /// No description provided for @commonAppSharing.
  ///
  /// In en, this message translates to:
  /// **'sharing'**
  String get commonAppSharing;

  /// No description provided for @commonCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// No description provided for @commonWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get commonWhatsApp;

  /// No description provided for @commonSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get commonSms;

  /// No description provided for @commonFillRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill the fields marked *.'**
  String get commonFillRequired;

  /// No description provided for @commonMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String commonMinutes(int count);

  /// No description provided for @commonHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String commonHours(int count);

  /// No description provided for @commonHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes}'**
  String commonHoursMinutes(int hours, String minutes);

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardTitle;

  /// No description provided for @discardMessage.
  ///
  /// In en, this message translates to:
  /// **'What you entered on this screen will not be saved.'**
  String get discardMessage;

  /// No description provided for @discardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardConfirm;

  /// No description provided for @discardKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get discardKeep;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get statusCheckedIn;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusNoShow.
  ///
  /// In en, this message translates to:
  /// **'No-show'**
  String get statusNoShow;

  /// No description provided for @billStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get billStatusDraft;

  /// No description provided for @billStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get billStatusUnpaid;

  /// No description provided for @billStatusPartiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially paid'**
  String get billStatusPartiallyPaid;

  /// No description provided for @billStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billStatusPaid;

  /// No description provided for @billStatusVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get billStatusVoid;

  /// No description provided for @payCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get payCash;

  /// No description provided for @payUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get payUpi;

  /// No description provided for @payCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get payCard;

  /// No description provided for @payOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get payOther;

  /// No description provided for @payRefUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI ref'**
  String get payRefUpi;

  /// No description provided for @payRefCard.
  ///
  /// In en, this message translates to:
  /// **'Card last 4'**
  String get payRefCard;

  /// No description provided for @payRefOther.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get payRefOther;

  /// No description provided for @stockInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get stockInStock;

  /// No description provided for @stockLow.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get stockLow;

  /// No description provided for @stockOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get stockOut;

  /// No description provided for @stockLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String stockLeft(int count);

  /// No description provided for @reasonPurchase.
  ///
  /// In en, this message translates to:
  /// **'Stock in'**
  String get reasonPurchase;

  /// No description provided for @reasonSale.
  ///
  /// In en, this message translates to:
  /// **'Sold on bill'**
  String get reasonSale;

  /// No description provided for @reasonUsedInService.
  ///
  /// In en, this message translates to:
  /// **'Used in service'**
  String get reasonUsedInService;

  /// No description provided for @reasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged / expired'**
  String get reasonDamaged;

  /// No description provided for @reasonCorrection.
  ///
  /// In en, this message translates to:
  /// **'Count correction'**
  String get reasonCorrection;

  /// No description provided for @reasonVoidReversal.
  ///
  /// In en, this message translates to:
  /// **'Bill voided (returned)'**
  String get reasonVoidReversal;

  /// No description provided for @periodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get periodToday;

  /// No description provided for @periodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get periodThisWeek;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get periodThisMonth;

  /// No description provided for @periodCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get periodCustom;

  /// No description provided for @unitPcs.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get unitPcs;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @unitG.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitG;

  /// No description provided for @catHair.
  ///
  /// In en, this message translates to:
  /// **'Hair'**
  String get catHair;

  /// No description provided for @catSkin.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get catSkin;

  /// No description provided for @catNails.
  ///
  /// In en, this message translates to:
  /// **'Nails'**
  String get catNails;

  /// No description provided for @catWaxing.
  ///
  /// In en, this message translates to:
  /// **'Waxing'**
  String get catWaxing;

  /// No description provided for @expRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get expRent;

  /// No description provided for @expSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get expSalary;

  /// No description provided for @expProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get expProducts;

  /// No description provided for @expElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get expElectricity;

  /// No description provided for @expTeaSnacks.
  ///
  /// In en, this message translates to:
  /// **'Tea/Snacks'**
  String get expTeaSnacks;

  /// No description provided for @expOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expOther;

  /// No description provided for @roleSeniorBeautician.
  ///
  /// In en, this message translates to:
  /// **'Senior Beautician'**
  String get roleSeniorBeautician;

  /// No description provided for @roleBeautician.
  ///
  /// In en, this message translates to:
  /// **'Beautician'**
  String get roleBeautician;

  /// No description provided for @roleJunior.
  ///
  /// In en, this message translates to:
  /// **'Junior'**
  String get roleJunior;

  /// No description provided for @roleReceptionist.
  ///
  /// In en, this message translates to:
  /// **'Receptionist'**
  String get roleReceptionist;

  /// No description provided for @prodCatHairCare.
  ///
  /// In en, this message translates to:
  /// **'Hair care'**
  String get prodCatHairCare;

  /// No description provided for @prodCatSkinCare.
  ///
  /// In en, this message translates to:
  /// **'Skin care'**
  String get prodCatSkinCare;

  /// No description provided for @errCustomerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer name.'**
  String get errCustomerNameRequired;

  /// No description provided for @errServiceNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the service name.'**
  String get errServiceNameRequired;

  /// No description provided for @errPriceNegative.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be negative.'**
  String get errPriceNegative;

  /// No description provided for @errServiceDurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose how long the service takes.'**
  String get errServiceDurationRequired;

  /// No description provided for @errStaffNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the staff member’s name.'**
  String get errStaffNameRequired;

  /// No description provided for @errProductNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the product name.'**
  String get errProductNameRequired;

  /// No description provided for @errLowStockNegative.
  ///
  /// In en, this message translates to:
  /// **'Low-stock alert cannot be negative.'**
  String get errLowStockNegative;

  /// No description provided for @errOpeningStockNegative.
  ///
  /// In en, this message translates to:
  /// **'Opening stock cannot be negative.'**
  String get errOpeningStockNegative;

  /// No description provided for @errAmountZero.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount more than ₹0.'**
  String get errAmountZero;

  /// No description provided for @errCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a category.'**
  String get errCategoryRequired;

  /// No description provided for @errAppointmentNoServices.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one service.'**
  String get errAppointmentNoServices;

  /// No description provided for @errAppointmentNoClient.
  ///
  /// In en, this message translates to:
  /// **'Choose a customer or enter a name.'**
  String get errAppointmentNoClient;

  /// No description provided for @errAppointmentEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get errAppointmentEndBeforeStart;

  /// No description provided for @errAppointmentFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished appointments cannot be changed.'**
  String get errAppointmentFinished;

  /// No description provided for @errStatusChange.
  ///
  /// In en, this message translates to:
  /// **'This appointment cannot change from {from} to {to}.'**
  String errStatusChange(String from, String to);

  /// No description provided for @errCustomerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found.'**
  String get errCustomerNotFound;

  /// No description provided for @errServiceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Service not found.'**
  String get errServiceNotFound;

  /// No description provided for @errStaffNotFound.
  ///
  /// In en, this message translates to:
  /// **'Staff member not found.'**
  String get errStaffNotFound;

  /// No description provided for @errAppointmentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Appointment not found.'**
  String get errAppointmentNotFound;

  /// No description provided for @errBillNotFound.
  ///
  /// In en, this message translates to:
  /// **'Bill not found.'**
  String get errBillNotFound;

  /// No description provided for @errProductNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get errProductNotFound;

  /// No description provided for @errBillProductMissing.
  ///
  /// In en, this message translates to:
  /// **'A product on this bill no longer exists.'**
  String get errBillProductMissing;

  /// No description provided for @errBillNoLines.
  ///
  /// In en, this message translates to:
  /// **'Add at least one service or product.'**
  String get errBillNoLines;

  /// No description provided for @errLineQtyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Quantity for {name} must be at least 1.'**
  String errLineQtyInvalid(String name);

  /// No description provided for @errLinePriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check the price of {name}.'**
  String errLinePriceInvalid(String name);

  /// No description provided for @errDiscountNegative.
  ///
  /// In en, this message translates to:
  /// **'Discount cannot be negative.'**
  String get errDiscountNegative;

  /// No description provided for @errDiscountOverSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Discount cannot be more than the subtotal.'**
  String get errDiscountOverSubtotal;

  /// No description provided for @errDiscountOverHundred.
  ///
  /// In en, this message translates to:
  /// **'Discount cannot be more than 100%.'**
  String get errDiscountOverHundred;

  /// No description provided for @errBillAlreadyFinalised.
  ///
  /// In en, this message translates to:
  /// **'This bill is already finalised.'**
  String get errBillAlreadyFinalised;

  /// No description provided for @errAppointmentAlreadyBilled.
  ///
  /// In en, this message translates to:
  /// **'This appointment already has a bill.'**
  String get errAppointmentAlreadyBilled;

  /// No description provided for @errAppointmentAlreadyBilledNo.
  ///
  /// In en, this message translates to:
  /// **'This appointment already has a bill ({invoiceNo}).'**
  String errAppointmentAlreadyBilledNo(String invoiceNo);

  /// No description provided for @errPaymentNeedsFinalisedBill.
  ///
  /// In en, this message translates to:
  /// **'Finalise the bill before taking payment.'**
  String get errPaymentNeedsFinalisedBill;

  /// No description provided for @errBillIsVoid.
  ///
  /// In en, this message translates to:
  /// **'This bill is void.'**
  String get errBillIsVoid;

  /// No description provided for @errPaymentMethodRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose how the customer paid.'**
  String get errPaymentMethodRequired;

  /// No description provided for @errPaymentOverBalance.
  ///
  /// In en, this message translates to:
  /// **'Amount is more than the balance due.'**
  String get errPaymentOverBalance;

  /// No description provided for @errOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'{name} is out of stock.'**
  String errOutOfStock(String name);

  /// No description provided for @errNotEnoughStock.
  ///
  /// In en, this message translates to:
  /// **'Only {qty} {name} left in stock.'**
  String errNotEnoughStock(String qty, String name);

  /// No description provided for @errStockChangeZero.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity more than 0.'**
  String get errStockChangeZero;

  /// No description provided for @errStockSalesViaBills.
  ///
  /// In en, this message translates to:
  /// **'Sales change stock through bills.'**
  String get errStockSalesViaBills;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
