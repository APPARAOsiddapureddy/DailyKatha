/// Short native-script labels for religion options (UI may still show English notes).
class ReligionLocalizer {
  static const Map<String, Map<String, String>> _native = {
    'hindu': {
      'te': 'హిందూ',
      'hi': 'हिन्दू',
      'ta': 'இந்து',
      'kn': 'ಹಿಂದೂ',
      'ml': 'ഹിന്ദു',
      'en': 'Hindu',
    },
    'muslim': {
      'te': 'ఇస్లాం',
      'hi': 'इस्लाम',
      'ta': 'இஸ்லாம்',
      'kn': 'ಇಸ್ಲಾಂ',
      'ml': 'ഇസ്‌ലാം',
      'en': 'Islam',
    },
    'christian': {
      'te': 'క్రైస్తవ',
      'hi': 'ईसाई',
      'ta': 'கிறிஸ்தவர்',
      'kn': 'ಕ್ರಿಶ್ಚಿಯನ್',
      'ml': 'ക്രിസ്ത്യൻ',
      'en': 'Christian',
    },
    'sikh': {
      'te': 'సిక్కు',
      'hi': 'सिख',
      'ta': 'சீக்கியர்',
      'kn': 'ಸಿಖ್',
      'ml': 'സിഖ്',
      'en': 'Sikh',
    },
    'spiritual': {
      'te': 'ఆధ్యాత్మిక',
      'hi': 'आध्यात्मिक',
      'ta': 'ஆன்மீகம்',
      'kn': 'ಆಧ್ಯಾತ್ಮಿಕ',
      'ml': 'ആധ്യാത്മികം',
      'en': 'Spiritual',
    },
    'none': {
      'te': 'అన్నీ చూపించు',
      'hi': 'सभी दिखाएँ',
      'ta': 'அனைத்தையும் காட்டு',
      'kn': 'ಎಲ್ಲವನ್ನೂ ತೋರಿಸಿ',
      'ml': 'എല്ലാം കാണിക്കുക',
      'en': 'Show all',
    },
  };

  static String nativeLabel(String religionId, String lang) {
    final row = _native[religionId];
    if (row == null) return religionId;
    return row[lang] ?? row['en'] ?? religionId;
  }
}
