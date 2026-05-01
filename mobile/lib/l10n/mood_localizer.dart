class MoodLocalizer {
  static const Map<String, Map<String, String>> _moods = {
    'warm': {
      'te': 'వెచ్చని',
      'hi': 'गर्मजोशी',
      'ta': 'அன்பான',
      'kn': 'ಆತ್ಮೀಯ',
      'ml': 'ഊഷ്മളമായ',
      'en': 'Warm',
    },
    'devotional': {
      'te': 'భక్తిపూర్వక',
      'hi': 'भक्तिपूर्ण',
      'ta': 'பக்தியான',
      'kn': 'ಭಕ್ತಿಪರ',
      'ml': 'ഭക്തിനിർഭരമായ',
      'en': 'Devotional',
    },
    'bold': {
      'te': 'ధైర్యమైన',
      'hi': 'साहसी',
      'ta': 'தைரியமான',
      'kn': 'ಧೈರ್ಯಶಾಲಿ',
      'ml': 'ധൈര്യമുള്ള',
      'en': 'Bold',
    },
    'festive': {
      'te': 'ఉత్సాహమైన',
      'hi': 'उत्सवपूर्ण',
      'ta': 'கொண்டாட்டமான',
      'kn': 'ಉತ್ಸಾಹಪೂರ್ಣ',
      'ml': 'ഉത്സവപ്രധാനമായ',
      'en': 'Festive',
    },
    'calm': {
      'te': 'శాంతమైన',
      'hi': 'शांत',
      'ta': 'அமைதியான',
      'kn': 'ಶಾಂತ',
      'ml': 'ശാന്തമായ',
      'en': 'Calm',
    },
    'romantic': {
      'te': 'రొమాంటిక్',
      'hi': 'रूमानी',
      'ta': 'காதல் நிறைந்த',
      'kn': 'ರೊಮ್ಯಾಂಟಿಕ್',
      'ml': 'റൊമാന്റിക്',
      'en': 'Romantic',
    },
    'cool': {
      'te': 'కూల్',
      'hi': 'कूल',
      'ta': 'குளிர்ந்த',
      'kn': 'ಕೂಲ್',
      'ml': 'കൂൾ',
      'en': 'Cool',
    },
  };

  static String getName(String moodId, String lang) {
    final row = _moods[moodId];
    if (row == null) return moodId;
    return row[lang] ?? row['en'] ?? moodId;
  }
}
