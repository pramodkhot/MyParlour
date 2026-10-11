// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'MyParlour';

  @override
  String get navDashboard => 'डॅशबोर्ड';

  @override
  String get navAppointments => 'अपॉइंटमेंट';

  @override
  String get navBilling => 'बिलिंग';

  @override
  String get navMore => 'अधिक';

  @override
  String get commonCancel => 'रद्द करा';

  @override
  String get commonSave => 'सेव्ह करा';

  @override
  String get commonSaveChanges => 'बदल सेव्ह करा';

  @override
  String get commonDelete => 'काढून टाका';

  @override
  String get commonEdit => 'बदला';

  @override
  String get commonDone => 'झाले';

  @override
  String get commonAdd => 'जोडा';

  @override
  String get commonClose => 'बंद करा';

  @override
  String get commonTryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get commonOptional => '(ऐच्छिक)';

  @override
  String get commonClearSearch => 'शोध पुसा';

  @override
  String commonClearField(String label) {
    return '$label पुसा';
  }

  @override
  String get commonDecrease => 'कमी करा';

  @override
  String get commonIncrease => 'वाढवा';

  @override
  String get commonMoreDetails => 'अधिक माहिती';

  @override
  String get commonSeeAll => 'सर्व पाहा';

  @override
  String get commonNone => 'काही नाही';

  @override
  String get commonNotAdded => 'जोडलेले नाही';

  @override
  String get commonInactive => 'बंद';

  @override
  String get commonActive => 'सुरू';

  @override
  String get commonDeactivate => 'बंद करा';

  @override
  String get commonReactivate => 'पुन्हा सुरू करा';

  @override
  String get commonWalkIn => 'वॉक-इन';

  @override
  String commonWalkInNamed(String name) {
    return 'वॉक-इन · $name';
  }

  @override
  String get commonWalkInCustomer => 'वॉक-इन ग्राहक';

  @override
  String get commonGuest => 'गेस्ट';

  @override
  String get commonCustomer => 'ग्राहक';

  @override
  String get commonStylist => 'स्टायलिस्ट';

  @override
  String commonNoAppFor(String what) {
    return '$what उघडण्यासाठी या फोनवर कोणतेही ॲप नाही.';
  }

  @override
  String get commonAppCalls => 'कॉल';

  @override
  String get commonAppWhatsApp => 'WhatsApp लिंक';

  @override
  String get commonAppMessages => 'मेसेज';

  @override
  String get commonAppSharing => 'शेअरिंग';

  @override
  String get commonCall => 'कॉल';

  @override
  String get commonWhatsApp => 'WhatsApp';

  @override
  String get commonSms => 'SMS';

  @override
  String get commonFillRequired => '* खूण असलेली माहिती भरा.';

  @override
  String commonMinutes(int count) {
    return '$count मि';
  }

  @override
  String commonHours(int count) {
    return '$count तास';
  }

  @override
  String commonHoursMinutes(int hours, String minutes) {
    return '$hours तास $minutes';
  }

  @override
  String get discardTitle => 'बदल सोडून द्यायचे?';

  @override
  String get discardMessage => 'या स्क्रीनवर टाकलेली माहिती सेव्ह होणार नाही.';

  @override
  String get discardConfirm => 'सोडून द्या';

  @override
  String get discardKeep => 'बदल करत राहा';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageChanged => 'भाषा बदलली';

  @override
  String get statusUpcoming => 'येणारी';

  @override
  String get statusCheckedIn => 'आल्या';

  @override
  String get statusCompleted => 'पूर्ण';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get statusNoShow => 'आल्या नाहीत';

  @override
  String get billStatusDraft => 'ड्राफ्ट';

  @override
  String get billStatusUnpaid => 'बाकी';

  @override
  String get billStatusPartiallyPaid => 'अंशतः भरले';

  @override
  String get billStatusPaid => 'भरले';

  @override
  String get billStatusVoid => 'रद्द';

  @override
  String get payCash => 'रोख';

  @override
  String get payUpi => 'UPI';

  @override
  String get payCard => 'कार्ड';

  @override
  String get payOther => 'इतर';

  @override
  String get payRefUpi => 'UPI रेफ';

  @override
  String get payRefCard => 'कार्डचे शेवटचे 4';

  @override
  String get payRefOther => 'रेफरन्स';

  @override
  String get stockInStock => 'स्टॉकमध्ये आहे';

  @override
  String get stockLow => 'कमी स्टॉक';

  @override
  String get stockOut => 'स्टॉक संपला';

  @override
  String stockLeft(int count) {
    return '$count शिल्लक';
  }

  @override
  String get reasonPurchase => 'स्टॉक आला';

  @override
  String get reasonSale => 'बिलावर विकले';

  @override
  String get reasonUsedInService => 'सर्व्हिसमध्ये वापरले';

  @override
  String get reasonDamaged => 'खराब / एक्सपायर';

  @override
  String get reasonCorrection => 'मोजणी दुरुस्ती';

  @override
  String get reasonVoidReversal => 'बिल रद्द (परत आले)';

  @override
  String get periodToday => 'आज';

  @override
  String get periodThisWeek => 'या आठवड्यात';

  @override
  String get periodThisMonth => 'या महिन्यात';

  @override
  String get periodCustom => 'तारखा निवडा';

  @override
  String get unitPcs => 'नग';

  @override
  String get unitMl => 'ml';

  @override
  String get unitG => 'g';

  @override
  String get catHair => 'केस';

  @override
  String get catSkin => 'त्वचा';

  @override
  String get catNails => 'नखे';

  @override
  String get catWaxing => 'वॅक्सिंग';

  @override
  String get expRent => 'भाडे';

  @override
  String get expSalary => 'पगार';

  @override
  String get expProducts => 'प्रॉडक्ट';

  @override
  String get expElectricity => 'वीज';

  @override
  String get expTeaSnacks => 'चहा-नाश्ता';

  @override
  String get expOther => 'इतर';

  @override
  String get roleSeniorBeautician => 'सीनियर ब्युटिशियन';

  @override
  String get roleBeautician => 'ब्युटिशियन';

  @override
  String get roleJunior => 'ज्युनियर';

  @override
  String get roleReceptionist => 'रिसेप्शनिस्ट';

  @override
  String get prodCatHairCare => 'केसांची निगा';

  @override
  String get prodCatSkinCare => 'त्वचेची निगा';

  @override
  String get errCustomerNameRequired => 'ग्राहकाचे नाव टाका.';

  @override
  String get errServiceNameRequired => 'सर्व्हिसचे नाव टाका.';

  @override
  String get errPriceNegative => 'किंमत उणे असू शकत नाही.';

  @override
  String get errServiceDurationRequired =>
      'सर्व्हिसला किती वेळ लागतो ते निवडा.';

  @override
  String get errStaffNameRequired => 'स्टाफचे नाव टाका.';

  @override
  String get errProductNameRequired => 'प्रॉडक्टचे नाव टाका.';

  @override
  String get errLowStockNegative => 'कमी-स्टॉक अलर्ट उणे असू शकत नाही.';

  @override
  String get errOpeningStockNegative => 'सुरुवातीचा स्टॉक उणे असू शकत नाही.';

  @override
  String get errAmountZero => '₹0 पेक्षा जास्त रक्कम टाका.';

  @override
  String get errCategoryRequired => 'कॅटेगरी निवडा.';

  @override
  String get errAppointmentNoServices => 'किमान एक सर्व्हिस निवडा.';

  @override
  String get errAppointmentNoClient => 'ग्राहक निवडा किंवा नाव टाका.';

  @override
  String get errAppointmentEndBeforeStart =>
      'संपण्याची वेळ सुरू होण्याच्या वेळेनंतर हवी.';

  @override
  String get errAppointmentFinished => 'संपलेल्या अपॉइंटमेंट बदलता येत नाहीत.';

  @override
  String errStatusChange(String from, String to) {
    return 'ही अपॉइंटमेंट $from वरून $to करता येत नाही.';
  }

  @override
  String get errCustomerNotFound => 'ग्राहक सापडला नाही.';

  @override
  String get errServiceNotFound => 'सर्व्हिस सापडली नाही.';

  @override
  String get errStaffNotFound => 'स्टाफ सापडला नाही.';

  @override
  String get errAppointmentNotFound => 'अपॉइंटमेंट सापडली नाही.';

  @override
  String get errBillNotFound => 'बिल सापडले नाही.';

  @override
  String get errProductNotFound => 'प्रॉडक्ट सापडले नाही.';

  @override
  String get errBillProductMissing =>
      'या बिलावरील एक प्रॉडक्ट आता अस्तित्वात नाही.';

  @override
  String get errBillNoLines => 'किमान एक सर्व्हिस किंवा प्रॉडक्ट जोडा.';

  @override
  String errLineQtyInvalid(String name) {
    return '$name ची संख्या किमान 1 हवी.';
  }

  @override
  String errLinePriceInvalid(String name) {
    return '$name ची किंमत तपासा.';
  }

  @override
  String get errDiscountNegative => 'सूट उणे असू शकत नाही.';

  @override
  String get errDiscountOverSubtotal => 'सूट उपएकूणपेक्षा जास्त असू शकत नाही.';

  @override
  String get errDiscountOverHundred => 'सूट 100% पेक्षा जास्त असू शकत नाही.';

  @override
  String get errBillAlreadyFinalised => 'हे बिल आधीच फायनल झाले आहे.';

  @override
  String get errAppointmentAlreadyBilled =>
      'या अपॉइंटमेंटचे बिल आधीच बनले आहे.';

  @override
  String errAppointmentAlreadyBilledNo(String invoiceNo) {
    return 'या अपॉइंटमेंटचे बिल आधीच बनले आहे ($invoiceNo).';
  }

  @override
  String get errPaymentNeedsFinalisedBill => 'पेमेंट घेण्याआधी बिल फायनल करा.';

  @override
  String get errBillIsVoid => 'हे बिल रद्द आहे.';

  @override
  String get errPaymentMethodRequired => 'ग्राहकाने पैसे कसे दिले ते निवडा.';

  @override
  String get errPaymentOverBalance => 'रक्कम बाकीपेक्षा जास्त आहे.';

  @override
  String errOutOfStock(String name) {
    return '$name चा स्टॉक संपला आहे.';
  }

  @override
  String errNotEnoughStock(String qty, String name) {
    return 'स्टॉकमध्ये फक्त $qty $name शिल्लक आहे.';
  }

  @override
  String get errStockChangeZero => '0 पेक्षा जास्त संख्या टाका.';

  @override
  String get errStockSalesViaBills => 'विक्रीचा स्टॉक बिलांमधूनच बदलतो.';

  @override
  String get uiDay => 'दिवस';

  @override
  String get uiMonth => 'महिना';

  @override
  String get uiDemo => 'डेमो';

  @override
  String get welcomeArtLabel => 'केसांत पाने माळलेल्या स्त्रीचे रेखाचित्र';

  @override
  String get welcomeTagline => 'तुमचा पार्लर व्यवसाय\nसहज सांभाळा';

  @override
  String get welcomeFeatures =>
      'अपॉइंटमेंट, बिलिंग, ग्राहक, स्टाफ, स्टॉक आणि रिपोर्ट — सगळे एकाच ठिकाणी.';

  @override
  String get welcomeExplore => 'MyParlour पाहा';

  @override
  String get welcomeSampleData => 'सॅम्पल डेटा · साइन-इनची गरज नाही';

  @override
  String get startupErrorTitle => 'MyParlour डेटा उघडू शकले नाही';

  @override
  String get startupErrorMessage =>
      'फोनमध्ये मोकळी जागा आहे का ते तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get startupScreenError =>
      'या स्क्रीनवर काहीतरी चुकले. मागे जाऊन पुन्हा प्रयत्न करा.';

  @override
  String dashLoadError(String error) {
    return 'डॅशबोर्ड लोड झाला नाही. $error';
  }

  @override
  String get dashQuickActions => 'झटपट कामे';

  @override
  String get dashGreetingMorning => 'शुभ सकाळ';

  @override
  String dashGreetingMorningNamed(String name) {
    return 'शुभ सकाळ, $name';
  }

  @override
  String get dashGreetingAfternoon => 'शुभ दुपार';

  @override
  String dashGreetingAfternoonNamed(String name) {
    return 'शुभ दुपार, $name';
  }

  @override
  String get dashGreetingEvening => 'शुभ संध्याकाळ';

  @override
  String dashGreetingEveningNamed(String name) {
    return 'शुभ संध्याकाळ, $name';
  }

  @override
  String get dashYourParlour => 'तुमचे पार्लर';

  @override
  String get dashMoreBranches => 'अधिक शाखा फुल व्हर्जनमध्ये';

  @override
  String get dashAlerts => 'अलर्ट';

  @override
  String get dashAlertsNew => 'अलर्ट (नवीन)';

  @override
  String get dashNoSalesYesterday => 'काल विक्री नाही';

  @override
  String dashVsYesterday(int percent) {
    return 'कालच्या तुलनेत $percent%';
  }

  @override
  String get dashTodaysSales => 'आजची विक्री';

  @override
  String dashStillToCome(int count) {
    return 'अजून $count येणार';
  }

  @override
  String get dashPendingPayments => 'बाकी पेमेंट';

  @override
  String dashBillsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बिले बाकी',
      one: '1 बिल बाकी',
    );
    return '$_temp0';
  }

  @override
  String get dashCustomers => 'ग्राहक';

  @override
  String get dashActiveClients => 'ॲक्टिव्ह ग्राहक';

  @override
  String get dashNothingNeedsAttention => 'सध्या लक्ष द्यायला काही नाही.';

  @override
  String get dashBirthdaysToday => 'आज वाढदिवस';

  @override
  String get dashWishBirthday => 'वाढदिवसाच्या शुभेच्छा द्या';

  @override
  String dashAlertAt(int qty, String unit) {
    return '$qty $unit झाल्यावर अलर्ट';
  }

  @override
  String get dashRestock => 'पुन्हा मागवा';

  @override
  String get dashAllWellStocked => 'सर्व प्रॉडक्ट पुरेसे स्टॉकमध्ये आहेत.';

  @override
  String get dashNextAppointments => 'पुढच्या अपॉइंटमेंट';

  @override
  String get dashNoMoreToday => 'आज आणखी अपॉइंटमेंट नाहीत.';

  @override
  String get dashBook => 'बुक करा';

  @override
  String get dashNewAppointment => 'नवीन अपॉइंटमेंट';

  @override
  String get dashAddCustomer => 'ग्राहक जोडा';

  @override
  String get dashCreateBill => 'बिल बनवा';

  @override
  String moreOwnerSubtitle(String parlour) {
    return '$parlour · मालक';
  }

  @override
  String get moreCustomers => 'ग्राहक';

  @override
  String moreCustomerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ग्राहक',
      one: '1 ग्राहक',
    );
    return '$_temp0';
  }

  @override
  String get moreStaff => 'स्टाफ';

  @override
  String moreActiveStaff(int count) {
    return '$count सुरू';
  }

  @override
  String get moreServices => 'सर्व्हिसेस';

  @override
  String moreServiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्व्हिसेस',
      one: '1 सर्व्हिस',
    );
    return '$_temp0';
  }

  @override
  String get moreInventory => 'स्टॉक';

  @override
  String moreLowCount(int count) {
    return '$count कमी';
  }

  @override
  String moreExpensesThisMonth(String amount) {
    return 'या महिन्यात $amount';
  }

  @override
  String get moreReports => 'रिपोर्ट';

  @override
  String get settingsTitle => 'सेटिंग्ज';

  @override
  String settingsLoadError(String error) {
    return 'सेटिंग्ज लोड झाल्या नाहीत. $error';
  }

  @override
  String get settingsResetTitle => 'डेमो डेटा रीसेट करायचा?';

  @override
  String get settingsResetMessage =>
      'सर्व बदल जाऊन Beauty Bliss Parlour चा मूळ सॅम्पल डेटा, आजच्या आसपासच्या तारखांसह, परत येईल. हे परत करता येणार नाही.';

  @override
  String get settingsResetConfirm => 'रीसेट करा';

  @override
  String get settingsResetDone => 'डेमो डेटा परत आला';

  @override
  String get settingsEmptyTitle => 'रिकाम्या पार्लरने सुरुवात करायची?';

  @override
  String settingsEmptyMessage(String resetLabel) {
    return 'सर्व ग्राहक, सर्व्हिसेस, स्टाफ, अपॉइंटमेंट, बिले, प्रॉडक्ट आणि खर्च काढून टाकले जातील. तुमचे पार्लर प्रोफाइल, वेळा आणि बिलिंग सेटिंग्ज तशाच राहतील. \"$resetLabel\" वापरून सॅम्पल डेटा परत आणता येईल.';
  }

  @override
  String get settingsStartEmpty => 'रिकामे सुरू करा';

  @override
  String get settingsEmptyDone => 'रिकाम्या पार्लरने सुरुवात केली';

  @override
  String get settingsProfile => 'पार्लर प्रोफाइल';

  @override
  String get settingsName => 'नाव';

  @override
  String get settingsOwner => 'मालक';

  @override
  String get settingsPhone => 'फोन';

  @override
  String get settingsArea => 'भाग';

  @override
  String get settingsAddress => 'पत्ता';

  @override
  String get settingsBusinessHours => 'कामाच्या वेळा';

  @override
  String get settingsOpenDays => 'सुरू दिवस';

  @override
  String get settingsHours => 'वेळ';

  @override
  String settingsTimeRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get settingsBookingSlots => 'बुकिंग स्लॉट';

  @override
  String get settingsBillingTax => 'बिलिंग आणि टॅक्स';

  @override
  String get settingsInvoicePrefix => 'बिल नंबर प्रीफिक्स';

  @override
  String get settingsGst => 'GST';

  @override
  String get settingsOn => 'सुरू';

  @override
  String get settingsOff => 'बंद';

  @override
  String get settingsGstin => 'GSTIN';

  @override
  String get settingsDefaultRate => 'नेहमीचा दर';

  @override
  String get settingsPricesIncludeGst => 'किमतीत GST धरून';

  @override
  String get settingsYes => 'हो';

  @override
  String get settingsNo => 'नाही';

  @override
  String get settingsReceiptFooter => 'पावतीखालची ओळ';

  @override
  String get settingsDemoNote => 'हा डेमो आहे. डेटा फक्त या फोनवरच राहतो.';

  @override
  String get settingsResetDemo => 'डेमो डेटा रीसेट करा';

  @override
  String get settingsResetDemoHint => 'मूळ सॅम्पल डेटा परत आणा';

  @override
  String get settingsStartEmptyHint =>
      'रिकामे पार्लर वापरून पाहण्यासाठी सगळे पुसा';

  @override
  String get settingsAbout => 'माहिती';

  @override
  String get settingsAboutNote =>
      'साइन-इन आणि क्लाउड बॅकअप फुल व्हर्जनमध्ये येतील.';

  @override
  String get settingsSaved => 'सेटिंग्ज सेव्ह झाल्या';

  @override
  String get settingsParlourName => 'पार्लरचे नाव';

  @override
  String get settingsEnterParlourName => 'पार्लरचे नाव टाका.';

  @override
  String get settingsOwnerName => 'मालकाचे नाव';

  @override
  String get settingsEnterOwnerName => 'मालकाचे नाव टाका.';

  @override
  String get settingsEnterPhone => 'फोन नंबर टाका.';

  @override
  String get settingsAreaHint => 'उदा. MG Road, Pune';

  @override
  String get settingsEnterArea => 'भाग टाका.';

  @override
  String get settingsProfileNote => 'नाव, भाग आणि फोन पावतीवर दिसतात.';

  @override
  String get settingsNoOpenDay => 'किमान एक सुरू दिवस निवडा.';

  @override
  String get settingsCloseBeforeOpen =>
      'बंद होण्याची वेळ उघडण्याच्या वेळेनंतर हवी.';

  @override
  String get settingsOpens => 'उघडते';

  @override
  String get settingsOpeningTime => 'उघडण्याची वेळ';

  @override
  String get settingsCloses => 'बंद होते';

  @override
  String get settingsClosingTime => 'बंद होण्याची वेळ';

  @override
  String get settingsSlotsNote => 'नवीन अपॉइंटमेंट या अंतराने दिल्या जातात.';

  @override
  String get settingsPrefixHint => 'उदा. BBP';

  @override
  String get settingsEnterPrefix => 'प्रीफिक्स टाका.';

  @override
  String settingsNumberingNote(String example) {
    return 'बिलांना $example असे नंबर दिले जातात. आधी वापरलेले नंबर बदलत नाहीत.';
  }

  @override
  String get settingsChargeGst => 'GST लावा';

  @override
  String get settingsChargeGstHint => 'नवीन बिलांवर GST लागेल';

  @override
  String get settingsGstinHint => '15 अक्षरे';

  @override
  String get settingsGstinInvalid => 'GSTIN मध्ये 15 अक्षरे आणि अंक असतात.';

  @override
  String get settingsGstinNote => 'GSTIN जोडल्यावरच पावत्या \"कर बीजक\" बनतात.';

  @override
  String get settingsDefaultGstRate => 'नेहमीचा GST दर';

  @override
  String get settingsPricesIncludeGstHint => 'GST वरून न लावता किमतीतूनच काढा';

  @override
  String get settingsEnterFooter => 'खालची ओळ टाका.';

  @override
  String get expensesTitle => 'खर्च';

  @override
  String get expensesAdd => 'खर्च जोडा';

  @override
  String get expensesPreviousMonth => 'मागचा महिना';

  @override
  String get expensesNextMonth => 'पुढचा महिना';

  @override
  String get expensesTotalSpent => 'एकूण खर्च';

  @override
  String get expensesEmpty => 'या महिन्यात खर्च नाही.';

  @override
  String get expensesExpense => 'खर्च';

  @override
  String get expensesNotFound => 'हा खर्च आता अस्तित्वात नाही.';

  @override
  String get expensesUpdated => 'खर्च अपडेट झाला';

  @override
  String get expensesAdded => 'खर्च जोडला';

  @override
  String get expensesDeleteTitle => 'हा खर्च काढून टाकायचा?';

  @override
  String expensesDeleteMessage(String category, String amount) {
    return '$category · $amount काढून टाकले जाईल.';
  }

  @override
  String get expensesDeleted => 'खर्च काढून टाकला';

  @override
  String get expensesEdit => 'खर्च बदला';

  @override
  String get expensesDelete => 'खर्च काढून टाका';

  @override
  String get expensesAmount => 'रक्कम';

  @override
  String get expensesEnterAmount => 'रक्कम टाका.';

  @override
  String get expensesCategory => 'कॅटेगरी';

  @override
  String get expensesDate => 'तारीख';

  @override
  String get expensesChooseDate => 'तारीख निवडा';

  @override
  String get expensesPaidBy => 'कसे भरले';

  @override
  String get expensesNote => 'नोट';

  @override
  String get expensesNoteHint => 'उदा. मे महिन्याचे दुकान भाडे';

  @override
  String get expensesSave => 'खर्च सेव्ह करा';

  @override
  String get apptTitle => 'अपॉइंटमेंट';

  @override
  String get apptListTitle => 'अपॉइंटमेंट';

  @override
  String get apptBook => 'अपॉइंटमेंट बुक करा';

  @override
  String get apptPickDate => 'तारीख निवडा';

  @override
  String get apptFilterByStylist => 'स्टायलिस्टनुसार पाहा';

  @override
  String apptShowingStylist(String name) {
    return '$name च्या दाखवत आहे';
  }

  @override
  String get apptShowFor => 'कोणाच्या अपॉइंटमेंट दाखवायच्या';

  @override
  String get apptAllStylists => 'सर्व स्टायलिस्ट';

  @override
  String apptStaffInactive(String name) {
    return '$name (बंद)';
  }

  @override
  String get apptFilterAll => 'सर्व';

  @override
  String apptFilterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String apptLoadFailed(String error) {
    return 'अपॉइंटमेंट लोड झाल्या नाहीत. $error';
  }

  @override
  String get apptNoneOnDay => 'या दिवशी एकही अपॉइंटमेंट नाही';

  @override
  String get apptNoneUpcomingOnDay => 'या दिवशी येणारी अपॉइंटमेंट नाही';

  @override
  String get apptNoneCheckedInOnDay => 'या दिवशी कोणीही आलेले नाही';

  @override
  String get apptNoneCompletedOnDay =>
      'या दिवशी एकही अपॉइंटमेंट पूर्ण झाली नाही';

  @override
  String get apptNoneCancelledOnDay =>
      'या दिवशी एकही अपॉइंटमेंट रद्द झाली नाही';

  @override
  String get apptNoneNoShowOnDay => 'या दिवशी न आलेल्या अपॉइंटमेंट नाहीत';

  @override
  String get apptPreviousWeek => 'मागचा आठवडा';

  @override
  String get apptNextWeek => 'पुढचा आठवडा';

  @override
  String apptDayHasBookings(String day) {
    return '$day, बुकिंग आहे';
  }

  @override
  String get apptNoLongerExists => 'ही अपॉइंटमेंट आता अस्तित्वात नाही.';

  @override
  String apptDetailLoadFailed(String error) {
    return 'ही अपॉइंटमेंट लोड झाली नाही. $error';
  }

  @override
  String get apptMoreActions => 'आणखी पर्याय';

  @override
  String get apptCancelAppointment => 'अपॉइंटमेंट रद्द करा';

  @override
  String get apptMarkNoShow => 'आल्या नाहीत असे नोंदवा';

  @override
  String get apptOpenCustomer => 'ग्राहक उघडा';

  @override
  String get apptCancelledDone => 'अपॉइंटमेंट रद्द झाली';

  @override
  String get apptNoShowTitle => 'आल्या नाहीत असे नोंदवायचे?';

  @override
  String apptNoShowMessage(String name) {
    return '$name आल्या नाहीत. हे नंतर बदलता येणार नाही.';
  }

  @override
  String get apptNoShowDone => 'आल्या नाहीत असे नोंदवले';

  @override
  String get apptServices => 'सर्व्हिस';

  @override
  String get apptTotal => 'एकूण';

  @override
  String get apptNotes => 'नोट्स';

  @override
  String get apptReschedule => 'वेळ बदला';

  @override
  String get apptCheckIn => 'आल्या';

  @override
  String get apptCheckedInDone => 'आल्याची नोंद झाली';

  @override
  String get apptComplete => 'पूर्ण करा';

  @override
  String get apptCompletedDone => 'अपॉइंटमेंट पूर्ण झाली';

  @override
  String get apptCreateBill => 'बिल बनवा';

  @override
  String get apptViewBill => 'बिल पाहा';

  @override
  String get apptCancelTitle => 'अपॉइंटमेंट रद्द करायची?';

  @override
  String get apptCancelReasonLabel => 'कारण (ऐच्छिक)';

  @override
  String get apptCancelReasonHint => 'किंवा कारण लिहा';

  @override
  String get apptCancelKeep => 'राहू द्या';

  @override
  String get apptReasonCustomerCancelled => 'ग्राहकाने रद्द केली';

  @override
  String get apptReasonCustomerUnwell => 'ग्राहकाची तब्येत बरी नाही';

  @override
  String get apptReasonRescheduledByCustomer => 'ग्राहकाने वेळ बदलली';

  @override
  String get apptReasonStylistUnavailable => 'स्टायलिस्ट उपलब्ध नाही';

  @override
  String get apptChooseCustomer => 'ग्राहक निवडा';

  @override
  String get apptNewCustomerShort => 'नवीन';

  @override
  String get apptSearchCustomer => 'नाव किंवा फोन शोधा';

  @override
  String get apptNoCustomerMatch => 'शोधाशी जुळणारा ग्राहक नाही.';

  @override
  String get apptAddNewCustomer => 'नवीन ग्राहक जोडा';

  @override
  String get apptChooseServices => 'सर्व्हिस निवडा';

  @override
  String get apptSearchServices => 'सर्व्हिस शोधा';

  @override
  String apptAddServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्व्हिस जोडा',
      one: '1 सर्व्हिस जोडा',
    );
    return '$_temp0';
  }

  @override
  String apptAlreadyBooked(String name) {
    return '$name आधीच बुक आहेत';
  }

  @override
  String get apptPickAnotherTime => 'दुसरी वेळ निवडा';

  @override
  String get apptBookAnyway => 'तरीही बुक करा';

  @override
  String get bookingOnlyUpcoming =>
      'फक्त येणाऱ्या अपॉइंटमेंटची वेळ बदलता येते.';

  @override
  String bookingLoadFailed(String error) {
    return 'फॉर्म उघडला नाही. $error';
  }

  @override
  String get bookingRescheduled => 'अपॉइंटमेंटची वेळ बदलली';

  @override
  String get bookingBooked => 'अपॉइंटमेंट बुक झाली';

  @override
  String get bookingNewTitle => 'नवीन अपॉइंटमेंट';

  @override
  String get bookingDate => 'तारीख';

  @override
  String get bookingChooseDate => 'तारीख निवडा';

  @override
  String bookingClosedOn(String weekday) {
    return '$weekday रोजी पार्लर सहसा बंद असते.';
  }

  @override
  String get bookingTime => 'वेळ';

  @override
  String get bookingNoTimesLeft =>
      'या दिवशी वेळ शिल्लक नाही. दुसरी तारीख निवडा.';

  @override
  String get bookingNoStylist => 'या दिवशी कोणताही स्टायलिस्ट कामावर नाही.';

  @override
  String get bookingNotesHint => 'उदा. स्मूदनिंगमध्ये कमी हीट आवडते';

  @override
  String get bookingWalkInName => 'वॉक-इन ग्राहकाचे नाव';

  @override
  String get bookingWalkInNameRequired => 'ग्राहकाचे नाव टाका.';

  @override
  String get bookingMobileNumber => 'मोबाईल नंबर';

  @override
  String get bookingPhoneInvalid => '10 अंकी मोबाईल नंबर टाका.';

  @override
  String get bookingChooseSavedCustomer => 'त्याऐवजी सेव्ह केलेला ग्राहक निवडा';

  @override
  String get bookingCustomerRequired => 'ग्राहक निवडा किंवा वॉक-इन जोडा.';

  @override
  String bookingRemoveService(String name) {
    return '$name काढा';
  }

  @override
  String get bookingAddServices => 'सर्व्हिस जोडा';

  @override
  String get bookingAddMore => 'आणखी जोडा';

  @override
  String get bookingChooseTimeFirst => 'आधी वेळ निवडा';

  @override
  String get bookingFree => 'मोकळी';

  @override
  String bookingBusyUntil(String time) {
    return '$time पर्यंत बिझी';
  }

  @override
  String bookingBusyFrom(String time) {
    return '$time पासून बिझी';
  }

  @override
  String bookingDurationEnds(String duration, String time) {
    return 'वेळ $duration · $time ला संपेल';
  }

  @override
  String bookingEstimate(String amount) {
    return 'अंदाजे $amount';
  }

  @override
  String get reportsTitle => 'रिपोर्ट';

  @override
  String get reportsChoosePeriod => 'कालावधी निवडा';

  @override
  String reportsLoadFailed(String error) {
    return 'रिपोर्ट तयार झाला नाही. $error';
  }

  @override
  String get reportsEmpty => 'या कालावधीत विक्री, बिल किंवा खर्च नाही.';

  @override
  String get reportsTotalSales => 'एकूण विक्री';

  @override
  String get reportsMoneyReceived => 'मिळालेले पैसे';

  @override
  String get reportsTotalExpenses => 'एकूण खर्च';

  @override
  String get reportsNetProfit => 'निव्वळ नफा (अंदाजे)';

  @override
  String get reportsSalesMinusExpenses => 'विक्री − खर्च';

  @override
  String get reportsTotalBills => 'एकूण बिल';

  @override
  String get reportsBillsCaption => 'पक्की केलेली, रद्द नसलेली';

  @override
  String get reportsSalesOverview => 'विक्रीचा आढावा';

  @override
  String get reportsTopServices => 'टॉप सर्व्हिस';

  @override
  String get reportsNoServices =>
      'या कालावधीत कोणत्याही सर्व्हिसचे बिल झाले नाही.';

  @override
  String get reportsPaymentMethods => 'पेमेंटचे प्रकार';

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
  String get custTitle => 'ग्राहक';

  @override
  String get custAdd => 'ग्राहक जोडा';

  @override
  String get custEdit => 'ग्राहक बदला';

  @override
  String get custSearchHint => 'नाव किंवा फोन शोधा';

  @override
  String get custViewRecent => 'अलीकडची भेट';

  @override
  String get custViewAz => 'A–Z';

  @override
  String custViewInactive(int count) {
    return 'बंद ($count)';
  }

  @override
  String custLoadError(String error) {
    return 'ग्राहक लोड झाले नाहीत. $error';
  }

  @override
  String get custNoMatch => 'शोधाशी जुळणारा ग्राहक नाही.';

  @override
  String get custNoInactive => 'बंद केलेले ग्राहक नाहीत.';

  @override
  String get custEmpty => 'अजून एकही ग्राहक नाही.';

  @override
  String custRowCaption(int visits, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      visits,
      locale: localeName,
      other: '$visits भेटी · $last',
      one: '1 भेट · $last',
      zero: 'अजून एकही भेट नाही',
    );
    return '$_temp0';
  }

  @override
  String custLastVisit(String date) {
    return 'शेवटची $date';
  }

  @override
  String get custNoVisitsYet => 'अजून भेट नाही';

  @override
  String get custNotFound => 'हा ग्राहक आता अस्तित्वात नाही.';

  @override
  String custLoadOneError(String error) {
    return 'हा ग्राहक लोड झाला नाही. $error';
  }

  @override
  String get custShareContact => 'संपर्क शेअर करा';

  @override
  String get custDeactivate => 'ग्राहक बंद करा';

  @override
  String get custReactivate => 'ग्राहक पुन्हा सुरू करा';

  @override
  String custDeactivateTitle(String name) {
    return '$name यांना बंद करायचे?';
  }

  @override
  String get custDeactivateMessage =>
      'ते ग्राहक यादीत आणि बुकिंगमध्ये दिसणार नाहीत. त्यांचा जुना रेकॉर्ड राहील, आणि नंतर पुन्हा सुरू करता येईल.';

  @override
  String get custDeactivated => 'ग्राहक बंद केला';

  @override
  String get custReactivated => 'ग्राहक पुन्हा सुरू केला';

  @override
  String get custActionMore => 'अधिक';

  @override
  String get custTabHistory => 'हिस्टरी';

  @override
  String get custTabDetails => 'माहिती';

  @override
  String get custNotes => 'नोट्स';

  @override
  String get custNewAppointment => 'नवीन अपॉइंटमेंट';

  @override
  String get custSaved => 'ग्राहक सेव्ह झाला';

  @override
  String get custUpdated => 'ग्राहकाची माहिती बदलली';

  @override
  String get custFieldName => 'नाव';

  @override
  String get custNameHint => 'उदा. प्रिया शर्मा';

  @override
  String get custNameRequired => 'ग्राहकाचे नाव टाका.';

  @override
  String get custFieldMobile => 'मोबाईल नंबर';

  @override
  String get custMobileRequired => 'मोबाईल नंबर टाका.';

  @override
  String get custMobileInvalid => '10 अंकी मोबाईल नंबर टाका.';

  @override
  String get custBirthday => 'वाढदिवस';

  @override
  String get custAnniversary => 'ॲनिव्हर्सरी';

  @override
  String get custDayMonthHint => 'दिवस आणि महिना';

  @override
  String get custNotesHint => 'उदा. स्मूदनिंगमध्ये कमी हीट आवडते';

  @override
  String get custEmail => 'ईमेल';

  @override
  String get custEmailInvalid => 'योग्य ईमेल पत्ता टाका.';

  @override
  String get custSave => 'ग्राहक सेव्ह करा';

  @override
  String get custSaveAndBook => 'सेव्ह करा आणि अपॉइंटमेंट बुक करा';

  @override
  String custAlreadySaved(String name) {
    return '$name नावाने आधीच सेव्ह आहे';
  }

  @override
  String get custOpen => 'उघडा';

  @override
  String get custMobile => 'मोबाईल';

  @override
  String get custSince => 'ग्राहक कधीपासून';

  @override
  String get custVisits => 'भेटी';

  @override
  String get custTotalSpent => 'एकूण खर्च केले';

  @override
  String get custHistoryEmpty => 'अजून भेटी किंवा बिल नाहीत.';

  @override
  String get custNotesSaved => 'नोट्स सेव्ह झाल्या';

  @override
  String get custNotesTabHint =>
      'आवडीनिवडी, ॲलर्जी, आवडती स्टायलिस्ट… (उदा. स्मूदनिंगमध्ये कमी हीट आवडते)';

  @override
  String get custSaveNotes => 'नोट्स सेव्ह करा';

  @override
  String get servicesTitle => 'सर्व्हिस';

  @override
  String get servicesAdd => 'सर्व्हिस जोडा';

  @override
  String get servicesEdit => 'सर्व्हिस बदला';

  @override
  String get servicesEmpty =>
      'अजून सर्व्हिस नाहीत. तुमच्या पार्लरमधील सर्व्हिस जोडा.';

  @override
  String servicesLoadError(String error) {
    return 'सर्व्हिस लोड झाल्या नाहीत. $error';
  }

  @override
  String get servicesNewCategory => 'नवीन कॅटेगरी';

  @override
  String get servicesNewCategoryHint => 'उदा. ब्रायडल';

  @override
  String get servicesAdded => 'सर्व्हिस जोडली';

  @override
  String get servicesUpdated => 'सर्व्हिस बदलली';

  @override
  String servicesDeactivateTitle(String name) {
    return '$name बंद करायची?';
  }

  @override
  String get servicesDeactivateMessage =>
      'नवीन बुकिंग किंवा बिलमध्ये ही दिसणार नाही. जुन्या अपॉइंटमेंट आणि बिलमध्ये ती राहील.';

  @override
  String get servicesDeactivated => 'सर्व्हिस बंद केली';

  @override
  String get servicesReactivated => 'सर्व्हिस पुन्हा सुरू केली';

  @override
  String get servicesFieldName => 'सर्व्हिसचे नाव';

  @override
  String get servicesNameHint => 'उदा. हेअरकट';

  @override
  String get servicesCategory => 'कॅटेगरी';

  @override
  String get servicesPrice => 'किंमत';

  @override
  String get servicesPriceInvalid => 'किंमत रुपयांत टाका.';

  @override
  String get servicesDuration => 'किती वेळ';

  @override
  String get servicesCustomDuration => 'स्वतः टाका';

  @override
  String get servicesMinutes => 'मिनिटे';

  @override
  String get servicesMinutesHint => 'उदा. 75';

  @override
  String get servicesMinutesRequired => 'मिनिटे टाका.';

  @override
  String get servicesDescription => 'वर्णन';

  @override
  String get servicesGstRate => 'GST दर';

  @override
  String get servicesGstNote => 'सेटिंग्जमध्ये GST सुरू असेल तरच वापरला जातो.';

  @override
  String get servicesDeactivate => 'सर्व्हिस बंद करा';

  @override
  String get servicesReactivate => 'सर्व्हिस पुन्हा सुरू करा';

  @override
  String get servicesSave => 'सर्व्हिस सेव्ह करा';

  @override
  String get servicesService => 'सर्व्हिस';

  @override
  String get servicesNotFound => 'ही सर्व्हिस आता अस्तित्वात नाही.';

  @override
  String servicesLoadOneError(String error) {
    return 'ही सर्व्हिस लोड झाली नाही. $error';
  }

  @override
  String get staffTitle => 'स्टाफ';

  @override
  String get staffAdd => 'स्टाफ जोडा';

  @override
  String get staffEdit => 'स्टाफ बदला';

  @override
  String get staffSearchHint => 'नाव, रोल किंवा फोन शोधा';

  @override
  String staffLoadError(String error) {
    return 'स्टाफ लोड झाला नाही. $error';
  }

  @override
  String get staffNoMatch => 'शोधाशी जुळणारा स्टाफ नाही.';

  @override
  String get staffEmpty => 'अजून स्टाफ नाही.';

  @override
  String get staffNotFound => 'हा स्टाफ मेंबर आता अस्तित्वात नाही.';

  @override
  String staffDeactivateTitle(String name) {
    return '$name यांना बंद करायचे?';
  }

  @override
  String staffDeactivateMessage(String name) {
    return 'नवीन बुकिंगसाठी $name दिसणार नाहीत. जुन्या अपॉइंटमेंट आणि बिलमध्ये त्यांचे नाव राहील. नंतर पुन्हा सुरू करता येईल.';
  }

  @override
  String get staffDeactivated => 'स्टाफ बंद केला';

  @override
  String get staffActivated => 'स्टाफ सुरू केला';

  @override
  String get staffActivate => 'सुरू करा';

  @override
  String get staffMobile => 'मोबाईल';

  @override
  String get staffWorks => 'कामाचे दिवस';

  @override
  String get staffHours => 'वेळ';

  @override
  String get staffServices => 'सर्व्हिस';

  @override
  String staffHoursRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get staffServicesDone => 'केलेल्या सर्व्हिस';

  @override
  String get staffAmountBilled => 'बिल झालेली रक्कम';

  @override
  String get staffTodayAndUpcoming => 'आज आणि पुढच्या';

  @override
  String get staffNoAppointments => 'एकही अपॉइंटमेंट बुक नाही.';

  @override
  String get staffFormLoadError =>
      'हा फॉर्म लोड झाला नाही. पुन्हा प्रयत्न करा.';

  @override
  String get staffAdded => 'स्टाफ जोडला';

  @override
  String get staffUpdated => 'स्टाफची माहिती बदलली';

  @override
  String get staffFieldName => 'नाव';

  @override
  String get staffFieldMobile => 'मोबाईल नंबर';

  @override
  String get staffMobileInvalid => '10 अंकी मोबाईल नंबर टाका.';

  @override
  String get staffRole => 'रोल';

  @override
  String get staffServicesTheyDo => 'त्या करतात त्या सर्व्हिस';

  @override
  String get staffClearAll => 'सर्व काढा';

  @override
  String get staffTickAll => 'सर्व निवडा';

  @override
  String get staffWorkingDays => 'कामाचे दिवस';

  @override
  String get staffStarts => 'सुरुवात';

  @override
  String get staffStartHint => 'सुरुवात';

  @override
  String get staffEnds => 'शेवट';

  @override
  String get staffEndHint => 'शेवट';

  @override
  String get staffNoWorkingDay => 'किमान एक कामाचा दिवस निवडा.';

  @override
  String get staffSave => 'स्टाफ सेव्ह करा';

  @override
  String get billingNewBill => 'नवीन बिल';

  @override
  String get billingOpenBills => 'बाकी बिल';

  @override
  String get billingAllBills => 'सर्व बिल';

  @override
  String billingLoadError(String error) {
    return 'बिल लोड झाली नाहीत. $error';
  }

  @override
  String get billingNoOpenBills => 'बाकी बिल नाहीत. सगळे पैसे मिळाले.';

  @override
  String get billingNoBills => 'अजून एकही बिल नाही.';

  @override
  String get billingDraftBill => 'ड्राफ्ट बिल';

  @override
  String billingDue(String amount) {
    return 'बाकी $amount';
  }

  @override
  String get billingBill => 'बिल';

  @override
  String get billingOpenBill => 'बिल उघडा';

  @override
  String get billingNoLongerDraft => 'हे बिल आता ड्राफ्ट नाही.';

  @override
  String billingOpenError(String error) {
    return 'बिल उघडले नाही. $error';
  }

  @override
  String get billingEnterNumber => 'आकडा टाका.';

  @override
  String get billingChooseSavedCustomer => 'सेव्ह केलेला ग्राहक निवडा';

  @override
  String get billingWalkInName => 'वॉक-इन ग्राहकाचे नाव';

  @override
  String get billingWalkInNameHint => 'उदा. किरण';

  @override
  String get billingCheckDiscount => 'सूट तपासा.';

  @override
  String get billingDraftSaved => 'ड्राफ्ट सेव्ह झाला';

  @override
  String billingSavedNothingToPay(String invoiceNo) {
    return '$invoiceNo सेव्ह झाले. काही भरायचे नाही.';
  }

  @override
  String get billingCreateBill => 'बिल बनवा';

  @override
  String get billingChange => 'बदला';

  @override
  String get billingItems => 'आयटम';

  @override
  String get billingSwipeToRemove => 'ओळ काढण्यासाठी डावीकडे सरकवा.';

  @override
  String get billingAddItem => 'सर्व्हिस किंवा प्रॉडक्ट जोडा';

  @override
  String get billingDiscount => 'सूट';

  @override
  String get billingDiscountHintPercent => 'उदा. 10';

  @override
  String get billingDiscountHintAmount => 'उदा. 300';

  @override
  String get billingSaveDraft => 'ड्राफ्ट सेव्ह करा';

  @override
  String get billingProceedToPayment => 'पेमेंटकडे जा';

  @override
  String get billingBillGone => 'हे बिल आता अस्तित्वात नाही.';

  @override
  String billingLoadBillError(String error) {
    return 'हे बिल लोड झाले नाही. $error';
  }

  @override
  String get billingVoidTitle => 'हे बिल रद्द करायचे?';

  @override
  String get billingVoidMessage =>
      'बिल आणि त्याचे पेमेंट रद्द म्हणून नोंदवले जातील आणि विकलेले प्रॉडक्ट परत स्टॉकमध्ये जातील. बिल नंबर पुन्हा वापरला जाणार नाही.';

  @override
  String get billingVoidBill => 'बिल रद्द करा';

  @override
  String get billingVoided => 'बिल रद्द झाले';

  @override
  String get billingMoreActions => 'आणखी पर्याय';

  @override
  String get billingPrintReceipt => 'पावती प्रिंट करा';

  @override
  String get billingDownloadPdf => 'PDF डाउनलोड करा';

  @override
  String get billingVoidBanner =>
      'हे बिल रद्द आहे. त्याचे पेमेंट मोजले जात नाहीत आणि त्याचे प्रॉडक्ट परत स्टॉकमध्ये गेले.';

  @override
  String get billingPaidAmount => 'भरलेले';

  @override
  String get billingBalanceDue => 'बाकी रक्कम';

  @override
  String get billingPayments => 'पेमेंट';

  @override
  String get billingVoidTag => 'रद्द';

  @override
  String get billingShare => 'शेअर';

  @override
  String get billingRecordPayment => 'पेमेंट नोंदवा';

  @override
  String get billingShareReceiptWhatsApp => 'पावती WhatsApp वर पाठवा';

  @override
  String billingStylistName(String name) {
    return 'स्टायलिस्ट: $name';
  }

  @override
  String get billingAddToBill => 'बिलमध्ये जोडा';

  @override
  String get billingSearchItems => 'सर्व्हिस किंवा प्रॉडक्ट शोधा';

  @override
  String get billingServicesTab => 'सर्व्हिस';

  @override
  String get billingProductsTab => 'प्रॉडक्ट';

  @override
  String get billingNoSellingPrice => 'विक्री किंमत ठरवलेली नाही';

  @override
  String billingInStockCount(int count) {
    return 'स्टॉकमध्ये: $count';
  }

  @override
  String get billingNoMatch => 'शोधाशी काहीही जुळत नाही.';

  @override
  String billingReceiptShareText(String parlour) {
    return '$parlour ची पावती';
  }

  @override
  String get billingShareFailed => 'या फोनवर शेअरिंग उघडता आले नाही.';

  @override
  String get billingPrintFailed => 'या फोनवर प्रिंटिंग उघडता आले नाही.';

  @override
  String get billingDownloadFailed => 'या फोनवर PDF सेव्ह करता आली नाही.';

  @override
  String get billingReceiptFailed => 'पावती बनवता आली नाही.';

  @override
  String get billingSubtotal => 'उपएकूण';

  @override
  String get billingGst => 'GST';

  @override
  String get billingTotal => 'एकूण';

  @override
  String get paymentTitle => 'पेमेंट';

  @override
  String get paymentFinishBillFirst => 'पेमेंट घेण्याआधी बिल पूर्ण करा.';

  @override
  String get paymentFullyPaid => 'या बिलचे पूर्ण पैसे भरले आहेत.';

  @override
  String get paymentEnterAmount => 'मिळालेली रक्कम टाका.';

  @override
  String get paymentFullBalance => 'पूर्ण बाकी';

  @override
  String paymentPartial(String amount) {
    return 'थोडे · $amount बाकी राहतील';
  }

  @override
  String get paymentBillTotal => 'बिलची एकूण रक्कम';

  @override
  String get paymentAlreadyReceived => 'आधीच मिळाले';

  @override
  String get paymentMethodLabel => 'पेमेंट कसे केले';

  @override
  String get paymentUpiNote => 'फक्त पेमेंटची नोंद होते; ॲप UPI तपासत नाही.';

  @override
  String get paymentAmountReceived => 'मिळालेली रक्कम';

  @override
  String get paymentNote => 'नोट';

  @override
  String get paymentConfirm => 'पक्के करा';

  @override
  String paymentConfirmAmount(String amount) {
    return '$amount पक्के करा';
  }

  @override
  String get paymentNotFound => 'हे पेमेंट सापडले नाही.';

  @override
  String get paymentRecorded => 'पेमेंट नोंदवले';

  @override
  String paymentAmountByMethod(String amount, String method) {
    return '$amount $method ने';
  }

  @override
  String paymentTotalAmount(String amount) {
    return 'एकूण $amount';
  }

  @override
  String get paymentBalance => 'बाकी';

  @override
  String get paymentBookNextVisit => 'पुढची भेट बुक करा';

  @override
  String get paymentBackToDashboard => 'डॅशबोर्डवर परत जा';

  @override
  String get inventoryTitle => 'स्टॉक';

  @override
  String get inventoryAddProduct => 'प्रॉडक्ट जोडा';

  @override
  String get inventorySearch => 'प्रॉडक्ट शोधा';

  @override
  String get inventoryAllItems => 'सर्व आयटम';

  @override
  String inventoryTabCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String inventoryLoadError(String error) {
    return 'प्रॉडक्ट लोड झाले नाहीत. $error';
  }

  @override
  String get inventoryEmpty => 'अजून एकही प्रॉडक्ट नाही.';

  @override
  String get inventoryNoneLow => 'कोणताही स्टॉक कमी नाही.';

  @override
  String get inventoryNoneOut => 'कोणताही स्टॉक संपलेला नाही.';

  @override
  String get inventoryProduct => 'प्रॉडक्ट';

  @override
  String get inventoryProductGone => 'हा प्रॉडक्ट आता अस्तित्वात नाही.';

  @override
  String get inventoryEditProduct => 'प्रॉडक्ट बदला';

  @override
  String get inventoryInStockLabel => 'स्टॉकमध्ये';

  @override
  String get inventoryLowStockAlertAt => 'कमी स्टॉक अलर्ट';

  @override
  String get inventorySellingPrice => 'विक्री किंमत';

  @override
  String get inventoryNotSet => 'ठरवलेले नाही';

  @override
  String get inventoryCostPrice => 'खरेदी किंमत';

  @override
  String get inventoryStockHistory => 'स्टॉक हिस्टरी';

  @override
  String get inventoryNoStockChanges => 'स्टॉकमध्ये अजून बदल नाही.';

  @override
  String get inventoryAdjustStock => 'स्टॉक बदला';

  @override
  String get inventoryProductUpdated => 'प्रॉडक्ट बदलला';

  @override
  String get inventoryProductAdded => 'प्रॉडक्ट जोडला';

  @override
  String inventoryDeactivateTitle(String name) {
    return '$name बंद करायचा?';
  }

  @override
  String get inventoryDeactivateMessage =>
      'बिलमध्ये हा आता दिसणार नाही. त्याची स्टॉक हिस्टरी राहील.';

  @override
  String get inventoryDeactivated => 'प्रॉडक्ट बंद केला';

  @override
  String get inventoryReactivated => 'प्रॉडक्ट पुन्हा सुरू केला';

  @override
  String get inventoryEnterOpeningStock => 'सुरुवातीचा स्टॉक टाका.';

  @override
  String get inventoryEnterAlertLevel => 'अलर्ट किती वर द्यायचा ते टाका.';

  @override
  String get inventoryEnterPrice => 'किंमत रुपयांत टाका.';

  @override
  String get inventoryName => 'नाव';

  @override
  String get inventoryNameHint => 'उदा. हेअर सीरम';

  @override
  String inventoryStockInfo(int qty, String unit) {
    return 'स्टॉकमध्ये: $qty $unit. बदलण्यासाठी प्रॉडक्ट स्क्रीनवर \"स्टॉक बदला\" वापरा.';
  }

  @override
  String get inventoryOpeningStock => 'सुरुवातीचा स्टॉक';

  @override
  String get inventoryOpeningStockHint => 'उदा. 10';

  @override
  String get inventoryUnit => 'युनिट';

  @override
  String get inventoryCategory => 'कॅटेगरी';

  @override
  String get inventoryCategoryHint => 'उदा. केसांची निगा';

  @override
  String get inventoryDeactivateProduct => 'प्रॉडक्ट बंद करा';

  @override
  String get inventoryReactivateProduct => 'प्रॉडक्ट पुन्हा सुरू करा';

  @override
  String get inventorySaveProduct => 'प्रॉडक्ट सेव्ह करा';

  @override
  String inventoryOnlyInStock(int count) {
    return 'स्टॉकमध्ये फक्त $count आहेत.';
  }

  @override
  String get inventorySameAsCurrent => 'हा आताच्या स्टॉकइतकाच आहे.';

  @override
  String get inventoryStockUpdated => 'स्टॉक बदलला';

  @override
  String inventoryAdjustSubtitle(String name, int qty, String unit) {
    return '$name · आता $qty $unit';
  }

  @override
  String get inventoryAdjustType => 'प्रकार';

  @override
  String get inventoryCountedQty => 'मोजलेले प्रमाण';

  @override
  String get inventoryQty => 'प्रमाण';

  @override
  String inventoryNewStock(int qty, String unit) {
    return 'नवीन स्टॉक: $qty $unit';
  }

  @override
  String get inventoryNote => 'नोट';

  @override
  String get inventoryNoteHint => 'उदा. सप्लायरकडून घेतले';

  @override
  String inventoryStockLine(int qty, String unit) {
    return 'स्टॉक: $qty $unit';
  }

  @override
  String receiptPhone(String phone) {
    return 'फोन $phone';
  }

  @override
  String receiptGstin(String gstin) {
    return 'GSTIN $gstin';
  }

  @override
  String get receiptTaxInvoice => 'कर बीजक';

  @override
  String get receiptHeading => 'पावती';

  @override
  String get receiptItem => 'तपशील';

  @override
  String get receiptQty => 'नग';

  @override
  String get receiptRate => 'दर';

  @override
  String get receiptAmount => 'रक्कम';

  @override
  String receiptStylist(String name) {
    return 'स्टायलिस्ट: $name';
  }

  @override
  String get receiptSubtotal => 'उपएकूण';

  @override
  String get receiptDiscount => 'सूट';

  @override
  String get receiptGst => 'GST';

  @override
  String get receiptTotal => 'एकूण';

  @override
  String get receiptPaid => 'भरले';

  @override
  String get receiptBalance => 'बाकी';

  @override
  String get receiptPayments => 'पेमेंट';

  @override
  String get receiptNotTaxInvoice => 'ही पेमेंटची पावती आहे, GST कर बीजक नाही.';
}
