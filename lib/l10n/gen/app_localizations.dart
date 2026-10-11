import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

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

  /// Label of the day-of-month dropdown in the birthday/anniversary picker.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get uiDay;

  /// Label of the month dropdown in the birthday/anniversary picker.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get uiMonth;

  /// Small badge/heading saying this app is a demo with sample data.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get uiDemo;

  /// Screen-reader description of the welcome illustration.
  ///
  /// In en, this message translates to:
  /// **'Line drawing of a woman with leaves in her hair'**
  String get welcomeArtLabel;

  /// Welcome headline; keep the line break so it fits on two lines.
  ///
  /// In en, this message translates to:
  /// **'Manage your parlour\nbusiness easily'**
  String get welcomeTagline;

  /// No description provided for @welcomeFeatures.
  ///
  /// In en, this message translates to:
  /// **'Appointments, billing, customers, staff, inventory & reports — all in one place.'**
  String get welcomeFeatures;

  /// Button that opens the app. MyParlour is the brand name; do not translate it.
  ///
  /// In en, this message translates to:
  /// **'Explore MyParlour'**
  String get welcomeExplore;

  /// No description provided for @welcomeSampleData.
  ///
  /// In en, this message translates to:
  /// **'Sample data · no sign-in needed'**
  String get welcomeSampleData;

  /// MyParlour is the brand name; do not translate it.
  ///
  /// In en, this message translates to:
  /// **'MyParlour could not open its data'**
  String get startupErrorTitle;

  /// No description provided for @startupErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check that the phone has free storage space, then try again.'**
  String get startupErrorMessage;

  /// No description provided for @startupScreenError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on this screen. Please go back and try again.'**
  String get startupScreenError;

  /// error is a technical message, shown as is.
  ///
  /// In en, this message translates to:
  /// **'Could not load the dashboard. {error}'**
  String dashLoadError(String error);

  /// No description provided for @dashQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashQuickActions;

  /// No description provided for @dashGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashGreetingMorning;

  /// name is the parlour owner’s name.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String dashGreetingMorningNamed(String name);

  /// No description provided for @dashGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get dashGreetingAfternoon;

  /// name is the parlour owner’s name.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String dashGreetingAfternoonNamed(String name);

  /// No description provided for @dashGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get dashGreetingEvening;

  /// name is the parlour owner’s name.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String dashGreetingEveningNamed(String name);

  /// Heading of the sheet that shows the current parlour (branch).
  ///
  /// In en, this message translates to:
  /// **'Your parlour'**
  String get dashYourParlour;

  /// No description provided for @dashMoreBranches.
  ///
  /// In en, this message translates to:
  /// **'More branches in the full version'**
  String get dashMoreBranches;

  /// Bell button and sheet with low-stock and birthday alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get dashAlerts;

  /// Bell button tooltip when there are alerts to see.
  ///
  /// In en, this message translates to:
  /// **'Alerts (new)'**
  String get dashAlertsNew;

  /// No description provided for @dashNoSalesYesterday.
  ///
  /// In en, this message translates to:
  /// **'No sales yesterday'**
  String get dashNoSalesYesterday;

  /// Change in today’s sales compared with yesterday, e.g. "12% vs yesterday".
  ///
  /// In en, this message translates to:
  /// **'{percent}% vs yesterday'**
  String dashVsYesterday(int percent);

  /// No description provided for @dashTodaysSales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sales'**
  String get dashTodaysSales;

  /// Number of today’s appointments that have not happened yet.
  ///
  /// In en, this message translates to:
  /// **'{count} still to come'**
  String dashStillToCome(int count);

  /// No description provided for @dashPendingPayments.
  ///
  /// In en, this message translates to:
  /// **'Pending payments'**
  String get dashPendingPayments;

  /// Number of unpaid bills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bill due} other{{count} bills due}}'**
  String dashBillsDue(int count);

  /// No description provided for @dashCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get dashCustomers;

  /// No description provided for @dashActiveClients.
  ///
  /// In en, this message translates to:
  /// **'Active clients'**
  String get dashActiveClients;

  /// No description provided for @dashNothingNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs your attention right now.'**
  String get dashNothingNeedsAttention;

  /// No description provided for @dashBirthdaysToday.
  ///
  /// In en, this message translates to:
  /// **'Birthdays today'**
  String get dashBirthdaysToday;

  /// No description provided for @dashWishBirthday.
  ///
  /// In en, this message translates to:
  /// **'Wish them a happy birthday'**
  String get dashWishBirthday;

  /// Low-stock alert level of a product, e.g. "Alert at 3 pcs".
  ///
  /// In en, this message translates to:
  /// **'Alert at {qty} {unit}'**
  String dashAlertAt(int qty, String unit);

  /// Link that opens the list of products to buy again.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get dashRestock;

  /// No description provided for @dashAllWellStocked.
  ///
  /// In en, this message translates to:
  /// **'All products are well stocked.'**
  String get dashAllWellStocked;

  /// No description provided for @dashNextAppointments.
  ///
  /// In en, this message translates to:
  /// **'Next appointments'**
  String get dashNextAppointments;

  /// No description provided for @dashNoMoreToday.
  ///
  /// In en, this message translates to:
  /// **'No more appointments today.'**
  String get dashNoMoreToday;

  /// Button: book a new appointment.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get dashBook;

  /// No description provided for @dashNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get dashNewAppointment;

  /// No description provided for @dashAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get dashAddCustomer;

  /// No description provided for @dashCreateBill.
  ///
  /// In en, this message translates to:
  /// **'Create bill'**
  String get dashCreateBill;

  /// Subtitle under "More": the parlour name and the user’s role.
  ///
  /// In en, this message translates to:
  /// **'{parlour} · Owner'**
  String moreOwnerSubtitle(String parlour);

  /// No description provided for @moreCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get moreCustomers;

  /// No description provided for @moreCustomerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 customer} other{{count} customers}}'**
  String moreCustomerCount(int count);

  /// No description provided for @moreStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get moreStaff;

  /// Number of active staff members.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String moreActiveStaff(int count);

  /// No description provided for @moreServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get moreServices;

  /// No description provided for @moreServiceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 service} other{{count} services}}'**
  String moreServiceCount(int count);

  /// No description provided for @moreInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get moreInventory;

  /// Number of products that are low on stock.
  ///
  /// In en, this message translates to:
  /// **'{count} low'**
  String moreLowCount(int count);

  /// Money spent this month, e.g. "₹12,500 this month".
  ///
  /// In en, this message translates to:
  /// **'{amount} this month'**
  String moreExpensesThisMonth(String amount);

  /// No description provided for @moreReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get moreReports;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// error is a technical message, shown as is.
  ///
  /// In en, this message translates to:
  /// **'Could not load settings. {error}'**
  String settingsLoadError(String error);

  /// No description provided for @settingsResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data?'**
  String get settingsResetTitle;

  /// Beauty Bliss Parlour is the name of the sample parlour; keep it as is.
  ///
  /// In en, this message translates to:
  /// **'All changes are replaced with the original sample data for Beauty Bliss Parlour, dated around today. This cannot be undone.'**
  String get settingsResetMessage;

  /// No description provided for @settingsResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settingsResetConfirm;

  /// No description provided for @settingsResetDone.
  ///
  /// In en, this message translates to:
  /// **'Demo data restored'**
  String get settingsResetDone;

  /// No description provided for @settingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with an empty parlour?'**
  String get settingsEmptyTitle;

  /// resetLabel is the "Reset demo data" button name.
  ///
  /// In en, this message translates to:
  /// **'All customers, services, staff, appointments, bills, products and expenses are removed. Your parlour profile, hours and billing settings are kept. You can bring the sample data back with \"{resetLabel}\".'**
  String settingsEmptyMessage(String resetLabel);

  /// No description provided for @settingsStartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start empty'**
  String get settingsStartEmpty;

  /// No description provided for @settingsEmptyDone.
  ///
  /// In en, this message translates to:
  /// **'Started with an empty parlour'**
  String get settingsEmptyDone;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Parlour profile'**
  String get settingsProfile;

  /// No description provided for @settingsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsName;

  /// No description provided for @settingsOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get settingsOwner;

  /// No description provided for @settingsPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get settingsPhone;

  /// Locality of the parlour in the city, e.g. "MG Road, Pune".
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get settingsArea;

  /// No description provided for @settingsAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get settingsAddress;

  /// No description provided for @settingsBusinessHours.
  ///
  /// In en, this message translates to:
  /// **'Business hours'**
  String get settingsBusinessHours;

  /// No description provided for @settingsOpenDays.
  ///
  /// In en, this message translates to:
  /// **'Open days'**
  String get settingsOpenDays;

  /// Opening and closing time of the parlour.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get settingsHours;

  /// Opening to closing time, e.g. "10:00 AM – 8:00 PM".
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String settingsTimeRange(String from, String to);

  /// Length of the time slots offered when booking an appointment.
  ///
  /// In en, this message translates to:
  /// **'Booking slots'**
  String get settingsBookingSlots;

  /// No description provided for @settingsBillingTax.
  ///
  /// In en, this message translates to:
  /// **'Billing & tax'**
  String get settingsBillingTax;

  /// Letters at the start of every bill number, e.g. "BBP".
  ///
  /// In en, this message translates to:
  /// **'Invoice prefix'**
  String get settingsInvoicePrefix;

  /// Indian Goods and Services Tax.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get settingsGst;

  /// A setting is switched on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsOn;

  /// A setting is switched off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsOff;

  /// GST identification number (Indian tax registration number).
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get settingsGstin;

  /// Default GST rate.
  ///
  /// In en, this message translates to:
  /// **'Default rate'**
  String get settingsDefaultRate;

  /// No description provided for @settingsPricesIncludeGst.
  ///
  /// In en, this message translates to:
  /// **'Prices include GST'**
  String get settingsPricesIncludeGst;

  /// No description provided for @settingsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get settingsYes;

  /// No description provided for @settingsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get settingsNo;

  /// Line of text printed at the bottom of every receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt footer'**
  String get settingsReceiptFooter;

  /// No description provided for @settingsDemoNote.
  ///
  /// In en, this message translates to:
  /// **'This is a demo. Data stays on this phone only.'**
  String get settingsDemoNote;

  /// No description provided for @settingsResetDemo.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data'**
  String get settingsResetDemo;

  /// No description provided for @settingsResetDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Restore the original sample data'**
  String get settingsResetDemoHint;

  /// No description provided for @settingsStartEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Clear everything to try a blank parlour'**
  String get settingsStartEmptyHint;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutNote.
  ///
  /// In en, this message translates to:
  /// **'Sign-in and cloud backup arrive in the full version.'**
  String get settingsAboutNote;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @settingsParlourName.
  ///
  /// In en, this message translates to:
  /// **'Parlour name'**
  String get settingsParlourName;

  /// No description provided for @settingsEnterParlourName.
  ///
  /// In en, this message translates to:
  /// **'Enter the parlour name.'**
  String get settingsEnterParlourName;

  /// No description provided for @settingsOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get settingsOwnerName;

  /// No description provided for @settingsEnterOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Enter the owner’s name.'**
  String get settingsEnterOwnerName;

  /// No description provided for @settingsEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number.'**
  String get settingsEnterPhone;

  /// Example area; translate "e.g." and keep the place names.
  ///
  /// In en, this message translates to:
  /// **'e.g. MG Road, Pune'**
  String get settingsAreaHint;

  /// No description provided for @settingsEnterArea.
  ///
  /// In en, this message translates to:
  /// **'Enter the area.'**
  String get settingsEnterArea;

  /// No description provided for @settingsProfileNote.
  ///
  /// In en, this message translates to:
  /// **'The name, area and phone appear on receipts.'**
  String get settingsProfileNote;

  /// No description provided for @settingsNoOpenDay.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one open day.'**
  String get settingsNoOpenDay;

  /// No description provided for @settingsCloseBeforeOpen.
  ///
  /// In en, this message translates to:
  /// **'Closing time must be after opening time.'**
  String get settingsCloseBeforeOpen;

  /// Opening time of the parlour.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get settingsOpens;

  /// No description provided for @settingsOpeningTime.
  ///
  /// In en, this message translates to:
  /// **'Opening time'**
  String get settingsOpeningTime;

  /// Closing time of the parlour.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get settingsCloses;

  /// No description provided for @settingsClosingTime.
  ///
  /// In en, this message translates to:
  /// **'Closing time'**
  String get settingsClosingTime;

  /// No description provided for @settingsSlotsNote.
  ///
  /// In en, this message translates to:
  /// **'New appointments are offered at these intervals.'**
  String get settingsSlotsNote;

  /// Example invoice prefix; keep "BBP".
  ///
  /// In en, this message translates to:
  /// **'e.g. BBP'**
  String get settingsPrefixHint;

  /// No description provided for @settingsEnterPrefix.
  ///
  /// In en, this message translates to:
  /// **'Enter a prefix.'**
  String get settingsEnterPrefix;

  /// example is a sample bill number such as "BBP/2026-27/0001".
  ///
  /// In en, this message translates to:
  /// **'Bills are numbered like {example}. Numbers already used do not change.'**
  String settingsNumberingNote(String example);

  /// No description provided for @settingsChargeGst.
  ///
  /// In en, this message translates to:
  /// **'Charge GST'**
  String get settingsChargeGst;

  /// No description provided for @settingsChargeGstHint.
  ///
  /// In en, this message translates to:
  /// **'Adds GST to new bills'**
  String get settingsChargeGstHint;

  /// No description provided for @settingsGstinHint.
  ///
  /// In en, this message translates to:
  /// **'15 characters'**
  String get settingsGstinHint;

  /// No description provided for @settingsGstinInvalid.
  ///
  /// In en, this message translates to:
  /// **'A GSTIN has 15 letters and numbers.'**
  String get settingsGstinInvalid;

  /// No description provided for @settingsGstinNote.
  ///
  /// In en, this message translates to:
  /// **'Receipts become \"Tax invoices\" only when a GSTIN is added.'**
  String get settingsGstinNote;

  /// No description provided for @settingsDefaultGstRate.
  ///
  /// In en, this message translates to:
  /// **'Default GST rate'**
  String get settingsDefaultGstRate;

  /// No description provided for @settingsPricesIncludeGstHint.
  ///
  /// In en, this message translates to:
  /// **'Take GST out of the price instead of adding it'**
  String get settingsPricesIncludeGstHint;

  /// No description provided for @settingsEnterFooter.
  ///
  /// In en, this message translates to:
  /// **'Enter a footer.'**
  String get settingsEnterFooter;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expensesAdd;

  /// No description provided for @expensesPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get expensesPreviousMonth;

  /// No description provided for @expensesNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get expensesNextMonth;

  /// No description provided for @expensesTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get expensesTotalSpent;

  /// No description provided for @expensesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses in this month.'**
  String get expensesEmpty;

  /// Screen title for one expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expensesExpense;

  /// No description provided for @expensesNotFound.
  ///
  /// In en, this message translates to:
  /// **'This expense no longer exists.'**
  String get expensesNotFound;

  /// No description provided for @expensesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Expense updated'**
  String get expensesUpdated;

  /// No description provided for @expensesAdded.
  ///
  /// In en, this message translates to:
  /// **'Expense added'**
  String get expensesAdded;

  /// No description provided for @expensesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this expense?'**
  String get expensesDeleteTitle;

  /// e.g. "Rent · ₹15,000 will be removed."
  ///
  /// In en, this message translates to:
  /// **'{category} · {amount} will be removed.'**
  String expensesDeleteMessage(String category, String amount);

  /// No description provided for @expensesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted'**
  String get expensesDeleted;

  /// No description provided for @expensesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get expensesEdit;

  /// No description provided for @expensesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get expensesDelete;

  /// No description provided for @expensesAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expensesAmount;

  /// No description provided for @expensesEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount.'**
  String get expensesEnterAmount;

  /// No description provided for @expensesCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expensesCategory;

  /// No description provided for @expensesDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expensesDate;

  /// No description provided for @expensesChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get expensesChooseDate;

  /// How the expense was paid (cash, UPI, card…).
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get expensesPaidBy;

  /// No description provided for @expensesNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get expensesNote;

  /// No description provided for @expensesNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Shop rent for May'**
  String get expensesNoteHint;

  /// No description provided for @expensesSave.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get expensesSave;

  /// Top bar title of a single appointment screen.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get apptTitle;

  /// Top bar title of the appointments list screen.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get apptListTitle;

  /// No description provided for @apptBook.
  ///
  /// In en, this message translates to:
  /// **'Book appointment'**
  String get apptBook;

  /// No description provided for @apptPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get apptPickDate;

  /// No description provided for @apptFilterByStylist.
  ///
  /// In en, this message translates to:
  /// **'Filter by stylist'**
  String get apptFilterByStylist;

  /// Subtitle when the list is filtered to one stylist.
  ///
  /// In en, this message translates to:
  /// **'Showing {name}'**
  String apptShowingStylist(String name);

  /// No description provided for @apptShowFor.
  ///
  /// In en, this message translates to:
  /// **'Show appointments for'**
  String get apptShowFor;

  /// No description provided for @apptAllStylists.
  ///
  /// In en, this message translates to:
  /// **'All stylists'**
  String get apptAllStylists;

  /// No description provided for @apptStaffInactive.
  ///
  /// In en, this message translates to:
  /// **'{name} (inactive)'**
  String apptStaffInactive(String name);

  /// Filter chip showing appointments of every status.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get apptFilterAll;

  /// Filter chip: status name and how many appointments have it.
  ///
  /// In en, this message translates to:
  /// **'{label} ({count})'**
  String apptFilterCount(String label, int count);

  /// No description provided for @apptLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load appointments. {error}'**
  String apptLoadFailed(String error);

  /// No description provided for @apptNoneOnDay.
  ///
  /// In en, this message translates to:
  /// **'No appointments on this day'**
  String get apptNoneOnDay;

  /// No description provided for @apptNoneUpcomingOnDay.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments on this day'**
  String get apptNoneUpcomingOnDay;

  /// No description provided for @apptNoneCheckedInOnDay.
  ///
  /// In en, this message translates to:
  /// **'No checked in appointments on this day'**
  String get apptNoneCheckedInOnDay;

  /// No description provided for @apptNoneCompletedOnDay.
  ///
  /// In en, this message translates to:
  /// **'No completed appointments on this day'**
  String get apptNoneCompletedOnDay;

  /// No description provided for @apptNoneCancelledOnDay.
  ///
  /// In en, this message translates to:
  /// **'No cancelled appointments on this day'**
  String get apptNoneCancelledOnDay;

  /// No description provided for @apptNoneNoShowOnDay.
  ///
  /// In en, this message translates to:
  /// **'No no-show appointments on this day'**
  String get apptNoneNoShowOnDay;

  /// No description provided for @apptPreviousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get apptPreviousWeek;

  /// No description provided for @apptNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get apptNextWeek;

  /// Screen-reader label of a day in the week strip that has appointments.
  ///
  /// In en, this message translates to:
  /// **'{day}, has bookings'**
  String apptDayHasBookings(String day);

  /// No description provided for @apptNoLongerExists.
  ///
  /// In en, this message translates to:
  /// **'This appointment no longer exists.'**
  String get apptNoLongerExists;

  /// No description provided for @apptDetailLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this appointment. {error}'**
  String apptDetailLoadFailed(String error);

  /// No description provided for @apptMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get apptMoreActions;

  /// Action/button that cancels the appointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get apptCancelAppointment;

  /// No description provided for @apptMarkNoShow.
  ///
  /// In en, this message translates to:
  /// **'Mark no-show'**
  String get apptMarkNoShow;

  /// No description provided for @apptOpenCustomer.
  ///
  /// In en, this message translates to:
  /// **'Open customer'**
  String get apptOpenCustomer;

  /// No description provided for @apptCancelledDone.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled'**
  String get apptCancelledDone;

  /// No description provided for @apptNoShowTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as no-show?'**
  String get apptNoShowTitle;

  /// No description provided for @apptNoShowMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} did not come. This cannot be undone.'**
  String apptNoShowMessage(String name);

  /// No description provided for @apptNoShowDone.
  ///
  /// In en, this message translates to:
  /// **'Marked as no-show'**
  String get apptNoShowDone;

  /// No description provided for @apptServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get apptServices;

  /// No description provided for @apptTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get apptTotal;

  /// No description provided for @apptNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get apptNotes;

  /// No description provided for @apptReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get apptReschedule;

  /// Button: mark that the customer has arrived.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get apptCheckIn;

  /// Message shown after the customer was checked in.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get apptCheckedInDone;

  /// Button: mark the appointment as finished.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get apptComplete;

  /// No description provided for @apptCompletedDone.
  ///
  /// In en, this message translates to:
  /// **'Appointment completed'**
  String get apptCompletedDone;

  /// No description provided for @apptCreateBill.
  ///
  /// In en, this message translates to:
  /// **'Create bill'**
  String get apptCreateBill;

  /// No description provided for @apptViewBill.
  ///
  /// In en, this message translates to:
  /// **'View bill'**
  String get apptViewBill;

  /// No description provided for @apptCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment?'**
  String get apptCancelTitle;

  /// No description provided for @apptCancelReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get apptCancelReasonLabel;

  /// No description provided for @apptCancelReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Or type a reason'**
  String get apptCancelReasonHint;

  /// Button: do not cancel the appointment.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get apptCancelKeep;

  /// No description provided for @apptReasonCustomerCancelled.
  ///
  /// In en, this message translates to:
  /// **'Customer cancelled'**
  String get apptReasonCustomerCancelled;

  /// No description provided for @apptReasonCustomerUnwell.
  ///
  /// In en, this message translates to:
  /// **'Customer unwell'**
  String get apptReasonCustomerUnwell;

  /// No description provided for @apptReasonRescheduledByCustomer.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled by customer'**
  String get apptReasonRescheduledByCustomer;

  /// No description provided for @apptReasonStylistUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Stylist unavailable'**
  String get apptReasonStylistUnavailable;

  /// No description provided for @apptChooseCustomer.
  ///
  /// In en, this message translates to:
  /// **'Choose customer'**
  String get apptChooseCustomer;

  /// Short button that adds a new customer.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get apptNewCustomerShort;

  /// No description provided for @apptSearchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search name or phone'**
  String get apptSearchCustomer;

  /// No description provided for @apptNoCustomerMatch.
  ///
  /// In en, this message translates to:
  /// **'No customer matches your search.'**
  String get apptNoCustomerMatch;

  /// No description provided for @apptAddNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add new customer'**
  String get apptAddNewCustomer;

  /// No description provided for @apptChooseServices.
  ///
  /// In en, this message translates to:
  /// **'Choose services'**
  String get apptChooseServices;

  /// No description provided for @apptSearchServices.
  ///
  /// In en, this message translates to:
  /// **'Search services'**
  String get apptSearchServices;

  /// No description provided for @apptAddServicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 service} other{Add {count} services}}'**
  String apptAddServicesCount(int count);

  /// No description provided for @apptAlreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'{name} is already booked'**
  String apptAlreadyBooked(String name);

  /// No description provided for @apptPickAnotherTime.
  ///
  /// In en, this message translates to:
  /// **'Pick another time'**
  String get apptPickAnotherTime;

  /// No description provided for @apptBookAnyway.
  ///
  /// In en, this message translates to:
  /// **'Book anyway'**
  String get apptBookAnyway;

  /// No description provided for @bookingOnlyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Only upcoming appointments can be rescheduled.'**
  String get bookingOnlyUpcoming;

  /// No description provided for @bookingLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the form. {error}'**
  String bookingLoadFailed(String error);

  /// No description provided for @bookingRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Appointment rescheduled'**
  String get bookingRescheduled;

  /// No description provided for @bookingBooked.
  ///
  /// In en, this message translates to:
  /// **'Appointment booked'**
  String get bookingBooked;

  /// No description provided for @bookingNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get bookingNewTitle;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bookingDate;

  /// No description provided for @bookingChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get bookingChooseDate;

  /// Warning; weekday is a full day name such as Monday (the English adds 's' to make it plural).
  ///
  /// In en, this message translates to:
  /// **'The parlour is usually closed on {weekday}s.'**
  String bookingClosedOn(String weekday);

  /// No description provided for @bookingTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get bookingTime;

  /// No description provided for @bookingNoTimesLeft.
  ///
  /// In en, this message translates to:
  /// **'No times left on this day. Choose another date.'**
  String get bookingNoTimesLeft;

  /// No description provided for @bookingNoStylist.
  ///
  /// In en, this message translates to:
  /// **'No stylist works on this day.'**
  String get bookingNoStylist;

  /// No description provided for @bookingNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Prefers less heat in smoothening'**
  String get bookingNotesHint;

  /// No description provided for @bookingWalkInName.
  ///
  /// In en, this message translates to:
  /// **'Walk-in name'**
  String get bookingWalkInName;

  /// No description provided for @bookingWalkInNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer’s name.'**
  String get bookingWalkInNameRequired;

  /// No description provided for @bookingMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get bookingMobileNumber;

  /// No description provided for @bookingPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number.'**
  String get bookingPhoneInvalid;

  /// No description provided for @bookingChooseSavedCustomer.
  ///
  /// In en, this message translates to:
  /// **'Choose a saved customer instead'**
  String get bookingChooseSavedCustomer;

  /// No description provided for @bookingCustomerRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a customer or add a walk-in.'**
  String get bookingCustomerRequired;

  /// No description provided for @bookingRemoveService.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String bookingRemoveService(String name);

  /// No description provided for @bookingAddServices.
  ///
  /// In en, this message translates to:
  /// **'Add services'**
  String get bookingAddServices;

  /// No description provided for @bookingAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get bookingAddMore;

  /// No description provided for @bookingChooseTimeFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a time first'**
  String get bookingChooseTimeFirst;

  /// Stylist availability: not busy at the chosen time.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get bookingFree;

  /// No description provided for @bookingBusyUntil.
  ///
  /// In en, this message translates to:
  /// **'Busy until {time}'**
  String bookingBusyUntil(String time);

  /// No description provided for @bookingBusyFrom.
  ///
  /// In en, this message translates to:
  /// **'Busy from {time}'**
  String bookingBusyFrom(String time);

  /// Booking summary, e.g. 'Duration 1 h 30 min · ends 6:30 PM'.
  ///
  /// In en, this message translates to:
  /// **'Duration {duration} · ends {time}'**
  String bookingDurationEnds(String duration, String time);

  /// Estimated price of the booking, e.g. 'Estimate ₹1,300'.
  ///
  /// In en, this message translates to:
  /// **'Estimate {amount}'**
  String bookingEstimate(String amount);

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsChoosePeriod.
  ///
  /// In en, this message translates to:
  /// **'Choose period'**
  String get reportsChoosePeriod;

  /// No description provided for @reportsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not build the report. {error}'**
  String reportsLoadFailed(String error);

  /// No description provided for @reportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sales, bills or expenses in this period.'**
  String get reportsEmpty;

  /// No description provided for @reportsTotalSales.
  ///
  /// In en, this message translates to:
  /// **'Total sales'**
  String get reportsTotalSales;

  /// No description provided for @reportsMoneyReceived.
  ///
  /// In en, this message translates to:
  /// **'Money received'**
  String get reportsMoneyReceived;

  /// No description provided for @reportsTotalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get reportsTotalExpenses;

  /// No description provided for @reportsNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net profit (estimate)'**
  String get reportsNetProfit;

  /// No description provided for @reportsSalesMinusExpenses.
  ///
  /// In en, this message translates to:
  /// **'Sales − expenses'**
  String get reportsSalesMinusExpenses;

  /// No description provided for @reportsTotalBills.
  ///
  /// In en, this message translates to:
  /// **'Total bills'**
  String get reportsTotalBills;

  /// No description provided for @reportsBillsCaption.
  ///
  /// In en, this message translates to:
  /// **'Finalised, not void'**
  String get reportsBillsCaption;

  /// No description provided for @reportsSalesOverview.
  ///
  /// In en, this message translates to:
  /// **'Sales overview'**
  String get reportsSalesOverview;

  /// No description provided for @reportsTopServices.
  ///
  /// In en, this message translates to:
  /// **'Top services'**
  String get reportsTopServices;

  /// No description provided for @reportsNoServices.
  ///
  /// In en, this message translates to:
  /// **'No services billed in this period.'**
  String get reportsNoServices;

  /// No description provided for @reportsPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get reportsPaymentMethods;

  /// How many times a service was billed, and the total amount.
  ///
  /// In en, this message translates to:
  /// **'{count} × · {amount}'**
  String reportsServiceCount(int count, String amount);

  /// Chart axis: rupees in thousands, e.g. ₹5k.
  ///
  /// In en, this message translates to:
  /// **'₹{value}k'**
  String reportsCompactThousands(String value);

  /// Chart axis: rupees in lakhs, e.g. ₹1.5L.
  ///
  /// In en, this message translates to:
  /// **'₹{value}L'**
  String reportsCompactLakhs(String value);

  /// No description provided for @custTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get custTitle;

  /// Button, tooltip and screen title for adding a new customer.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get custAdd;

  /// Button, tooltip and screen title for editing a customer.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get custEdit;

  /// No description provided for @custSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or phone'**
  String get custSearchHint;

  /// Sort option: customers with the most recent visit first.
  ///
  /// In en, this message translates to:
  /// **'Recent visit'**
  String get custViewRecent;

  /// Sort option: customers alphabetically.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get custViewAz;

  /// Filter chip showing deactivated customers, with their count.
  ///
  /// In en, this message translates to:
  /// **'Inactive ({count})'**
  String custViewInactive(int count);

  /// No description provided for @custLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load customers. {error}'**
  String custLoadError(String error);

  /// No description provided for @custNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No customer matches your search.'**
  String get custNoMatch;

  /// No description provided for @custNoInactive.
  ///
  /// In en, this message translates to:
  /// **'No inactive customers.'**
  String get custNoInactive;

  /// No description provided for @custEmpty.
  ///
  /// In en, this message translates to:
  /// **'No customers yet.'**
  String get custEmpty;

  /// Caption under a customer in the list: number of completed visits and when the last one was. 'last' is custLastVisit or custNoVisitsYet.
  ///
  /// In en, this message translates to:
  /// **'{visits, plural, =0{No visits yet} =1{1 visit · {last}} other{{visits} visits · {last}}}'**
  String custRowCaption(int visits, String last);

  /// Part of the customer row caption, e.g. 'last 12 May'.
  ///
  /// In en, this message translates to:
  /// **'last {date}'**
  String custLastVisit(String date);

  /// Part of the customer row caption (lower case, after a middle dot).
  ///
  /// In en, this message translates to:
  /// **'no visits yet'**
  String get custNoVisitsYet;

  /// No description provided for @custNotFound.
  ///
  /// In en, this message translates to:
  /// **'This customer no longer exists.'**
  String get custNotFound;

  /// No description provided for @custLoadOneError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this customer. {error}'**
  String custLoadOneError(String error);

  /// No description provided for @custShareContact.
  ///
  /// In en, this message translates to:
  /// **'Share contact'**
  String get custShareContact;

  /// No description provided for @custDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate customer'**
  String get custDeactivate;

  /// No description provided for @custReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate customer'**
  String get custReactivate;

  /// Confirm dialog title; name is the customer's name.
  ///
  /// In en, this message translates to:
  /// **'Deactivate {name}?'**
  String custDeactivateTitle(String name);

  /// No description provided for @custDeactivateMessage.
  ///
  /// In en, this message translates to:
  /// **'They will be hidden from the customer list and booking. Their history is kept, and you can reactivate them later.'**
  String get custDeactivateMessage;

  /// No description provided for @custDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Customer deactivated'**
  String get custDeactivated;

  /// No description provided for @custReactivated.
  ///
  /// In en, this message translates to:
  /// **'Customer reactivated'**
  String get custReactivated;

  /// Round action button on the customer screen that opens more options (share, edit, deactivate).
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get custActionMore;

  /// No description provided for @custTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get custTabHistory;

  /// No description provided for @custTabDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get custTabDetails;

  /// Customer notes: tab title and form field label.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get custNotes;

  /// No description provided for @custNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get custNewAppointment;

  /// No description provided for @custSaved.
  ///
  /// In en, this message translates to:
  /// **'Customer saved'**
  String get custSaved;

  /// No description provided for @custUpdated.
  ///
  /// In en, this message translates to:
  /// **'Customer updated'**
  String get custUpdated;

  /// No description provided for @custFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get custFieldName;

  /// No description provided for @custNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Priya Sharma'**
  String get custNameHint;

  /// No description provided for @custNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer’s name.'**
  String get custNameRequired;

  /// No description provided for @custFieldMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get custFieldMobile;

  /// No description provided for @custMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the mobile number.'**
  String get custMobileRequired;

  /// No description provided for @custMobileInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number.'**
  String get custMobileInvalid;

  /// No description provided for @custBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get custBirthday;

  /// No description provided for @custAnniversary.
  ///
  /// In en, this message translates to:
  /// **'Anniversary'**
  String get custAnniversary;

  /// No description provided for @custDayMonthHint.
  ///
  /// In en, this message translates to:
  /// **'Day and month'**
  String get custDayMonthHint;

  /// No description provided for @custNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Prefers less heat in smoothening'**
  String get custNotesHint;

  /// No description provided for @custEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get custEmail;

  /// No description provided for @custEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get custEmailInvalid;

  /// No description provided for @custSave.
  ///
  /// In en, this message translates to:
  /// **'Save customer'**
  String get custSave;

  /// No description provided for @custSaveAndBook.
  ///
  /// In en, this message translates to:
  /// **'Save & book appointment'**
  String get custSaveAndBook;

  /// Warning when the typed mobile number belongs to an existing customer.
  ///
  /// In en, this message translates to:
  /// **'Already saved as {name}'**
  String custAlreadySaved(String name);

  /// Button to open the existing customer with the same number.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get custOpen;

  /// No description provided for @custMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get custMobile;

  /// No description provided for @custSince.
  ///
  /// In en, this message translates to:
  /// **'Customer since'**
  String get custSince;

  /// No description provided for @custVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get custVisits;

  /// No description provided for @custTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get custTotalSpent;

  /// No description provided for @custHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No visits or bills yet.'**
  String get custHistoryEmpty;

  /// No description provided for @custNotesSaved.
  ///
  /// In en, this message translates to:
  /// **'Notes saved'**
  String get custNotesSaved;

  /// No description provided for @custNotesTabHint.
  ///
  /// In en, this message translates to:
  /// **'Preferences, allergies, favourite stylist… (e.g. Prefers less heat in smoothening)'**
  String get custNotesTabHint;

  /// No description provided for @custSaveNotes.
  ///
  /// In en, this message translates to:
  /// **'Save notes'**
  String get custSaveNotes;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// Button, tooltip and screen title for adding a service.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get servicesAdd;

  /// No description provided for @servicesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get servicesEdit;

  /// No description provided for @servicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No services yet. Add what your parlour offers.'**
  String get servicesEmpty;

  /// No description provided for @servicesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load services. {error}'**
  String servicesLoadError(String error);

  /// No description provided for @servicesNewCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get servicesNewCategory;

  /// No description provided for @servicesNewCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bridal'**
  String get servicesNewCategoryHint;

  /// No description provided for @servicesAdded.
  ///
  /// In en, this message translates to:
  /// **'Service added'**
  String get servicesAdded;

  /// No description provided for @servicesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Service updated'**
  String get servicesUpdated;

  /// Confirm dialog title; name is the service name.
  ///
  /// In en, this message translates to:
  /// **'Deactivate {name}?'**
  String servicesDeactivateTitle(String name);

  /// No description provided for @servicesDeactivateMessage.
  ///
  /// In en, this message translates to:
  /// **'It will no longer be offered for new bookings or bills. Past appointments and bills keep it.'**
  String get servicesDeactivateMessage;

  /// No description provided for @servicesDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Service deactivated'**
  String get servicesDeactivated;

  /// No description provided for @servicesReactivated.
  ///
  /// In en, this message translates to:
  /// **'Service reactivated'**
  String get servicesReactivated;

  /// No description provided for @servicesFieldName.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get servicesFieldName;

  /// No description provided for @servicesNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Haircut'**
  String get servicesNameHint;

  /// No description provided for @servicesCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get servicesCategory;

  /// No description provided for @servicesPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get servicesPrice;

  /// No description provided for @servicesPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the price in rupees.'**
  String get servicesPriceInvalid;

  /// No description provided for @servicesDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get servicesDuration;

  /// Duration chip to type a custom number of minutes.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get servicesCustomDuration;

  /// No description provided for @servicesMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get servicesMinutes;

  /// No description provided for @servicesMinutesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 75'**
  String get servicesMinutesHint;

  /// No description provided for @servicesMinutesRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the minutes.'**
  String get servicesMinutesRequired;

  /// No description provided for @servicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get servicesDescription;

  /// No description provided for @servicesGstRate.
  ///
  /// In en, this message translates to:
  /// **'GST rate'**
  String get servicesGstRate;

  /// No description provided for @servicesGstNote.
  ///
  /// In en, this message translates to:
  /// **'Used only when GST is turned on in Settings.'**
  String get servicesGstNote;

  /// No description provided for @servicesDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate service'**
  String get servicesDeactivate;

  /// No description provided for @servicesReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate service'**
  String get servicesReactivate;

  /// No description provided for @servicesSave.
  ///
  /// In en, this message translates to:
  /// **'Save service'**
  String get servicesSave;

  /// Screen title when a service cannot be shown.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get servicesService;

  /// No description provided for @servicesNotFound.
  ///
  /// In en, this message translates to:
  /// **'This service no longer exists.'**
  String get servicesNotFound;

  /// No description provided for @servicesLoadOneError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this service. {error}'**
  String servicesLoadOneError(String error);

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffTitle;

  /// Button, tooltip and screen title for adding a staff member.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get staffAdd;

  /// No description provided for @staffEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit staff'**
  String get staffEdit;

  /// No description provided for @staffSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, role or phone'**
  String get staffSearchHint;

  /// No description provided for @staffLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load staff. {error}'**
  String staffLoadError(String error);

  /// No description provided for @staffNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No staff member matches your search.'**
  String get staffNoMatch;

  /// No description provided for @staffEmpty.
  ///
  /// In en, this message translates to:
  /// **'No staff yet.'**
  String get staffEmpty;

  /// No description provided for @staffNotFound.
  ///
  /// In en, this message translates to:
  /// **'This staff member no longer exists.'**
  String get staffNotFound;

  /// Confirm dialog title; name is the staff member's name.
  ///
  /// In en, this message translates to:
  /// **'Deactivate {name}?'**
  String staffDeactivateTitle(String name);

  /// No description provided for @staffDeactivateMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} will not be offered for new bookings. Past appointments and bills keep their name. You can reactivate later.'**
  String staffDeactivateMessage(String name);

  /// No description provided for @staffDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Staff deactivated'**
  String get staffDeactivated;

  /// No description provided for @staffActivated.
  ///
  /// In en, this message translates to:
  /// **'Staff activated'**
  String get staffActivated;

  /// Button to make an inactive staff member active again.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get staffActivate;

  /// No description provided for @staffMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get staffMobile;

  /// Row label before the staff member's working days, e.g. 'Mon, Tue, Wed'.
  ///
  /// In en, this message translates to:
  /// **'Works'**
  String get staffWorks;

  /// No description provided for @staffHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get staffHours;

  /// Row label before the services this staff member does.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get staffServices;

  /// Working hours, e.g. '10:00 AM – 8:00 PM'.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String staffHoursRange(String start, String end);

  /// No description provided for @staffServicesDone.
  ///
  /// In en, this message translates to:
  /// **'Services done'**
  String get staffServicesDone;

  /// No description provided for @staffAmountBilled.
  ///
  /// In en, this message translates to:
  /// **'Amount billed'**
  String get staffAmountBilled;

  /// No description provided for @staffTodayAndUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Today and upcoming'**
  String get staffTodayAndUpcoming;

  /// No description provided for @staffNoAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments booked.'**
  String get staffNoAppointments;

  /// No description provided for @staffFormLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this form. Please try again.'**
  String get staffFormLoadError;

  /// No description provided for @staffAdded.
  ///
  /// In en, this message translates to:
  /// **'Staff added'**
  String get staffAdded;

  /// No description provided for @staffUpdated.
  ///
  /// In en, this message translates to:
  /// **'Staff updated'**
  String get staffUpdated;

  /// No description provided for @staffFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get staffFieldName;

  /// No description provided for @staffFieldMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get staffFieldMobile;

  /// No description provided for @staffMobileInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number.'**
  String get staffMobileInvalid;

  /// No description provided for @staffRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get staffRole;

  /// No description provided for @staffServicesTheyDo.
  ///
  /// In en, this message translates to:
  /// **'Services they do'**
  String get staffServicesTheyDo;

  /// No description provided for @staffClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get staffClearAll;

  /// No description provided for @staffTickAll.
  ///
  /// In en, this message translates to:
  /// **'Tick all'**
  String get staffTickAll;

  /// No description provided for @staffWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get staffWorkingDays;

  /// No description provided for @staffStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get staffStarts;

  /// No description provided for @staffStartHint.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get staffStartHint;

  /// No description provided for @staffEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get staffEnds;

  /// No description provided for @staffEndHint.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get staffEndHint;

  /// No description provided for @staffNoWorkingDay.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one working day.'**
  String get staffNoWorkingDay;

  /// No description provided for @staffSave.
  ///
  /// In en, this message translates to:
  /// **'Save staff'**
  String get staffSave;

  /// No description provided for @billingNewBill.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get billingNewBill;

  /// No description provided for @billingOpenBills.
  ///
  /// In en, this message translates to:
  /// **'Open bills'**
  String get billingOpenBills;

  /// No description provided for @billingAllBills.
  ///
  /// In en, this message translates to:
  /// **'All bills'**
  String get billingAllBills;

  /// No description provided for @billingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load bills. {error}'**
  String billingLoadError(String error);

  /// No description provided for @billingNoOpenBills.
  ///
  /// In en, this message translates to:
  /// **'No open bills. Everything is paid.'**
  String get billingNoOpenBills;

  /// No description provided for @billingNoBills.
  ///
  /// In en, this message translates to:
  /// **'No bills yet.'**
  String get billingNoBills;

  /// Shown instead of a bill number for a bill that is not finalised yet.
  ///
  /// In en, this message translates to:
  /// **'Draft bill'**
  String get billingDraftBill;

  /// Amount still to be paid on a bill, e.g. 'Due ₹355'.
  ///
  /// In en, this message translates to:
  /// **'Due {amount}'**
  String billingDue(String amount);

  /// Screen title / fallback name for a bill (noun).
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get billingBill;

  /// Button: open (view) the bill. 'Open' is a verb here.
  ///
  /// In en, this message translates to:
  /// **'Open bill'**
  String get billingOpenBill;

  /// No description provided for @billingNoLongerDraft.
  ///
  /// In en, this message translates to:
  /// **'This bill is no longer a draft.'**
  String get billingNoLongerDraft;

  /// No description provided for @billingOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the bill. {error}'**
  String billingOpenError(String error);

  /// No description provided for @billingEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number.'**
  String get billingEnterNumber;

  /// No description provided for @billingChooseSavedCustomer.
  ///
  /// In en, this message translates to:
  /// **'Choose a saved customer'**
  String get billingChooseSavedCustomer;

  /// No description provided for @billingWalkInName.
  ///
  /// In en, this message translates to:
  /// **'Walk-in name'**
  String get billingWalkInName;

  /// No description provided for @billingWalkInNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Kiran'**
  String get billingWalkInNameHint;

  /// No description provided for @billingCheckDiscount.
  ///
  /// In en, this message translates to:
  /// **'Check the discount.'**
  String get billingCheckDiscount;

  /// No description provided for @billingDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get billingDraftSaved;

  /// No description provided for @billingSavedNothingToPay.
  ///
  /// In en, this message translates to:
  /// **'{invoiceNo} saved. Nothing to pay.'**
  String billingSavedNothingToPay(String invoiceNo);

  /// No description provided for @billingCreateBill.
  ///
  /// In en, this message translates to:
  /// **'Create bill'**
  String get billingCreateBill;

  /// Button: change the customer on the bill (verb).
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get billingChange;

  /// No description provided for @billingItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get billingItems;

  /// No description provided for @billingSwipeToRemove.
  ///
  /// In en, this message translates to:
  /// **'Swipe a line left to remove it.'**
  String get billingSwipeToRemove;

  /// No description provided for @billingAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add service or product'**
  String get billingAddItem;

  /// No description provided for @billingDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get billingDiscount;

  /// No description provided for @billingDiscountHintPercent.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get billingDiscountHintPercent;

  /// No description provided for @billingDiscountHintAmount.
  ///
  /// In en, this message translates to:
  /// **'e.g. 300'**
  String get billingDiscountHintAmount;

  /// No description provided for @billingSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get billingSaveDraft;

  /// No description provided for @billingProceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to payment'**
  String get billingProceedToPayment;

  /// No description provided for @billingBillGone.
  ///
  /// In en, this message translates to:
  /// **'This bill no longer exists.'**
  String get billingBillGone;

  /// No description provided for @billingLoadBillError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this bill. {error}'**
  String billingLoadBillError(String error);

  /// No description provided for @billingVoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Void this bill?'**
  String get billingVoidTitle;

  /// No description provided for @billingVoidMessage.
  ///
  /// In en, this message translates to:
  /// **'The bill and its payments will be marked void and any products sold go back into stock. The bill number is not reused.'**
  String get billingVoidMessage;

  /// Action (verb): cancel this bill.
  ///
  /// In en, this message translates to:
  /// **'Void bill'**
  String get billingVoidBill;

  /// No description provided for @billingVoided.
  ///
  /// In en, this message translates to:
  /// **'Bill voided'**
  String get billingVoided;

  /// No description provided for @billingMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get billingMoreActions;

  /// No description provided for @billingPrintReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print receipt'**
  String get billingPrintReceipt;

  /// No description provided for @billingDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get billingDownloadPdf;

  /// No description provided for @billingVoidBanner.
  ///
  /// In en, this message translates to:
  /// **'This bill is void. Its payments are not counted and its products went back into stock.'**
  String get billingVoidBanner;

  /// Row label in the totals: the amount already paid (not the bill status).
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billingPaidAmount;

  /// No description provided for @billingBalanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance due'**
  String get billingBalanceDue;

  /// No description provided for @billingPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get billingPayments;

  /// Lower-case marker after a cancelled payment's date, e.g. '14 May, 4:12 PM · void'.
  ///
  /// In en, this message translates to:
  /// **'void'**
  String get billingVoidTag;

  /// No description provided for @billingShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get billingShare;

  /// No description provided for @billingRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get billingRecordPayment;

  /// No description provided for @billingShareReceiptWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share receipt on WhatsApp'**
  String get billingShareReceiptWhatsApp;

  /// No description provided for @billingStylistName.
  ///
  /// In en, this message translates to:
  /// **'Stylist: {name}'**
  String billingStylistName(String name);

  /// No description provided for @billingAddToBill.
  ///
  /// In en, this message translates to:
  /// **'Add to bill'**
  String get billingAddToBill;

  /// No description provided for @billingSearchItems.
  ///
  /// In en, this message translates to:
  /// **'Search services or products'**
  String get billingSearchItems;

  /// No description provided for @billingServicesTab.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get billingServicesTab;

  /// No description provided for @billingProductsTab.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get billingProductsTab;

  /// No description provided for @billingNoSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'No selling price set'**
  String get billingNoSellingPrice;

  /// No description provided for @billingInStockCount.
  ///
  /// In en, this message translates to:
  /// **'In stock: {count}'**
  String billingInStockCount(int count);

  /// No description provided for @billingNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches your search.'**
  String get billingNoMatch;

  /// Text sent along with the shared receipt PDF.
  ///
  /// In en, this message translates to:
  /// **'Receipt from {parlour}'**
  String billingReceiptShareText(String parlour);

  /// No description provided for @billingShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open sharing on this phone.'**
  String get billingShareFailed;

  /// No description provided for @billingPrintFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open printing on this phone.'**
  String get billingPrintFailed;

  /// No description provided for @billingDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the PDF on this phone.'**
  String get billingDownloadFailed;

  /// No description provided for @billingReceiptFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the receipt.'**
  String get billingReceiptFailed;

  /// No description provided for @billingSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get billingSubtotal;

  /// No description provided for @billingGst.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get billingGst;

  /// No description provided for @billingTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get billingTotal;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @paymentFinishBillFirst.
  ///
  /// In en, this message translates to:
  /// **'Finish the bill before taking payment.'**
  String get paymentFinishBillFirst;

  /// No description provided for @paymentFullyPaid.
  ///
  /// In en, this message translates to:
  /// **'This bill is fully paid.'**
  String get paymentFullyPaid;

  /// No description provided for @paymentEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount received.'**
  String get paymentEnterAmount;

  /// No description provided for @paymentFullBalance.
  ///
  /// In en, this message translates to:
  /// **'Full balance'**
  String get paymentFullBalance;

  /// No description provided for @paymentPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial · {amount} will still be due'**
  String paymentPartial(String amount);

  /// No description provided for @paymentBillTotal.
  ///
  /// In en, this message translates to:
  /// **'Bill total'**
  String get paymentBillTotal;

  /// No description provided for @paymentAlreadyReceived.
  ///
  /// In en, this message translates to:
  /// **'Already received'**
  String get paymentAlreadyReceived;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodLabel;

  /// No description provided for @paymentUpiNote.
  ///
  /// In en, this message translates to:
  /// **'Records the payment; the app does not verify UPI.'**
  String get paymentUpiNote;

  /// No description provided for @paymentAmountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get paymentAmountReceived;

  /// No description provided for @paymentNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get paymentNote;

  /// No description provided for @paymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get paymentConfirm;

  /// No description provided for @paymentConfirmAmount.
  ///
  /// In en, this message translates to:
  /// **'Confirm {amount}'**
  String paymentConfirmAmount(String amount);

  /// No description provided for @paymentNotFound.
  ///
  /// In en, this message translates to:
  /// **'This payment could not be found.'**
  String get paymentNotFound;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded'**
  String get paymentRecorded;

  /// e.g. '₹500 by Cash'.
  ///
  /// In en, this message translates to:
  /// **'{amount} by {method}'**
  String paymentAmountByMethod(String amount, String method);

  /// No description provided for @paymentTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total {amount}'**
  String paymentTotalAmount(String amount);

  /// No description provided for @paymentBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get paymentBalance;

  /// No description provided for @paymentBookNextVisit.
  ///
  /// In en, this message translates to:
  /// **'Book next visit'**
  String get paymentBookNextVisit;

  /// No description provided for @paymentBackToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get paymentBackToDashboard;

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTitle;

  /// No description provided for @inventoryAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get inventoryAddProduct;

  /// No description provided for @inventorySearch.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get inventorySearch;

  /// No description provided for @inventoryAllItems.
  ///
  /// In en, this message translates to:
  /// **'All items'**
  String get inventoryAllItems;

  /// Tab title with the number of products, e.g. 'Low stock (2)'.
  ///
  /// In en, this message translates to:
  /// **'{label} ({count})'**
  String inventoryTabCount(String label, int count);

  /// No description provided for @inventoryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load products. {error}'**
  String inventoryLoadError(String error);

  /// No description provided for @inventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet.'**
  String get inventoryEmpty;

  /// No description provided for @inventoryNoneLow.
  ///
  /// In en, this message translates to:
  /// **'Nothing is running low.'**
  String get inventoryNoneLow;

  /// No description provided for @inventoryNoneOut.
  ///
  /// In en, this message translates to:
  /// **'Nothing is out of stock.'**
  String get inventoryNoneOut;

  /// No description provided for @inventoryProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get inventoryProduct;

  /// No description provided for @inventoryProductGone.
  ///
  /// In en, this message translates to:
  /// **'This product no longer exists.'**
  String get inventoryProductGone;

  /// No description provided for @inventoryEditProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get inventoryEditProduct;

  /// Row label: quantity currently in stock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get inventoryInStockLabel;

  /// No description provided for @inventoryLowStockAlertAt.
  ///
  /// In en, this message translates to:
  /// **'Low-stock alert at'**
  String get inventoryLowStockAlertAt;

  /// No description provided for @inventorySellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price'**
  String get inventorySellingPrice;

  /// No description provided for @inventoryNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get inventoryNotSet;

  /// No description provided for @inventoryCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost price'**
  String get inventoryCostPrice;

  /// No description provided for @inventoryStockHistory.
  ///
  /// In en, this message translates to:
  /// **'Stock history'**
  String get inventoryStockHistory;

  /// No description provided for @inventoryNoStockChanges.
  ///
  /// In en, this message translates to:
  /// **'No stock changes yet.'**
  String get inventoryNoStockChanges;

  /// No description provided for @inventoryAdjustStock.
  ///
  /// In en, this message translates to:
  /// **'Adjust stock'**
  String get inventoryAdjustStock;

  /// No description provided for @inventoryProductUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get inventoryProductUpdated;

  /// No description provided for @inventoryProductAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added'**
  String get inventoryProductAdded;

  /// No description provided for @inventoryDeactivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate {name}?'**
  String inventoryDeactivateTitle(String name);

  /// No description provided for @inventoryDeactivateMessage.
  ///
  /// In en, this message translates to:
  /// **'It will no longer be offered on bills. Its stock history is kept.'**
  String get inventoryDeactivateMessage;

  /// No description provided for @inventoryDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Product deactivated'**
  String get inventoryDeactivated;

  /// No description provided for @inventoryReactivated.
  ///
  /// In en, this message translates to:
  /// **'Product reactivated'**
  String get inventoryReactivated;

  /// No description provided for @inventoryEnterOpeningStock.
  ///
  /// In en, this message translates to:
  /// **'Enter the opening stock.'**
  String get inventoryEnterOpeningStock;

  /// No description provided for @inventoryEnterAlertLevel.
  ///
  /// In en, this message translates to:
  /// **'Enter the alert level.'**
  String get inventoryEnterAlertLevel;

  /// No description provided for @inventoryEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a price in rupees.'**
  String get inventoryEnterPrice;

  /// No description provided for @inventoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inventoryName;

  /// No description provided for @inventoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hair Serum'**
  String get inventoryNameHint;

  /// No description provided for @inventoryStockInfo.
  ///
  /// In en, this message translates to:
  /// **'In stock: {qty} {unit}. Use \"Adjust stock\" on the product screen to change it.'**
  String inventoryStockInfo(int qty, String unit);

  /// No description provided for @inventoryOpeningStock.
  ///
  /// In en, this message translates to:
  /// **'Opening stock'**
  String get inventoryOpeningStock;

  /// No description provided for @inventoryOpeningStockHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get inventoryOpeningStockHint;

  /// No description provided for @inventoryUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get inventoryUnit;

  /// No description provided for @inventoryCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get inventoryCategory;

  /// No description provided for @inventoryCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hair care'**
  String get inventoryCategoryHint;

  /// No description provided for @inventoryDeactivateProduct.
  ///
  /// In en, this message translates to:
  /// **'Deactivate product'**
  String get inventoryDeactivateProduct;

  /// No description provided for @inventoryReactivateProduct.
  ///
  /// In en, this message translates to:
  /// **'Reactivate product'**
  String get inventoryReactivateProduct;

  /// No description provided for @inventorySaveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save product'**
  String get inventorySaveProduct;

  /// No description provided for @inventoryOnlyInStock.
  ///
  /// In en, this message translates to:
  /// **'Only {count} in stock.'**
  String inventoryOnlyInStock(int count);

  /// No description provided for @inventorySameAsCurrent.
  ///
  /// In en, this message translates to:
  /// **'That is the same as the current stock.'**
  String get inventorySameAsCurrent;

  /// No description provided for @inventoryStockUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stock updated'**
  String get inventoryStockUpdated;

  /// No description provided for @inventoryAdjustSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name} · now {qty} {unit}'**
  String inventoryAdjustSubtitle(String name, int qty, String unit);

  /// Field label: kind of stock change (noun).
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get inventoryAdjustType;

  /// No description provided for @inventoryCountedQty.
  ///
  /// In en, this message translates to:
  /// **'Counted quantity'**
  String get inventoryCountedQty;

  /// No description provided for @inventoryQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get inventoryQty;

  /// No description provided for @inventoryNewStock.
  ///
  /// In en, this message translates to:
  /// **'New stock: {qty} {unit}'**
  String inventoryNewStock(int qty, String unit);

  /// No description provided for @inventoryNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get inventoryNote;

  /// No description provided for @inventoryNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bought from supplier'**
  String get inventoryNoteHint;

  /// No description provided for @inventoryStockLine.
  ///
  /// In en, this message translates to:
  /// **'Stock: {qty} {unit}'**
  String inventoryStockLine(int qty, String unit);

  /// Parlour phone line at the top of the printed receipt.
  ///
  /// In en, this message translates to:
  /// **'Phone {phone}'**
  String receiptPhone(String phone);

  /// No description provided for @receiptGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN {gstin}'**
  String receiptGstin(String gstin);

  /// Heading of a receipt when GST is charged. Capital letters in English.
  ///
  /// In en, this message translates to:
  /// **'TAX INVOICE'**
  String get receiptTaxInvoice;

  /// Heading of a plain payment receipt. Capital letters in English.
  ///
  /// In en, this message translates to:
  /// **'RECEIPT'**
  String get receiptHeading;

  /// Receipt table column: the service or product.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get receiptItem;

  /// Receipt table column: quantity (short).
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get receiptQty;

  /// Receipt table column: price of one.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get receiptRate;

  /// Receipt table column: rate × quantity.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get receiptAmount;

  /// No description provided for @receiptStylist.
  ///
  /// In en, this message translates to:
  /// **'Stylist: {name}'**
  String receiptStylist(String name);

  /// No description provided for @receiptSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get receiptSubtotal;

  /// No description provided for @receiptDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get receiptDiscount;

  /// No description provided for @receiptGst.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get receiptGst;

  /// No description provided for @receiptTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get receiptTotal;

  /// Receipt row: amount paid so far.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get receiptPaid;

  /// Receipt row: amount still to pay.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get receiptBalance;

  /// No description provided for @receiptPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get receiptPayments;

  /// No description provided for @receiptNotTaxInvoice.
  ///
  /// In en, this message translates to:
  /// **'This is a payment receipt, not a GST tax invoice.'**
  String get receiptNotTaxInvoice;
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
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
