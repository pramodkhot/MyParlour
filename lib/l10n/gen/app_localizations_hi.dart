// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'MyParlour';

  @override
  String get navDashboard => 'डैशबोर्ड';

  @override
  String get navAppointments => 'अपॉइंटमेंट';

  @override
  String get navBilling => 'बिलिंग';

  @override
  String get navMore => 'और';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonSave => 'सेव करें';

  @override
  String get commonSaveChanges => 'बदलाव सेव करें';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get commonEdit => 'बदलें';

  @override
  String get commonDone => 'हो गया';

  @override
  String get commonAdd => 'जोड़ें';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get commonTryAgain => 'फिर से कोशिश करें';

  @override
  String get commonOptional => '(ज़रूरी नहीं)';

  @override
  String get commonClearSearch => 'खोज साफ़ करें';

  @override
  String commonClearField(String label) {
    return '$label साफ़ करें';
  }

  @override
  String get commonDecrease => 'कम करें';

  @override
  String get commonIncrease => 'बढ़ाएँ';

  @override
  String get commonMoreDetails => 'और जानकारी';

  @override
  String get commonSeeAll => 'सब देखें';

  @override
  String get commonNone => 'कोई नहीं';

  @override
  String get commonNotAdded => 'नहीं जोड़ा';

  @override
  String get commonInactive => 'बंद';

  @override
  String get commonActive => 'चालू';

  @override
  String get commonDeactivate => 'बंद करें';

  @override
  String get commonReactivate => 'फिर से चालू करें';

  @override
  String get commonWalkIn => 'वॉक-इन';

  @override
  String commonWalkInNamed(String name) {
    return 'वॉक-इन · $name';
  }

  @override
  String get commonWalkInCustomer => 'वॉक-इन ग्राहक';

  @override
  String get commonGuest => 'मेहमान';

  @override
  String get commonCustomer => 'ग्राहक';

  @override
  String get commonStylist => 'स्टाइलिस्ट';

  @override
  String commonNoAppFor(String what) {
    return 'इस फ़ोन में $what खोलने वाला कोई ऐप नहीं है।';
  }

  @override
  String get commonAppCalls => 'कॉल';

  @override
  String get commonAppWhatsApp => 'WhatsApp लिंक';

  @override
  String get commonAppMessages => 'मैसेज';

  @override
  String get commonAppSharing => 'शेयरिंग';

  @override
  String get commonCall => 'कॉल';

  @override
  String get commonWhatsApp => 'WhatsApp';

  @override
  String get commonSms => 'SMS';

  @override
  String get commonFillRequired => 'कृपया * वाले खाने भरें।';

  @override
  String commonMinutes(int count) {
    return '$count मि';
  }

  @override
  String commonHours(int count) {
    return '$count घं';
  }

  @override
  String commonHoursMinutes(int hours, String minutes) {
    return '$hours घं $minutes';
  }

  @override
  String get discardTitle => 'बदलाव छोड़ दें?';

  @override
  String get discardMessage => 'इस स्क्रीन पर जो भरा है, वह सेव नहीं होगा।';

  @override
  String get discardConfirm => 'छोड़ दें';

  @override
  String get discardKeep => 'बदलते रहें';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageChanged => 'भाषा बदल गई';

  @override
  String get statusUpcoming => 'आने वाली';

  @override
  String get statusCheckedIn => 'आ गईं';

  @override
  String get statusCompleted => 'पूरा';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get statusNoShow => 'नहीं आईं';

  @override
  String get billStatusDraft => 'ड्राफ्ट';

  @override
  String get billStatusUnpaid => 'बाकी';

  @override
  String get billStatusPartiallyPaid => 'आंशिक भुगतान';

  @override
  String get billStatusPaid => 'भुगतान हुआ';

  @override
  String get billStatusVoid => 'रद्द';

  @override
  String get payCash => 'नकद';

  @override
  String get payUpi => 'UPI';

  @override
  String get payCard => 'कार्ड';

  @override
  String get payOther => 'अन्य';

  @override
  String get payRefUpi => 'UPI रेफ़';

  @override
  String get payRefCard => 'कार्ड के आखिरी 4 अंक';

  @override
  String get payRefOther => 'रेफ़रेंस';

  @override
  String get stockInStock => 'स्टॉक में है';

  @override
  String get stockLow => 'कम स्टॉक';

  @override
  String get stockOut => 'स्टॉक खत्म';

  @override
  String stockLeft(int count) {
    return '$count बचे';
  }

  @override
  String get reasonPurchase => 'स्टॉक आया';

  @override
  String get reasonSale => 'बिल पर बिका';

  @override
  String get reasonUsedInService => 'सर्विस में लगा';

  @override
  String get reasonDamaged => 'खराब / एक्सपायर';

  @override
  String get reasonCorrection => 'गिनती सुधार';

  @override
  String get reasonVoidReversal => 'बिल रद्द (वापस आया)';

  @override
  String get periodToday => 'आज';

  @override
  String get periodThisWeek => 'इस हफ़्ते';

  @override
  String get periodThisMonth => 'इस महीने';

  @override
  String get periodCustom => 'अपनी तारीखें';

  @override
  String get unitPcs => 'पीस';

  @override
  String get unitMl => 'ml';

  @override
  String get unitG => 'g';

  @override
  String get catHair => 'बाल';

  @override
  String get catSkin => 'त्वचा';

  @override
  String get catNails => 'नाखून';

  @override
  String get catWaxing => 'वैक्सिंग';

  @override
  String get expRent => 'किराया';

  @override
  String get expSalary => 'वेतन';

  @override
  String get expProducts => 'प्रोडक्ट';

  @override
  String get expElectricity => 'बिजली';

  @override
  String get expTeaSnacks => 'चाय-नाश्ता';

  @override
  String get expOther => 'अन्य';

  @override
  String get roleSeniorBeautician => 'सीनियर ब्यूटीशियन';

  @override
  String get roleBeautician => 'ब्यूटीशियन';

  @override
  String get roleJunior => 'जूनियर';

  @override
  String get roleReceptionist => 'रिसेप्शनिस्ट';

  @override
  String get prodCatHairCare => 'बालों की देखभाल';

  @override
  String get prodCatSkinCare => 'त्वचा की देखभाल';

  @override
  String get errCustomerNameRequired => 'ग्राहक का नाम लिखें।';

  @override
  String get errServiceNameRequired => 'सर्विस का नाम लिखें।';

  @override
  String get errPriceNegative => 'कीमत माइनस में नहीं हो सकती।';

  @override
  String get errServiceDurationRequired =>
      'सर्विस में कितना समय लगता है, चुनें।';

  @override
  String get errStaffNameRequired => 'स्टाफ का नाम लिखें।';

  @override
  String get errProductNameRequired => 'प्रोडक्ट का नाम लिखें।';

  @override
  String get errLowStockNegative => 'कम स्टॉक अलर्ट माइनस में नहीं हो सकता।';

  @override
  String get errOpeningStockNegative => 'शुरुआती स्टॉक माइनस में नहीं हो सकता।';

  @override
  String get errAmountZero => '₹0 से ज़्यादा रकम लिखें।';

  @override
  String get errCategoryRequired => 'कैटेगरी चुनें।';

  @override
  String get errAppointmentNoServices => 'कम से कम एक सर्विस चुनें।';

  @override
  String get errAppointmentNoClient => 'ग्राहक चुनें या नाम लिखें।';

  @override
  String get errAppointmentEndBeforeStart =>
      'खत्म होने का समय शुरू होने के समय के बाद होना चाहिए।';

  @override
  String get errAppointmentFinished =>
      'पूरे हो चुके अपॉइंटमेंट बदले नहीं जा सकते।';

  @override
  String errStatusChange(String from, String to) {
    return 'यह अपॉइंटमेंट $from से $to में नहीं बदल सकता।';
  }

  @override
  String get errCustomerNotFound => 'ग्राहक नहीं मिला।';

  @override
  String get errServiceNotFound => 'सर्विस नहीं मिली।';

  @override
  String get errStaffNotFound => 'स्टाफ नहीं मिला।';

  @override
  String get errAppointmentNotFound => 'अपॉइंटमेंट नहीं मिला।';

  @override
  String get errBillNotFound => 'बिल नहीं मिला।';

  @override
  String get errProductNotFound => 'प्रोडक्ट नहीं मिला।';

  @override
  String get errBillProductMissing => 'इस बिल का एक प्रोडक्ट अब मौजूद नहीं है।';

  @override
  String get errBillNoLines => 'कम से कम एक सर्विस या प्रोडक्ट जोड़ें।';

  @override
  String errLineQtyInvalid(String name) {
    return '$name की मात्रा कम से कम 1 होनी चाहिए।';
  }

  @override
  String errLinePriceInvalid(String name) {
    return '$name की कीमत जाँचें।';
  }

  @override
  String get errDiscountNegative => 'छूट माइनस में नहीं हो सकती।';

  @override
  String get errDiscountOverSubtotal => 'छूट उप-योग से ज़्यादा नहीं हो सकती।';

  @override
  String get errDiscountOverHundred => 'छूट 100% से ज़्यादा नहीं हो सकती।';

  @override
  String get errBillAlreadyFinalised => 'यह बिल पहले ही फ़ाइनल हो चुका है।';

  @override
  String get errAppointmentAlreadyBilled =>
      'इस अपॉइंटमेंट का बिल पहले से बना है।';

  @override
  String errAppointmentAlreadyBilledNo(String invoiceNo) {
    return 'इस अपॉइंटमेंट का बिल पहले से बना है ($invoiceNo)।';
  }

  @override
  String get errPaymentNeedsFinalisedBill =>
      'पेमेंट लेने से पहले बिल फ़ाइनल करें।';

  @override
  String get errBillIsVoid => 'यह बिल रद्द है।';

  @override
  String get errPaymentMethodRequired => 'ग्राहक ने कैसे पेमेंट किया, चुनें।';

  @override
  String get errPaymentOverBalance => 'रकम बाकी रकम से ज़्यादा है।';

  @override
  String errOutOfStock(String name) {
    return '$name का स्टॉक खत्म है।';
  }

  @override
  String errNotEnoughStock(String qty, String name) {
    return 'स्टॉक में सिर्फ़ $qty $name बचे हैं।';
  }

  @override
  String get errStockChangeZero => '0 से ज़्यादा मात्रा लिखें।';

  @override
  String get errStockSalesViaBills => 'बिक्री से स्टॉक बिल के ज़रिए बदलता है।';

  @override
  String get uiDay => 'दिन';

  @override
  String get uiMonth => 'महीना';

  @override
  String get uiDemo => 'डेमो';

  @override
  String get welcomeArtLabel =>
      'बालों में पत्तियाँ लगाए एक महिला का रेखा-चित्र';

  @override
  String get welcomeTagline => 'अपना पार्लर बिज़नेस\nआसानी से चलाएँ';

  @override
  String get welcomeFeatures =>
      'अपॉइंटमेंट, बिलिंग, ग्राहक, स्टाफ, स्टॉक और रिपोर्ट — सब एक ही जगह।';

  @override
  String get welcomeExplore => 'MyParlour देखें';

  @override
  String get welcomeSampleData => 'सैंपल डेटा · साइन-इन की ज़रूरत नहीं';

  @override
  String get startupErrorTitle => 'MyParlour अपना डेटा नहीं खोल पाया';

  @override
  String get startupErrorMessage =>
      'कृपया देखें कि फ़ोन में खाली जगह है, फिर से कोशिश करें।';

  @override
  String get startupScreenError =>
      'इस स्क्रीन पर कुछ गड़बड़ हो गई। कृपया वापस जाकर फिर से कोशिश करें।';

  @override
  String dashLoadError(String error) {
    return 'डैशबोर्ड लोड नहीं हो पाया। $error';
  }

  @override
  String get dashQuickActions => 'जल्दी के काम';

  @override
  String get dashGreetingMorning => 'सुप्रभात';

  @override
  String dashGreetingMorningNamed(String name) {
    return 'सुप्रभात, $name';
  }

  @override
  String get dashGreetingAfternoon => 'नमस्ते';

  @override
  String dashGreetingAfternoonNamed(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get dashGreetingEvening => 'शुभ संध्या';

  @override
  String dashGreetingEveningNamed(String name) {
    return 'शुभ संध्या, $name';
  }

  @override
  String get dashYourParlour => 'आपका पार्लर';

  @override
  String get dashMoreBranches => 'ज़्यादा ब्रांच फुल वर्शन में';

  @override
  String get dashAlerts => 'अलर्ट';

  @override
  String get dashAlertsNew => 'अलर्ट (नए)';

  @override
  String get dashNoSalesYesterday => 'कल कोई बिक्री नहीं';

  @override
  String dashVsYesterday(int percent) {
    return 'कल के मुकाबले $percent%';
  }

  @override
  String get dashTodaysSales => 'आज की बिक्री';

  @override
  String dashStillToCome(int count) {
    return '$count अभी आने बाकी';
  }

  @override
  String get dashPendingPayments => 'बाकी पेमेंट';

  @override
  String dashBillsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बिल बाकी',
      one: '1 बिल बाकी',
    );
    return '$_temp0';
  }

  @override
  String get dashCustomers => 'ग्राहक';

  @override
  String get dashActiveClients => 'चालू ग्राहक';

  @override
  String get dashNothingNeedsAttention => 'अभी कुछ भी देखने की ज़रूरत नहीं है।';

  @override
  String get dashBirthdaysToday => 'आज जन्मदिन';

  @override
  String get dashWishBirthday => 'उन्हें जन्मदिन की बधाई दें';

  @override
  String dashAlertAt(int qty, String unit) {
    return '$qty $unit पर अलर्ट';
  }

  @override
  String get dashRestock => 'फिर से मँगाएँ';

  @override
  String get dashAllWellStocked => 'सभी प्रोडक्ट का स्टॉक ठीक है।';

  @override
  String get dashNextAppointments => 'अगले अपॉइंटमेंट';

  @override
  String get dashNoMoreToday => 'आज और कोई अपॉइंटमेंट नहीं।';

  @override
  String get dashBook => 'बुक करें';

  @override
  String get dashNewAppointment => 'नया अपॉइंटमेंट';

  @override
  String get dashAddCustomer => 'ग्राहक जोड़ें';

  @override
  String get dashCreateBill => 'बिल बनाएँ';

  @override
  String moreOwnerSubtitle(String parlour) {
    return '$parlour · मालिक';
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
    return '$count चालू';
  }

  @override
  String get moreServices => 'सर्विस';

  @override
  String moreServiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्विस',
      one: '1 सर्विस',
    );
    return '$_temp0';
  }

  @override
  String get moreInventory => 'स्टॉक';

  @override
  String moreLowCount(int count) {
    return '$count कम';
  }

  @override
  String moreExpensesThisMonth(String amount) {
    return 'इस महीने $amount';
  }

  @override
  String get moreReports => 'रिपोर्ट';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String settingsLoadError(String error) {
    return 'सेटिंग्स लोड नहीं हो पाईं। $error';
  }

  @override
  String get settingsResetTitle => 'डेमो डेटा रीसेट करें?';

  @override
  String get settingsResetMessage =>
      'सारे बदलाव हटकर Beauty Bliss Parlour का असली सैंपल डेटा आ जाएगा, आज की तारीखों के आसपास। इसे वापस नहीं किया जा सकता।';

  @override
  String get settingsResetConfirm => 'रीसेट करें';

  @override
  String get settingsResetDone => 'डेमो डेटा वापस आ गया';

  @override
  String get settingsEmptyTitle => 'खाली पार्लर से शुरू करें?';

  @override
  String settingsEmptyMessage(String resetLabel) {
    return 'सभी ग्राहक, सर्विस, स्टाफ, अपॉइंटमेंट, बिल, प्रोडक्ट और खर्च हट जाएँगे। आपकी पार्लर प्रोफ़ाइल, समय और बिलिंग सेटिंग्स बनी रहेंगी। सैंपल डेटा \"$resetLabel\" से वापस ला सकते हैं।';
  }

  @override
  String get settingsStartEmpty => 'खाली शुरू करें';

  @override
  String get settingsEmptyDone => 'खाली पार्लर से शुरू किया';

  @override
  String get settingsProfile => 'पार्लर प्रोफ़ाइल';

  @override
  String get settingsName => 'नाम';

  @override
  String get settingsOwner => 'मालिक';

  @override
  String get settingsPhone => 'फ़ोन';

  @override
  String get settingsArea => 'इलाका';

  @override
  String get settingsAddress => 'पता';

  @override
  String get settingsBusinessHours => 'खुलने का समय';

  @override
  String get settingsOpenDays => 'खुले दिन';

  @override
  String get settingsHours => 'समय';

  @override
  String settingsTimeRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get settingsBookingSlots => 'बुकिंग स्लॉट';

  @override
  String get settingsBillingTax => 'बिलिंग और टैक्स';

  @override
  String get settingsInvoicePrefix => 'बिल नंबर प्रीफ़िक्स';

  @override
  String get settingsGst => 'GST';

  @override
  String get settingsOn => 'चालू';

  @override
  String get settingsOff => 'बंद';

  @override
  String get settingsGstin => 'GSTIN';

  @override
  String get settingsDefaultRate => 'डिफ़ॉल्ट रेट';

  @override
  String get settingsPricesIncludeGst => 'कीमत में GST शामिल';

  @override
  String get settingsYes => 'हाँ';

  @override
  String get settingsNo => 'नहीं';

  @override
  String get settingsReceiptFooter => 'रसीद के नीचे की लाइन';

  @override
  String get settingsDemoNote =>
      'यह डेमो है। डेटा सिर्फ़ इसी फ़ोन में रहता है।';

  @override
  String get settingsResetDemo => 'डेमो डेटा रीसेट करें';

  @override
  String get settingsResetDemoHint => 'असली सैंपल डेटा वापस लाएँ';

  @override
  String get settingsStartEmptyHint => 'सब कुछ हटाकर खाली पार्लर आज़माएँ';

  @override
  String get settingsAbout => 'ऐप के बारे में';

  @override
  String get settingsAboutNote =>
      'साइन-इन और क्लाउड बैकअप फुल वर्शन में आएँगे।';

  @override
  String get settingsSaved => 'सेटिंग्स सेव हो गईं';

  @override
  String get settingsParlourName => 'पार्लर का नाम';

  @override
  String get settingsEnterParlourName => 'पार्लर का नाम लिखें।';

  @override
  String get settingsOwnerName => 'मालिक का नाम';

  @override
  String get settingsEnterOwnerName => 'मालिक का नाम लिखें।';

  @override
  String get settingsEnterPhone => 'फ़ोन नंबर लिखें।';

  @override
  String get settingsAreaHint => 'जैसे MG Road, Pune';

  @override
  String get settingsEnterArea => 'इलाका लिखें।';

  @override
  String get settingsProfileNote => 'नाम, इलाका और फ़ोन रसीद पर छपते हैं।';

  @override
  String get settingsNoOpenDay => 'कम से कम एक खुला दिन चुनें।';

  @override
  String get settingsCloseBeforeOpen =>
      'बंद होने का समय खुलने के समय के बाद होना चाहिए।';

  @override
  String get settingsOpens => 'खुलता है';

  @override
  String get settingsOpeningTime => 'खुलने का समय';

  @override
  String get settingsCloses => 'बंद होता है';

  @override
  String get settingsClosingTime => 'बंद होने का समय';

  @override
  String get settingsSlotsNote => 'नए अपॉइंटमेंट इतने-इतने समय पर दिखेंगे।';

  @override
  String get settingsPrefixHint => 'जैसे BBP';

  @override
  String get settingsEnterPrefix => 'प्रीफ़िक्स लिखें।';

  @override
  String settingsNumberingNote(String example) {
    return 'बिल नंबर $example जैसे होंगे। पहले से इस्तेमाल हुए नंबर नहीं बदलेंगे।';
  }

  @override
  String get settingsChargeGst => 'GST लगाएँ';

  @override
  String get settingsChargeGstHint => 'नए बिलों में GST जुड़ेगा';

  @override
  String get settingsGstinHint => '15 अक्षर';

  @override
  String get settingsGstinInvalid => 'GSTIN में 15 अक्षर और अंक होते हैं।';

  @override
  String get settingsGstinNote =>
      'GSTIN जोड़ने पर ही रसीद \"टैक्स इनवॉइस\" बनती है।';

  @override
  String get settingsDefaultGstRate => 'डिफ़ॉल्ट GST रेट';

  @override
  String get settingsPricesIncludeGstHint =>
      'GST जोड़ने की जगह कीमत में से निकालें';

  @override
  String get settingsEnterFooter => 'नीचे की लाइन लिखें।';

  @override
  String get expensesTitle => 'खर्च';

  @override
  String get expensesAdd => 'खर्च जोड़ें';

  @override
  String get expensesPreviousMonth => 'पिछला महीना';

  @override
  String get expensesNextMonth => 'अगला महीना';

  @override
  String get expensesTotalSpent => 'कुल खर्च';

  @override
  String get expensesEmpty => 'इस महीने कोई खर्च नहीं।';

  @override
  String get expensesExpense => 'खर्च';

  @override
  String get expensesNotFound => 'यह खर्च अब मौजूद नहीं है।';

  @override
  String get expensesUpdated => 'खर्च बदल गया';

  @override
  String get expensesAdded => 'खर्च जुड़ गया';

  @override
  String get expensesDeleteTitle => 'यह खर्च हटाएँ?';

  @override
  String expensesDeleteMessage(String category, String amount) {
    return '$category · $amount हट जाएगा।';
  }

  @override
  String get expensesDeleted => 'खर्च हट गया';

  @override
  String get expensesEdit => 'खर्च बदलें';

  @override
  String get expensesDelete => 'खर्च हटाएँ';

  @override
  String get expensesAmount => 'रकम';

  @override
  String get expensesEnterAmount => 'रकम लिखें।';

  @override
  String get expensesCategory => 'कैटेगरी';

  @override
  String get expensesDate => 'तारीख';

  @override
  String get expensesChooseDate => 'तारीख चुनें';

  @override
  String get expensesPaidBy => 'कैसे दिया';

  @override
  String get expensesNote => 'नोट';

  @override
  String get expensesNoteHint => 'जैसे मई का दुकान किराया';

  @override
  String get expensesSave => 'खर्च सेव करें';

  @override
  String get apptTitle => 'अपॉइंटमेंट';

  @override
  String get apptListTitle => 'अपॉइंटमेंट';

  @override
  String get apptBook => 'अपॉइंटमेंट बुक करें';

  @override
  String get apptPickDate => 'तारीख चुनें';

  @override
  String get apptFilterByStylist => 'स्टाइलिस्ट से फ़िल्टर करें';

  @override
  String apptShowingStylist(String name) {
    return '$name के दिख रहे हैं';
  }

  @override
  String get apptShowFor => 'किसके अपॉइंटमेंट दिखाएँ';

  @override
  String get apptAllStylists => 'सभी स्टाइलिस्ट';

  @override
  String apptStaffInactive(String name) {
    return '$name (बंद)';
  }

  @override
  String get apptFilterAll => 'सभी';

  @override
  String apptFilterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String apptLoadFailed(String error) {
    return 'अपॉइंटमेंट लोड नहीं हो सके। $error';
  }

  @override
  String get apptNoneOnDay => 'इस दिन कोई अपॉइंटमेंट नहीं';

  @override
  String get apptNoneUpcomingOnDay => 'इस दिन कोई आने वाली अपॉइंटमेंट नहीं';

  @override
  String get apptNoneCheckedInOnDay => 'इस दिन कोई चेक-इन अपॉइंटमेंट नहीं';

  @override
  String get apptNoneCompletedOnDay => 'इस दिन कोई पूरी अपॉइंटमेंट नहीं';

  @override
  String get apptNoneCancelledOnDay => 'इस दिन कोई रद्द अपॉइंटमेंट नहीं';

  @override
  String get apptNoneNoShowOnDay => 'इस दिन कोई \"नहीं आईं\" अपॉइंटमेंट नहीं';

  @override
  String get apptPreviousWeek => 'पिछला हफ़्ता';

  @override
  String get apptNextWeek => 'अगला हफ़्ता';

  @override
  String apptDayHasBookings(String day) {
    return '$day, बुकिंग हैं';
  }

  @override
  String get apptNoLongerExists => 'यह अपॉइंटमेंट अब मौजूद नहीं है।';

  @override
  String apptDetailLoadFailed(String error) {
    return 'यह अपॉइंटमेंट लोड नहीं हो सकी। $error';
  }

  @override
  String get apptMoreActions => 'और विकल्प';

  @override
  String get apptCancelAppointment => 'अपॉइंटमेंट रद्द करें';

  @override
  String get apptMarkNoShow => 'नहीं आईं मार्क करें';

  @override
  String get apptOpenCustomer => 'ग्राहक खोलें';

  @override
  String get apptCancelledDone => 'अपॉइंटमेंट रद्द हो गई';

  @override
  String get apptNoShowTitle => 'नहीं आईं मार्क करें?';

  @override
  String apptNoShowMessage(String name) {
    return '$name नहीं आईं। इसे वापस नहीं बदला जा सकता।';
  }

  @override
  String get apptNoShowDone => 'नहीं आईं मार्क हो गया';

  @override
  String get apptServices => 'सर्विस';

  @override
  String get apptTotal => 'कुल';

  @override
  String get apptNotes => 'नोट्स';

  @override
  String get apptReschedule => 'समय बदलें';

  @override
  String get apptCheckIn => 'चेक-इन करें';

  @override
  String get apptCheckedInDone => 'चेक-इन हो गया';

  @override
  String get apptComplete => 'पूरा करें';

  @override
  String get apptCompletedDone => 'अपॉइंटमेंट पूरी हुई';

  @override
  String get apptCreateBill => 'बिल बनाएँ';

  @override
  String get apptViewBill => 'बिल देखें';

  @override
  String get apptCancelTitle => 'अपॉइंटमेंट रद्द करें?';

  @override
  String get apptCancelReasonLabel => 'कारण (ज़रूरी नहीं)';

  @override
  String get apptCancelReasonHint => 'या कारण लिखें';

  @override
  String get apptCancelKeep => 'रहने दें';

  @override
  String get apptReasonCustomerCancelled => 'ग्राहक ने रद्द किया';

  @override
  String get apptReasonCustomerUnwell => 'ग्राहक की तबीयत ठीक नहीं';

  @override
  String get apptReasonRescheduledByCustomer => 'ग्राहक ने समय बदला';

  @override
  String get apptReasonStylistUnavailable => 'स्टाइलिस्ट उपलब्ध नहीं';

  @override
  String get apptChooseCustomer => 'ग्राहक चुनें';

  @override
  String get apptNewCustomerShort => 'नया';

  @override
  String get apptSearchCustomer => 'नाम या फ़ोन खोजें';

  @override
  String get apptNoCustomerMatch => 'आपकी खोज से कोई ग्राहक नहीं मिला।';

  @override
  String get apptAddNewCustomer => 'नया ग्राहक जोड़ें';

  @override
  String get apptChooseServices => 'सर्विस चुनें';

  @override
  String get apptSearchServices => 'सर्विस खोजें';

  @override
  String apptAddServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्विस जोड़ें',
      one: '1 सर्विस जोड़ें',
    );
    return '$_temp0';
  }

  @override
  String apptAlreadyBooked(String name) {
    return '$name पहले से बुक हैं';
  }

  @override
  String get apptPickAnotherTime => 'दूसरा समय चुनें';

  @override
  String get apptBookAnyway => 'फिर भी बुक करें';

  @override
  String get bookingOnlyUpcoming =>
      'सिर्फ़ आने वाली अपॉइंटमेंट का समय बदला जा सकता है।';

  @override
  String bookingLoadFailed(String error) {
    return 'फ़ॉर्म नहीं खुल सका। $error';
  }

  @override
  String get bookingRescheduled => 'अपॉइंटमेंट का समय बदल गया';

  @override
  String get bookingBooked => 'अपॉइंटमेंट बुक हो गई';

  @override
  String get bookingNewTitle => 'नई अपॉइंटमेंट';

  @override
  String get bookingDate => 'तारीख';

  @override
  String get bookingChooseDate => 'तारीख चुनें';

  @override
  String bookingClosedOn(String weekday) {
    return 'पार्लर आमतौर पर $weekday को बंद रहता है।';
  }

  @override
  String get bookingTime => 'समय';

  @override
  String get bookingNoTimesLeft =>
      'इस दिन कोई समय खाली नहीं। दूसरी तारीख चुनें।';

  @override
  String get bookingNoStylist => 'इस दिन कोई स्टाइलिस्ट काम नहीं करती।';

  @override
  String get bookingNotesHint => 'जैसे स्मूदनिंग में कम गरमी पसंद है';

  @override
  String get bookingWalkInName => 'वॉक-इन नाम';

  @override
  String get bookingWalkInNameRequired => 'ग्राहक का नाम लिखें।';

  @override
  String get bookingMobileNumber => 'मोबाइल नंबर';

  @override
  String get bookingPhoneInvalid => '10 अंकों का मोबाइल नंबर लिखें।';

  @override
  String get bookingChooseSavedCustomer => 'इसकी जगह सेव किया ग्राहक चुनें';

  @override
  String get bookingCustomerRequired => 'ग्राहक चुनें या वॉक-इन जोड़ें।';

  @override
  String bookingRemoveService(String name) {
    return '$name हटाएँ';
  }

  @override
  String get bookingAddServices => 'सर्विस जोड़ें';

  @override
  String get bookingAddMore => 'और जोड़ें';

  @override
  String get bookingChooseTimeFirst => 'पहले समय चुनें';

  @override
  String get bookingFree => 'खाली';

  @override
  String bookingBusyUntil(String time) {
    return '$time तक व्यस्त';
  }

  @override
  String bookingBusyFrom(String time) {
    return '$time से व्यस्त';
  }

  @override
  String bookingDurationEnds(String duration, String time) {
    return 'समय $duration · $time पर खत्म';
  }

  @override
  String bookingEstimate(String amount) {
    return 'अनुमान $amount';
  }

  @override
  String get reportsTitle => 'रिपोर्ट';

  @override
  String get reportsChoosePeriod => 'समय चुनें';

  @override
  String reportsLoadFailed(String error) {
    return 'रिपोर्ट नहीं बन सकी। $error';
  }

  @override
  String get reportsEmpty => 'इस समय में कोई बिक्री, बिल या खर्च नहीं।';

  @override
  String get reportsTotalSales => 'कुल बिक्री';

  @override
  String get reportsMoneyReceived => 'मिले पैसे';

  @override
  String get reportsTotalExpenses => 'कुल खर्च';

  @override
  String get reportsNetProfit => 'शुद्ध मुनाफ़ा (अनुमान)';

  @override
  String get reportsSalesMinusExpenses => 'बिक्री − खर्च';

  @override
  String get reportsTotalBills => 'कुल बिल';

  @override
  String get reportsBillsCaption => 'फ़ाइनल, रद्द नहीं';

  @override
  String get reportsSalesOverview => 'बिक्री का हाल';

  @override
  String get reportsTopServices => 'टॉप सर्विस';

  @override
  String get reportsNoServices => 'इस समय में किसी सर्विस का बिल नहीं बना।';

  @override
  String get reportsPaymentMethods => 'पेमेंट के तरीके';

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
  String get custAdd => 'ग्राहक जोड़ें';

  @override
  String get custEdit => 'ग्राहक बदलें';

  @override
  String get custSearchHint => 'नाम या फ़ोन खोजें';

  @override
  String get custViewRecent => 'हाल की विज़िट';

  @override
  String get custViewAz => 'A–Z';

  @override
  String custViewInactive(int count) {
    return 'बंद ($count)';
  }

  @override
  String custLoadError(String error) {
    return 'ग्राहक लोड नहीं हो सके। $error';
  }

  @override
  String get custNoMatch => 'आपकी खोज से कोई ग्राहक नहीं मिला।';

  @override
  String get custNoInactive => 'कोई बंद ग्राहक नहीं।';

  @override
  String get custEmpty => 'अभी कोई ग्राहक नहीं।';

  @override
  String custRowCaption(int visits, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      visits,
      locale: localeName,
      other: '$visits विज़िट · $last',
      one: '1 विज़िट · $last',
      zero: 'अभी कोई विज़िट नहीं',
    );
    return '$_temp0';
  }

  @override
  String custLastVisit(String date) {
    return 'आखिरी $date';
  }

  @override
  String get custNoVisitsYet => 'अभी कोई विज़िट नहीं';

  @override
  String get custNotFound => 'यह ग्राहक अब मौजूद नहीं है।';

  @override
  String custLoadOneError(String error) {
    return 'यह ग्राहक लोड नहीं हो सका। $error';
  }

  @override
  String get custShareContact => 'कॉन्टैक्ट शेयर करें';

  @override
  String get custDeactivate => 'ग्राहक बंद करें';

  @override
  String get custReactivate => 'ग्राहक फिर से चालू करें';

  @override
  String custDeactivateTitle(String name) {
    return '$name को बंद करें?';
  }

  @override
  String get custDeactivateMessage =>
      'ये ग्राहक लिस्ट और बुकिंग में नहीं दिखेंगी। इनका पुराना रिकॉर्ड रहेगा, और आप बाद में इन्हें फिर से चालू कर सकते हैं।';

  @override
  String get custDeactivated => 'ग्राहक बंद किया गया';

  @override
  String get custReactivated => 'ग्राहक फिर से चालू हुआ';

  @override
  String get custActionMore => 'और';

  @override
  String get custTabHistory => 'हिस्ट्री';

  @override
  String get custTabDetails => 'जानकारी';

  @override
  String get custNotes => 'नोट्स';

  @override
  String get custNewAppointment => 'नई अपॉइंटमेंट';

  @override
  String get custSaved => 'ग्राहक सेव हो गया';

  @override
  String get custUpdated => 'ग्राहक अपडेट हो गया';

  @override
  String get custFieldName => 'नाम';

  @override
  String get custNameHint => 'जैसे प्रिया शर्मा';

  @override
  String get custNameRequired => 'ग्राहक का नाम लिखें।';

  @override
  String get custFieldMobile => 'मोबाइल नंबर';

  @override
  String get custMobileRequired => 'मोबाइल नंबर लिखें।';

  @override
  String get custMobileInvalid => '10 अंकों का मोबाइल नंबर लिखें।';

  @override
  String get custBirthday => 'जन्मदिन';

  @override
  String get custAnniversary => 'सालगिरह';

  @override
  String get custDayMonthHint => 'दिन और महीना';

  @override
  String get custNotesHint => 'जैसे स्मूदनिंग में कम गरमी पसंद है';

  @override
  String get custEmail => 'ईमेल';

  @override
  String get custEmailInvalid => 'सही ईमेल पता लिखें।';

  @override
  String get custSave => 'ग्राहक सेव करें';

  @override
  String get custSaveAndBook => 'सेव करें और अपॉइंटमेंट बुक करें';

  @override
  String custAlreadySaved(String name) {
    return 'पहले से $name के नाम से सेव है';
  }

  @override
  String get custOpen => 'खोलें';

  @override
  String get custMobile => 'मोबाइल';

  @override
  String get custSince => 'ग्राहक कब से';

  @override
  String get custVisits => 'विज़िट';

  @override
  String get custTotalSpent => 'कुल खर्च किया';

  @override
  String get custHistoryEmpty => 'अभी कोई विज़िट या बिल नहीं।';

  @override
  String get custNotesSaved => 'नोट्स सेव हो गए';

  @override
  String get custNotesTabHint =>
      'पसंद, एलर्जी, पसंदीदा स्टाइलिस्ट… (जैसे स्मूदनिंग में कम गरमी पसंद है)';

  @override
  String get custSaveNotes => 'नोट्स सेव करें';

  @override
  String get servicesTitle => 'सर्विस';

  @override
  String get servicesAdd => 'सर्विस जोड़ें';

  @override
  String get servicesEdit => 'सर्विस बदलें';

  @override
  String get servicesEmpty =>
      'अभी कोई सर्विस नहीं। आपका पार्लर जो देता है, वह जोड़ें।';

  @override
  String servicesLoadError(String error) {
    return 'सर्विस लोड नहीं हो सकीं। $error';
  }

  @override
  String get servicesNewCategory => 'नई कैटेगरी';

  @override
  String get servicesNewCategoryHint => 'जैसे ब्राइडल';

  @override
  String get servicesAdded => 'सर्विस जुड़ गई';

  @override
  String get servicesUpdated => 'सर्विस अपडेट हो गई';

  @override
  String servicesDeactivateTitle(String name) {
    return '$name बंद करें?';
  }

  @override
  String get servicesDeactivateMessage =>
      'यह अब नई बुकिंग या बिल में नहीं मिलेगी। पुरानी अपॉइंटमेंट और बिल में यह बनी रहेगी।';

  @override
  String get servicesDeactivated => 'सर्विस बंद की गई';

  @override
  String get servicesReactivated => 'सर्विस फिर से चालू हुई';

  @override
  String get servicesFieldName => 'सर्विस का नाम';

  @override
  String get servicesNameHint => 'जैसे हेयरकट';

  @override
  String get servicesCategory => 'कैटेगरी';

  @override
  String get servicesPrice => 'दाम';

  @override
  String get servicesPriceInvalid => 'दाम रुपये में लिखें।';

  @override
  String get servicesDuration => 'कितना समय';

  @override
  String get servicesCustomDuration => 'अपना समय';

  @override
  String get servicesMinutes => 'मिनट';

  @override
  String get servicesMinutesHint => 'जैसे 75';

  @override
  String get servicesMinutesRequired => 'मिनट लिखें।';

  @override
  String get servicesDescription => 'विवरण';

  @override
  String get servicesGstRate => 'GST रेट';

  @override
  String get servicesGstNote => 'सिर्फ़ तब लगेगा जब सेटिंग्स में GST चालू हो।';

  @override
  String get servicesDeactivate => 'सर्विस बंद करें';

  @override
  String get servicesReactivate => 'सर्विस फिर से चालू करें';

  @override
  String get servicesSave => 'सर्विस सेव करें';

  @override
  String get servicesService => 'सर्विस';

  @override
  String get servicesNotFound => 'यह सर्विस अब मौजूद नहीं है।';

  @override
  String servicesLoadOneError(String error) {
    return 'यह सर्विस लोड नहीं हो सकी। $error';
  }

  @override
  String get staffTitle => 'स्टाफ';

  @override
  String get staffAdd => 'स्टाफ जोड़ें';

  @override
  String get staffEdit => 'स्टाफ बदलें';

  @override
  String get staffSearchHint => 'नाम, रोल या फ़ोन खोजें';

  @override
  String staffLoadError(String error) {
    return 'स्टाफ लोड नहीं हो सका। $error';
  }

  @override
  String get staffNoMatch => 'आपकी खोज से कोई स्टाफ नहीं मिला।';

  @override
  String get staffEmpty => 'अभी कोई स्टाफ नहीं।';

  @override
  String get staffNotFound => 'यह स्टाफ अब मौजूद नहीं है।';

  @override
  String staffDeactivateTitle(String name) {
    return '$name को बंद करें?';
  }

  @override
  String staffDeactivateMessage(String name) {
    return '$name अब नई बुकिंग में नहीं मिलेंगी। पुरानी अपॉइंटमेंट और बिल में उनका नाम रहेगा। आप बाद में फिर से चालू कर सकते हैं।';
  }

  @override
  String get staffDeactivated => 'स्टाफ बंद किया गया';

  @override
  String get staffActivated => 'स्टाफ चालू हुआ';

  @override
  String get staffActivate => 'चालू करें';

  @override
  String get staffMobile => 'मोबाइल';

  @override
  String get staffWorks => 'काम के दिन';

  @override
  String get staffHours => 'समय';

  @override
  String get staffServices => 'सर्विस';

  @override
  String staffHoursRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get staffServicesDone => 'की गई सर्विस';

  @override
  String get staffAmountBilled => 'बिल की गई रकम';

  @override
  String get staffTodayAndUpcoming => 'आज और आने वाली';

  @override
  String get staffNoAppointments => 'कोई अपॉइंटमेंट बुक नहीं।';

  @override
  String get staffFormLoadError =>
      'यह फ़ॉर्म लोड नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get staffAdded => 'स्टाफ जुड़ गया';

  @override
  String get staffUpdated => 'स्टाफ अपडेट हो गया';

  @override
  String get staffFieldName => 'नाम';

  @override
  String get staffFieldMobile => 'मोबाइल नंबर';

  @override
  String get staffMobileInvalid => '10 अंकों का मोबाइल नंबर लिखें।';

  @override
  String get staffRole => 'रोल';

  @override
  String get staffServicesTheyDo => 'कौन-सी सर्विस करती हैं';

  @override
  String get staffClearAll => 'सब हटाएँ';

  @override
  String get staffTickAll => 'सब चुनें';

  @override
  String get staffWorkingDays => 'काम के दिन';

  @override
  String get staffStarts => 'शुरू';

  @override
  String get staffStartHint => 'शुरू';

  @override
  String get staffEnds => 'खत्म';

  @override
  String get staffEndHint => 'खत्म';

  @override
  String get staffNoWorkingDay => 'कम से कम एक काम का दिन चुनें।';

  @override
  String get staffSave => 'स्टाफ सेव करें';

  @override
  String get billingNewBill => 'नया बिल';

  @override
  String get billingOpenBills => 'खुले बिल';

  @override
  String get billingAllBills => 'सभी बिल';

  @override
  String billingLoadError(String error) {
    return 'बिल लोड नहीं हो सके। $error';
  }

  @override
  String get billingNoOpenBills => 'कोई खुला बिल नहीं। सब भुगतान हो चुका है।';

  @override
  String get billingNoBills => 'अभी कोई बिल नहीं।';

  @override
  String get billingDraftBill => 'ड्राफ्ट बिल';

  @override
  String billingDue(String amount) {
    return 'बाकी $amount';
  }

  @override
  String get billingBill => 'बिल';

  @override
  String get billingOpenBill => 'बिल खोलें';

  @override
  String get billingNoLongerDraft => 'यह बिल अब ड्राफ्ट नहीं है।';

  @override
  String billingOpenError(String error) {
    return 'बिल नहीं खुल सका। $error';
  }

  @override
  String get billingEnterNumber => 'नंबर लिखें।';

  @override
  String get billingChooseSavedCustomer => 'सेव किया ग्राहक चुनें';

  @override
  String get billingWalkInName => 'वॉक-इन नाम';

  @override
  String get billingWalkInNameHint => 'जैसे किरण';

  @override
  String get billingCheckDiscount => 'छूट जाँच लें।';

  @override
  String get billingDraftSaved => 'ड्राफ्ट सेव हो गया';

  @override
  String billingSavedNothingToPay(String invoiceNo) {
    return '$invoiceNo सेव हो गया। कुछ भी बाकी नहीं।';
  }

  @override
  String get billingCreateBill => 'बिल बनाएँ';

  @override
  String get billingChange => 'बदलें';

  @override
  String get billingItems => 'आइटम';

  @override
  String get billingSwipeToRemove => 'हटाने के लिए लाइन को बाईं ओर खिसकाएँ।';

  @override
  String get billingAddItem => 'सर्विस या प्रोडक्ट जोड़ें';

  @override
  String get billingDiscount => 'छूट';

  @override
  String get billingDiscountHintPercent => 'जैसे 10';

  @override
  String get billingDiscountHintAmount => 'जैसे 300';

  @override
  String get billingSaveDraft => 'ड्राफ्ट सेव करें';

  @override
  String get billingProceedToPayment => 'पेमेंट पर जाएँ';

  @override
  String get billingBillGone => 'यह बिल अब मौजूद नहीं है।';

  @override
  String billingLoadBillError(String error) {
    return 'यह बिल लोड नहीं हो सका। $error';
  }

  @override
  String get billingVoidTitle => 'यह बिल रद्द करें?';

  @override
  String get billingVoidMessage =>
      'बिल और उसके पेमेंट रद्द माने जाएँगे और बेचे गए प्रोडक्ट वापस स्टॉक में चले जाएँगे। बिल नंबर दोबारा इस्तेमाल नहीं होगा।';

  @override
  String get billingVoidBill => 'बिल रद्द करें';

  @override
  String get billingVoided => 'बिल रद्द हो गया';

  @override
  String get billingMoreActions => 'और विकल्प';

  @override
  String get billingPrintReceipt => 'रसीद प्रिंट करें';

  @override
  String get billingDownloadPdf => 'PDF डाउनलोड करें';

  @override
  String get billingVoidBanner =>
      'यह बिल रद्द है। इसके पेमेंट गिने नहीं जाते और इसके प्रोडक्ट वापस स्टॉक में चले गए।';

  @override
  String get billingPaidAmount => 'भुगतान किया';

  @override
  String get billingBalanceDue => 'बाकी रकम';

  @override
  String get billingPayments => 'पेमेंट';

  @override
  String get billingVoidTag => 'रद्द';

  @override
  String get billingShare => 'शेयर';

  @override
  String get billingRecordPayment => 'पेमेंट दर्ज करें';

  @override
  String get billingShareReceiptWhatsApp => 'WhatsApp पर रसीद भेजें';

  @override
  String billingStylistName(String name) {
    return 'स्टाइलिस्ट: $name';
  }

  @override
  String get billingAddToBill => 'बिल में जोड़ें';

  @override
  String get billingSearchItems => 'सर्विस या प्रोडक्ट खोजें';

  @override
  String get billingServicesTab => 'सर्विस';

  @override
  String get billingProductsTab => 'प्रोडक्ट';

  @override
  String get billingNoSellingPrice => 'बेचने का दाम नहीं डाला';

  @override
  String billingInStockCount(int count) {
    return 'स्टॉक में: $count';
  }

  @override
  String get billingNoMatch => 'आपकी खोज से कुछ नहीं मिला।';

  @override
  String billingReceiptShareText(String parlour) {
    return '$parlour की रसीद';
  }

  @override
  String get billingShareFailed => 'इस फ़ोन पर शेयर नहीं खुल सका।';

  @override
  String get billingPrintFailed => 'इस फ़ोन पर प्रिंट नहीं खुल सका।';

  @override
  String get billingDownloadFailed => 'इस फ़ोन पर PDF सेव नहीं हो सकी।';

  @override
  String get billingReceiptFailed => 'रसीद नहीं बन सकी।';

  @override
  String get billingSubtotal => 'उप-योग';

  @override
  String get billingGst => 'GST';

  @override
  String get billingTotal => 'कुल';

  @override
  String get paymentTitle => 'पेमेंट';

  @override
  String get paymentFinishBillFirst => 'पेमेंट लेने से पहले बिल पूरा करें।';

  @override
  String get paymentFullyPaid => 'इस बिल का पूरा भुगतान हो चुका है।';

  @override
  String get paymentEnterAmount => 'मिली रकम लिखें।';

  @override
  String get paymentFullBalance => 'पूरी बाकी रकम';

  @override
  String paymentPartial(String amount) {
    return 'आंशिक · $amount फिर भी बाकी रहेगा';
  }

  @override
  String get paymentBillTotal => 'बिल का कुल';

  @override
  String get paymentAlreadyReceived => 'पहले से मिला';

  @override
  String get paymentMethodLabel => 'पेमेंट का तरीका';

  @override
  String get paymentUpiNote =>
      'सिर्फ़ पेमेंट दर्ज होता है; ऐप UPI की जाँच नहीं करता।';

  @override
  String get paymentAmountReceived => 'मिली रकम';

  @override
  String get paymentNote => 'नोट';

  @override
  String get paymentConfirm => 'पक्का करें';

  @override
  String paymentConfirmAmount(String amount) {
    return '$amount पक्का करें';
  }

  @override
  String get paymentNotFound => 'यह पेमेंट नहीं मिला।';

  @override
  String get paymentRecorded => 'पेमेंट दर्ज हो गया';

  @override
  String paymentAmountByMethod(String amount, String method) {
    return '$amount $method से';
  }

  @override
  String paymentTotalAmount(String amount) {
    return 'कुल $amount';
  }

  @override
  String get paymentBalance => 'बाकी';

  @override
  String get paymentBookNextVisit => 'अगली विज़िट बुक करें';

  @override
  String get paymentBackToDashboard => 'डैशबोर्ड पर वापस';

  @override
  String get inventoryTitle => 'स्टॉक';

  @override
  String get inventoryAddProduct => 'प्रोडक्ट जोड़ें';

  @override
  String get inventorySearch => 'प्रोडक्ट खोजें';

  @override
  String get inventoryAllItems => 'सभी आइटम';

  @override
  String inventoryTabCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String inventoryLoadError(String error) {
    return 'प्रोडक्ट लोड नहीं हो सके। $error';
  }

  @override
  String get inventoryEmpty => 'अभी कोई प्रोडक्ट नहीं।';

  @override
  String get inventoryNoneLow => 'कुछ भी कम नहीं है।';

  @override
  String get inventoryNoneOut => 'किसी का स्टॉक खत्म नहीं है।';

  @override
  String get inventoryProduct => 'प्रोडक्ट';

  @override
  String get inventoryProductGone => 'यह प्रोडक्ट अब मौजूद नहीं है।';

  @override
  String get inventoryEditProduct => 'प्रोडक्ट बदलें';

  @override
  String get inventoryInStockLabel => 'स्टॉक में';

  @override
  String get inventoryLowStockAlertAt => 'कम स्टॉक अलर्ट कब';

  @override
  String get inventorySellingPrice => 'बेचने का दाम';

  @override
  String get inventoryNotSet => 'नहीं डाला';

  @override
  String get inventoryCostPrice => 'खरीद का दाम';

  @override
  String get inventoryStockHistory => 'स्टॉक हिस्ट्री';

  @override
  String get inventoryNoStockChanges => 'स्टॉक में अभी कोई बदलाव नहीं।';

  @override
  String get inventoryAdjustStock => 'स्टॉक ठीक करें';

  @override
  String get inventoryProductUpdated => 'प्रोडक्ट अपडेट हो गया';

  @override
  String get inventoryProductAdded => 'प्रोडक्ट जुड़ गया';

  @override
  String inventoryDeactivateTitle(String name) {
    return '$name बंद करें?';
  }

  @override
  String get inventoryDeactivateMessage =>
      'यह अब बिल में नहीं मिलेगा। इसकी स्टॉक हिस्ट्री रहेगी।';

  @override
  String get inventoryDeactivated => 'प्रोडक्ट बंद किया गया';

  @override
  String get inventoryReactivated => 'प्रोडक्ट फिर से चालू हुआ';

  @override
  String get inventoryEnterOpeningStock => 'शुरुआती स्टॉक लिखें।';

  @override
  String get inventoryEnterAlertLevel => 'अलर्ट लेवल लिखें।';

  @override
  String get inventoryEnterPrice => 'दाम रुपये में लिखें।';

  @override
  String get inventoryName => 'नाम';

  @override
  String get inventoryNameHint => 'जैसे हेयर सीरम';

  @override
  String inventoryStockInfo(int qty, String unit) {
    return 'स्टॉक में: $qty $unit। इसे बदलने के लिए प्रोडक्ट स्क्रीन पर \"स्टॉक ठीक करें\" इस्तेमाल करें।';
  }

  @override
  String get inventoryOpeningStock => 'शुरुआती स्टॉक';

  @override
  String get inventoryOpeningStockHint => 'जैसे 10';

  @override
  String get inventoryUnit => 'यूनिट';

  @override
  String get inventoryCategory => 'कैटेगरी';

  @override
  String get inventoryCategoryHint => 'जैसे बालों की देखभाल';

  @override
  String get inventoryDeactivateProduct => 'प्रोडक्ट बंद करें';

  @override
  String get inventoryReactivateProduct => 'प्रोडक्ट फिर से चालू करें';

  @override
  String get inventorySaveProduct => 'प्रोडक्ट सेव करें';

  @override
  String inventoryOnlyInStock(int count) {
    return 'स्टॉक में सिर्फ़ $count हैं।';
  }

  @override
  String get inventorySameAsCurrent => 'यह अभी के स्टॉक जितना ही है।';

  @override
  String get inventoryStockUpdated => 'स्टॉक अपडेट हो गया';

  @override
  String inventoryAdjustSubtitle(String name, int qty, String unit) {
    return '$name · अभी $qty $unit';
  }

  @override
  String get inventoryAdjustType => 'प्रकार';

  @override
  String get inventoryCountedQty => 'गिनी गई मात्रा';

  @override
  String get inventoryQty => 'मात्रा';

  @override
  String inventoryNewStock(int qty, String unit) {
    return 'नया स्टॉक: $qty $unit';
  }

  @override
  String get inventoryNote => 'नोट';

  @override
  String get inventoryNoteHint => 'जैसे सप्लायर से खरीदा';

  @override
  String inventoryStockLine(int qty, String unit) {
    return 'स्टॉक: $qty $unit';
  }

  @override
  String receiptPhone(String phone) {
    return 'फ़ोन $phone';
  }

  @override
  String receiptGstin(String gstin) {
    return 'GSTIN $gstin';
  }

  @override
  String get receiptTaxInvoice => 'टैक्स इनवॉइस';

  @override
  String get receiptHeading => 'रसीद';

  @override
  String get receiptItem => 'आइटम';

  @override
  String get receiptQty => 'मात्रा';

  @override
  String get receiptRate => 'रेट';

  @override
  String get receiptAmount => 'रकम';

  @override
  String receiptStylist(String name) {
    return 'स्टाइलिस्ट: $name';
  }

  @override
  String get receiptSubtotal => 'उप-योग';

  @override
  String get receiptDiscount => 'छूट';

  @override
  String get receiptGst => 'GST';

  @override
  String get receiptTotal => 'कुल';

  @override
  String get receiptPaid => 'भुगतान हुआ';

  @override
  String get receiptBalance => 'बाकी';

  @override
  String get receiptPayments => 'पेमेंट';

  @override
  String get receiptNotTaxInvoice =>
      'यह पेमेंट की रसीद है, GST टैक्स इनवॉइस नहीं।';
}
