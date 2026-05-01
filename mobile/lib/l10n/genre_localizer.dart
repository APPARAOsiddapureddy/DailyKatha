/// Culturally meaningful genre titles per content language (not transliteration).
class GenreLocalizer {
  static const Map<String, Map<String, String>> _names = {
    'goodmorning': {
      'te': 'శుభోదయం',
      'hi': 'सुप्रभात',
      'ta': 'காலை வணக்கம்',
      'kn': 'ಶುಭೋದಯ',
      'ml': 'സുപ്രഭാതം',
      'en': 'Good Morning',
    },
    'goodnight': {
      'te': 'శుభరాత్రి',
      'hi': 'शुभ रात्रि',
      'ta': 'இரவு வணக்கம்',
      'kn': 'ಶುಭ ರಾತ್ರಿ',
      'ml': 'ശുഭരാത്രി',
      'en': 'Good Night',
    },
    'love': {
      'te': 'ప్రేమ',
      'hi': 'इश्क़',
      'ta': 'காதல்',
      'kn': 'ಪ್ರೀತಿ',
      'ml': 'പ്രേമം',
      'en': 'Love',
    },
    'bhakti': {
      'te': 'భక్తి',
      'hi': 'भक्ति',
      'ta': 'பக்தி',
      'kn': 'ಭಕ್ತಿ',
      'ml': 'ഭക്തി',
      'en': 'Devotion',
    },
    'motivation': {
      'te': 'స్ఫూర్తి',
      'hi': 'प्रेरणा',
      'ta': 'உந்துதல்',
      'kn': 'ಪ್ರೇರಣೆ',
      'ml': 'പ്രചോദനം',
      'en': 'Motivation',
    },
    'festival': {
      'te': 'పండుగ',
      'hi': 'त्योहार',
      'ta': 'திருவிழா',
      'kn': 'ಹಬ್ಬ',
      'ml': 'ഉത്സവം',
      'en': 'Festival',
    },
    'family': {
      'te': 'కుటుంబం',
      'hi': 'परिवार',
      'ta': 'குடும்பம்',
      'kn': 'ಕುಟುಂಬ',
      'ml': 'കുടുംബം',
      'en': 'Family',
    },
    'cinema': {
      'te': 'సినిమా',
      'hi': 'सिनेमा',
      'ta': 'சினிமா',
      'kn': 'ಸಿನಿಮಾ',
      'ml': 'സിനിമ',
      'en': 'Cinema',
    },
    'heroes': {
      'te': 'వీరులు',
      'hi': 'वीर',
      'ta': 'வீரர்கள்',
      'kn': 'ವೀರರು',
      'ml': 'വീരന്മാർ',
      'en': 'Heroes',
    },
    'poetry': {
      'te': 'కవిత్వం',
      'hi': 'शायरी',
      'ta': 'கவிதை',
      'kn': 'ಕವಿತೆ',
      'ml': 'കവിത',
      'en': 'Poetry',
    },
    'friendship': {
      'te': 'స్నేహం',
      'hi': 'दोस्ती',
      'ta': 'நட்பு',
      'kn': 'ಸ್ನೇಹ',
      'ml': 'സൗഹൃദം',
      'en': 'Friendship',
    },
    'birthday': {
      'te': 'పుట్టినరోజు',
      'hi': 'जन्मदिन',
      'ta': 'பிறந்தநாள்',
      'kn': 'ಹುಟ್ಟುಹಬ್ಬ',
      'ml': 'ജന്മദിനം',
      'en': 'Birthday',
    },
  };

  static String getName(String genreId, String lang) {
    final row = _names[genreId];
    if (row == null) return genreId;
    return row[lang] ?? row['en'] ?? genreId;
  }
}
