class FestivalLocalizer {
  /// Map display tags like "Ugadi" to a slug, then localized name; falls back to [tag].
  static String displayFromTag(String? tag, String lang) {
    if (tag == null || tag.isEmpty) return '';
    final slug = tag.toLowerCase().trim().replaceAll(RegExp(r'\s+'), '_');
    final localized = getName(slug, lang);
    if (localized != slug) return localized;
    return tag;
  }

  static const Map<String, Map<String, String>> _festivals = {
    'ugadi': {
      'te': 'ఉగాది',
      'hi': 'उगादि',
      'ta': 'உகாதி',
      'kn': 'ಯುಗಾದಿ',
      'ml': 'ഉഗാദി',
      'en': 'Ugadi',
    },
    'diwali': {
      'te': 'దీపావళి',
      'hi': 'दीवाली',
      'ta': 'தீபாவளி',
      'kn': 'ದೀಪಾವಳಿ',
      'ml': 'ദീപാവലി',
      'en': 'Diwali',
    },
    'holi': {
      'te': 'హోలీ',
      'hi': 'होली',
      'ta': 'ஹோலி',
      'kn': 'ಹೋಲಿ',
      'ml': 'ഹോളി',
      'en': 'Holi',
    },
    'eid': {
      'te': 'ఈద్',
      'hi': 'ईद',
      'ta': 'ஈத்',
      'kn': 'ಈದ್',
      'ml': 'ഈദ്',
      'en': 'Eid',
    },
    'christmas': {
      'te': 'క్రిస్మస్',
      'hi': 'क्रिसमस',
      'ta': 'கிறிஸ்துமஸ்',
      'kn': 'ಕ್ರಿಸ್ಮಸ್',
      'ml': 'ക്രിസ്മസ്',
      'en': 'Christmas',
    },
    'pongal': {
      'te': 'పొంగల్',
      'hi': 'पोंगल',
      'ta': 'பொங்கல்',
      'kn': 'ಪೊಂಗಲ್',
      'ml': 'പൊങ്കൽ',
      'en': 'Pongal',
    },
    'onam': {
      'te': 'ఓణం',
      'hi': 'ओणम',
      'ta': 'ஓணம்',
      'kn': 'ಓಣಂ',
      'ml': 'ഓണം',
      'en': 'Onam',
    },
    'navratri': {
      'te': 'నవరాత్రి',
      'hi': 'नवरात्रि',
      'ta': 'நவராத்திரி',
      'kn': 'ನವರಾತ್ರಿ',
      'ml': 'നവരാത്രി',
      'en': 'Navratri',
    },
    'sankranti': {
      'te': 'సంక్రాంతి',
      'hi': 'मकर संक्रांति',
      'ta': 'தை பொங்கல்',
      'kn': 'ಸಂಕ್ರಾಂತಿ',
      'ml': 'മകരവിളക്ക്',
      'en': 'Sankranti',
    },
    'rama_navami': {
      'te': 'శ్రీరామ నవమి',
      'hi': 'राम नवमी',
      'ta': 'ராம நவமி',
      'kn': 'ರಾಮ ನವಮಿ',
      'ml': 'രാമ നവമി',
      'en': 'Sri Rama Navami',
    },
    'hanuman_jayanti': {
      'te': 'హనుమాన్ జయంతి',
      'hi': 'हनुमान जयंती',
      'ta': 'அனுமன் ஜெயந்தி',
      'kn': 'ಹನುಮ ಜಯಂತಿ',
      'ml': 'ഹനുമാൻ ജയന്തി',
      'en': 'Hanuman Jayanti',
    },
  };

  static String getName(String slug, String lang) {
    final row = _festivals[slug];
    if (row == null) return slug;
    return row[lang] ?? row['en'] ?? slug;
  }
}
