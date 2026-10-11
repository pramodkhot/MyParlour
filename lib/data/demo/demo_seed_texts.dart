import '../../core/l10n/app_language.dart';

/// Sample-data text in Marathi and Hindi: service and product names, notes
/// and the receipt footer. Parlour owners mostly use the English words for
/// services ("हेअरकट"), so those are written as spoken. Customer and staff
/// names stay as they are.
String seedText(AppLanguage language, String english) =>
    _texts[language]?[english] ?? english;

const _texts = <AppLanguage, Map<String, String>>{
  AppLanguage.mr: {
    // Services
    'Haircut': 'हेअरकट',
    'Hair Spa': 'हेअर स्पा',
    'Smoothening': 'स्मूदनिंग',
    'Hair Colour': 'हेअर कलर',
    'Facial': 'फेशियल',
    'Cleanup': 'क्लीनअप',
    'Threading': 'थ्रेडिंग',
    'Waxing (full arms)': 'वॅक्सिंग (पूर्ण हात)',
    'Manicure': 'मॅनिक्युअर',
    'Pedicure': 'पेडिक्युअर',
    // Products
    'Hair Serum': 'हेअर सीरम',
    'Face Cream': 'फेस क्रीम',
    'Shampoo': 'शॅम्पू',
    'Conditioner': 'कंडिशनर',
    'Wax Strips': 'वॅक्स स्ट्रिप्स',
    'Nail Polish': 'नेल पॉलिश',
    'Face Wash': 'फेस वॉश',
    // Notes
    'Prefers less heat in smoothening.': 'स्मूदनिंगमध्ये कमी उष्णता आवडते.',
    'Likes Riya for hair colour.': 'हेअर कलरसाठी Riya आवडते.',
    'Sensitive skin: patch test before facial.':
        'संवेदनशील त्वचा: फेशियलपूर्वी पॅच टेस्ट करा.',
    'Allergic to strong fragrance.': 'तीव्र सुगंधाची ॲलर्जी.',
    'Opening stock': 'सुरुवातीचा स्टॉक',
    'Customer was unwell': 'ग्राहकाची तब्येत बरी नव्हती',
    'Rescheduled by customer': 'ग्राहकाने वेळ बदलली',
    'Shop rent': 'दुकान भाडे',
    'MSEB bill': 'MSEB वीज बिल',
    'Monthly product purchase': 'मासिक प्रॉडक्ट खरेदी',
    'Thank you! Visit again.': 'धन्यवाद! पुन्हा भेट द्या.',
  },
  AppLanguage.hi: {
    // Services
    'Haircut': 'हेयरकट',
    'Hair Spa': 'हेयर स्पा',
    'Smoothening': 'स्मूदनिंग',
    'Hair Colour': 'हेयर कलर',
    'Facial': 'फेशियल',
    'Cleanup': 'क्लीनअप',
    'Threading': 'थ्रेडिंग',
    'Waxing (full arms)': 'वैक्सिंग (पूरी बाँहें)',
    'Manicure': 'मैनीक्योर',
    'Pedicure': 'पेडीक्योर',
    // Products
    'Hair Serum': 'हेयर सीरम',
    'Face Cream': 'फेस क्रीम',
    'Shampoo': 'शैम्पू',
    'Conditioner': 'कंडीशनर',
    'Wax Strips': 'वैक्स स्ट्रिप्स',
    'Nail Polish': 'नेल पॉलिश',
    'Face Wash': 'फेस वॉश',
    // Notes
    'Prefers less heat in smoothening.': 'स्मूदनिंग में कम गर्मी पसंद है।',
    'Likes Riya for hair colour.': 'हेयर कलर के लिए Riya पसंद है।',
    'Sensitive skin: patch test before facial.':
        'संवेदनशील त्वचा: फेशियल से पहले पैच टेस्ट करें।',
    'Allergic to strong fragrance.': 'तेज़ खुशबू से एलर्जी।',
    'Opening stock': 'शुरुआती स्टॉक',
    'Customer was unwell': 'ग्राहक की तबीयत ठीक नहीं थी',
    'Rescheduled by customer': 'ग्राहक ने समय बदला',
    'Shop rent': 'दुकान का किराया',
    'MSEB bill': 'MSEB बिजली बिल',
    'Monthly product purchase': 'मासिक प्रोडक्ट खरीद',
    'Thank you! Visit again.': 'धन्यवाद! फिर से पधारें।',
  },
};
