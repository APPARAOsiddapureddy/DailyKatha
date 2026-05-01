import '../../models/catalog_models.dart';
import '../../models/katha_card.dart';

/// Small in-repo sample when bundled language JSON is unavailable; onboarding lists.
abstract final class MockCatalog {
  static const List<LanguageOption> languages = [
    LanguageOption(id: 'te', nativeName: 'తెలుగు', englishName: 'Telugu', speakersLabel: '83M', emoji: '🌾'),
    LanguageOption(id: 'hi', nativeName: 'हिन्दी', englishName: 'Hindi', speakersLabel: '528M', emoji: '🪔'),
    LanguageOption(id: 'ta', nativeName: 'தமிழ்', englishName: 'Tamil', speakersLabel: '75M', emoji: '🌺'),
    LanguageOption(id: 'kn', nativeName: 'ಕನ್ನಡ', englishName: 'Kannada', speakersLabel: '44M', emoji: '🌻'),
    LanguageOption(id: 'ml', nativeName: 'മലയാളം', englishName: 'Malayalam', speakersLabel: '35M', emoji: '🌴'),
    LanguageOption(id: 'en', nativeName: 'English', englishName: 'English', speakersLabel: 'Global', emoji: '🌐'),
  ];

  static const List<ReligionOption> religions = [
    ReligionOption(
      id: 'hindu',
      englishLabel: 'Hindu',
      nativeLabel: 'హిందూ',
      note: 'Bhakti, devotional quotes, gods & festivals',
    ),
    ReligionOption(
      id: 'muslim',
      englishLabel: 'Islam',
      nativeLabel: 'ఇస్లాం',
      note: 'Duas, Ramadan, Eid greetings',
    ),
    ReligionOption(
      id: 'christian',
      englishLabel: 'Christian',
      nativeLabel: 'క్రైస్తవ',
      note: 'Bible verses, prayers, blessings',
    ),
    ReligionOption(
      id: 'sikh',
      englishLabel: 'Sikh',
      nativeLabel: 'సిక్కు',
      note: 'Gurbani, Waheguru, Gurpurab',
    ),
    ReligionOption(
      id: 'spiritual',
      englishLabel: 'Spiritual',
      nativeLabel: 'ఆధ్యాత్మిక',
      note: 'Inner peace, meditation, all paths',
    ),
    ReligionOption(
      id: 'none',
      englishLabel: 'Show all',
      nativeLabel: 'అన్నీ చూపించు',
      note: 'No preference — show me everything',
    ),
  ];

  static const List<InterestOption> interests = [
    InterestOption(id: 'goodmorning', emoji: '☀️', englishLabel: 'Good Morning', nativeLabel: 'శుభోదయం', tone: 'gold'),
    InterestOption(id: 'goodnight', emoji: '🌙', englishLabel: 'Good Night', nativeLabel: 'శుభరాత్రి', tone: 'indigo'),
    InterestOption(id: 'love', emoji: '❤️', englishLabel: 'Love', nativeLabel: 'ప్రేమ', tone: 'kumkum'),
    InterestOption(id: 'bhakti', emoji: '🪔', englishLabel: 'Devotional', nativeLabel: 'భక్తి', tone: 'marigold'),
    InterestOption(id: 'motivation', emoji: '🔥', englishLabel: 'Motivation', nativeLabel: 'ప్రేరణ', tone: 'marigold'),
    InterestOption(id: 'festival', emoji: '🎉', englishLabel: 'Festivals', nativeLabel: 'పండుగలు', tone: 'kumkum'),
    InterestOption(id: 'family', emoji: '👨‍👩‍👧', englishLabel: 'Family', nativeLabel: 'కుటుంబం', tone: 'peacock'),
    InterestOption(id: 'cinema', emoji: '🎬', englishLabel: 'Cinema', nativeLabel: 'సినిమా', tone: 'indigo'),
    InterestOption(id: 'heroes', emoji: '⭐', englishLabel: 'Heroes', nativeLabel: 'హీరోలు', tone: 'gold'),
    InterestOption(id: 'poetry', emoji: '📜', englishLabel: 'Poetry', nativeLabel: 'కవిత్వం', tone: 'peacock'),
    InterestOption(id: 'friendship', emoji: '🤝', englishLabel: 'Friendship', nativeLabel: 'స్నేహం', tone: 'gold'),
    InterestOption(id: 'birthday', emoji: '🎂', englishLabel: 'Birthday', nativeLabel: 'జన్మదినం', tone: 'kumkum'),
  ];

  static const List<KathaCard> cards = [
    KathaCard(
      id: '1',
      section: 'morning',
      category: 'goodmorning',
      mood: 'warm',
      quote: {
        'te': 'ప్రతి ఉదయం\nఒక కొత్త ఆశ',
        'hi': 'हर सुबह\nएक नई उम्मीद',
        'ta': 'ஒவ்வொரு காலையும்\nஒரு புதிய நம்பிக்கை',
        'kn': 'ಪ್ರತಿ ಬೆಳಿಗ್ಗೆ\nಒಂದು ಹೊಸ ಭರವಸೆ',
        'ml': 'ഓരോ പ്രഭാതവും\nഒരു പുതിയ പ്രതീക്ഷ',
        'en': 'Every morning\nis a new hope',
      },
      author: {
        'te': '— తెలుగు సామెత',
        'hi': '— जीवन सूत्र',
        'ta': '— வாழ்க்கை வரி',
        'kn': '— ಜೀವನ ಸತ್ಯ',
        'ml': '— ജീവിത വാക്യം',
        'en': '— a daily truth',
      },
    ),
    KathaCard(
      id: '2',
      section: 'trending',
      category: 'bhakti',
      mood: 'devotional',
      quote: {
        'te': 'హర హర\nమహాదేవ',
        'hi': 'हर हर\nमहादेव',
        'ta': 'ஹர ஹர\nமகாதேவ',
        'kn': 'ಹರ ಹರ\nಮಹಾದೇವ',
        'ml': 'ഹര ഹര\nമഹാദേവ',
        'en': 'Har Har\nMahadev',
      },
      author: {
        'te': '— శివ మంత్రం',
        'hi': '— शिव मंत्र',
        'ta': '— சிவ மந்திரம்',
        'kn': '— ಶಿವ ಮಂತ್ರ',
        'ml': '— ശിവ മന്ത്രം',
        'en': '— Shiva mantra',
      },
    ),
    KathaCard(
      id: '3',
      section: 'interests',
      category: 'motivation',
      mood: 'bold',
      quote: {
        'te': 'కష్టపడే వారిని\nదేవుడు దీవిస్తాడు',
        'hi': 'मेहनत करने वालों को\nभगवान आशीर्वाद देते हैं',
        'ta': 'உழைப்பவர்களை\nஇறைவன் ஆசிர்வதிக்கிறான்',
        'kn': 'ಶ್ರಮಿಸುವವರನ್ನು\nದೇವರು ಆಶೀರ್ವದಿಸುತ್ತಾನೆ',
        'ml': 'കഠിനാധ്വാനികളെ\nദൈവം അനുഗ്രഹിക്കുന്നു',
        'en': 'God blesses\nthose who work hard',
      },
      author: {
        'te': '— జీవిత సత్యం',
        'hi': '— जीवन सत्य',
        'ta': '— வாழ்க்கை உண்மை',
        'kn': '— ಜೀವನ ಸತ್ಯ',
        'ml': '— ജീവിത സത്യം',
        'en': '— a life truth',
      },
    ),
    KathaCard(
      id: '4',
      section: 'festival',
      category: 'festival',
      mood: 'festive',
      isFestival: true,
      festivalTag: 'Ugadi',
      quote: {
        'te': 'ఉగాది శుభాకాంక్షలు\nసుఖశాంతులు నిండాలి',
        'hi': 'उगादि की शुभकामनाएं\nसुख शांति बनी रहे',
        'ta': 'உகாதி வாழ்த்துக்கள்\nமகிழ்ச்சி நிறைக',
        'kn': 'ಯುಗಾದಿ ಶುಭಾಶಯಗಳು\nಸಂತೋಷ ತುಂಬಲಿ',
        'ml': 'ഉഗാദി ആശംസകൾ\nസന്തോഷം നിറയട്ടെ',
        'en': 'Happy Ugadi\nMay joy fill the year',
      },
      author: {
        'te': '— ఉగాది 2026',
        'hi': '— उगादि 2026',
        'ta': '— உகாதி 2026',
        'kn': '— ಯುಗಾದಿ 2026',
        'ml': '— ഉഗാദി 2026',
        'en': '— Ugadi 2026',
      },
    ),
    KathaCard(
      id: '5',
      section: 'evening',
      category: 'goodnight',
      mood: 'calm',
      quote: {
        'te': 'తీపి కలలు\nశాంతి నిద్ర',
        'hi': 'मीठे सपने\nशांत नींद',
        'ta': 'இனிய கனவுகள்\nஅமைதியான தூக்கம்',
        'kn': 'ಸಿಹಿ ಕನಸುಗಳು\nಶಾಂತ ನಿದ್ರೆ',
        'ml': 'മധുര സ്വപ്നങ്ങൾ\nശാന്ത ഉറക്കം',
        'en': 'Sweet dreams\npeaceful sleep',
      },
      author: {
        'te': '— శుభరాత్రి',
        'hi': '— शुभ रात्रि',
        'ta': '— இனிய இரவு',
        'kn': '— ಶುಭ ರಾತ್ರಿ',
        'ml': '— ശുഭ രാത്രി',
        'en': '— Good night',
      },
    ),
    KathaCard(
      id: '6',
      section: 'interests',
      category: 'love',
      mood: 'romantic',
      quote: {
        'te': 'నీతో ప్రతి క్షణం\nఒక కావ్యం',
        'hi': 'तुम्हारे साथ हर पल\nएक कविता',
        'ta': 'உன்னுடன் ஒவ்வொரு கணமும்\nஒரு கவிதை',
        'kn': 'ನಿನ್ನೊಂದಿಗಿನ ಪ್ರತಿ ಕ್ಷಣವೂ\nಒಂದು ಕವಿತೆ',
        'ml': 'നിന്നോടൊപ്പമുള്ള ഓരോ നിമിഷവും\nഒരു കവിത',
        'en': 'Every moment with you\nis a poem',
      },
      author: {
        'te': '— ప్రేమ కవిత',
        'hi': '— प्रेम कविता',
        'ta': '— காதல் கவிதை',
        'kn': '— ಪ್ರೀತಿಯ ಕವನ',
        'ml': '— സ്നേഹ കവിത',
        'en': '— a love poem',
      },
    ),
    KathaCard(
      id: '7',
      section: 'trending',
      category: 'cinema',
      mood: 'bold',
      quote: {
        'te': 'నేను నమ్మినది\nచేస్తాను',
        'hi': 'जो मैं मानता हूँ\nवही करता हूँ',
        'ta': 'நான் நம்புவதை\nநான் செய்கிறேன்',
        'kn': 'ನಾನು ನಂಬಿದ್ದನ್ನು\nಮಾಡುತ್ತೇನೆ',
        'ml': 'ഞാൻ വിശ്വസിക്കുന്നത്\nചെയ്യുന്നു',
        'en': 'I do what\nI believe in',
      },
      author: {
        'te': '— సినిమా డైలాగ్',
        'hi': '— सिनेमा डायलॉग',
        'ta': '— சினிமா வசனம்',
        'kn': '— ಸಿನಿಮಾ ಡೈಲಾಗ್',
        'ml': '— സിനിമ ഡയലോഗ്',
        'en': '— cinema dialogue',
      },
    ),
    KathaCard(
      id: '8',
      section: 'trending',
      category: 'friendship',
      mood: 'warm',
      quote: {
        'te': 'నిజమైన స్నేహితుడు\nఒక అదృష్టం',
        'hi': 'सच्चा दोस्त\nएक वरदान है',
        'ta': 'உண்மையான நண்பன்\nஒரு வரம்',
        'kn': 'ನಿಜವಾದ ಸ್ನೇಹಿತ\nಒಂದು ವರ',
        'ml': 'യഥാർത്ഥ സുഹൃത്ത്\nഒരു അനുഗ്രഹം',
        'en': 'A true friend\nis a blessing',
      },
      author: {
        'te': '— స్నేహ కవిత',
        'hi': '— दोस्ती पर',
        'ta': '— நட்பு பற்றி',
        'kn': '— ಸ್ನೇಹದ ಬಗ್ಗೆ',
        'ml': '— സൗഹൃദത്തിൽ',
        'en': '— on friendship',
      },
    ),
  ];

  static const List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      type: 'festival',
      icon: '🎊',
      timeAgo: '2h',
      title: {
        'te': 'ఉగాది ప్రత్యేక సేకరణ',
        'en': 'Ugadi special collection',
      },
      body: {
        'te': '50+ కొత్త వాల్‌పేపర్లు',
        'en': '50+ new wallpapers added',
      },
    ),
    AppNotification(
      id: 'n2',
      type: 'morning',
      icon: '☀️',
      timeAgo: '6h',
      title: {'te': 'ఈ రోజు శుభోదయం', 'en': "Today's good morning"},
      body: {'te': '3 కొత్త మెసేజెస్', 'en': '3 new messages ready to send'},
    ),
  ];

  static const List<ExploreCategoryTile> exploreCategories = [
    ExploreCategoryTile(
      id: 'goodmorning',
      emoji: '☀️',
      nativeTitle: 'శుభోదయం',
      englishTitle: 'Good Morning',
      countLabel: '1.2k',
      mood: 'warm',
    ),
    ExploreCategoryTile(
      id: 'bhakti',
      emoji: '🪔',
      nativeTitle: 'భక్తి',
      englishTitle: 'Devotional',
      countLabel: '2.4k',
      mood: 'devotional',
    ),
    ExploreCategoryTile(
      id: 'love',
      emoji: '❤️',
      nativeTitle: 'ప్రేమ',
      englishTitle: 'Love',
      countLabel: '890',
      mood: 'romantic',
    ),
    ExploreCategoryTile(
      id: 'motivation',
      emoji: '🔥',
      nativeTitle: 'ప్రేరణ',
      englishTitle: 'Motivation',
      countLabel: '640',
      mood: 'bold',
    ),
    ExploreCategoryTile(
      id: 'festival',
      emoji: '🎉',
      nativeTitle: 'పండుగలు',
      englishTitle: 'Festivals',
      countLabel: '420',
      mood: 'festive',
    ),
    ExploreCategoryTile(
      id: 'cinema',
      emoji: '🎬',
      nativeTitle: 'సినిమా',
      englishTitle: 'Cinema',
      countLabel: '310',
      mood: 'calm',
    ),
  ];

  static const List<OccasionItem> occasions = [
    OccasionItem(
      festivalSlug: 'ugadi',
      nativeTitle: 'ఉగాది',
      englishTitle: 'Ugadi',
      dateLabel: 'Today',
      hot: true,
    ),
    OccasionItem(
      festivalSlug: 'rama_navami',
      nativeTitle: 'శ్రీరామనవమి',
      englishTitle: 'Sri Rama Navami',
      dateLabel: 'Apr 26',
    ),
    OccasionItem(
      festivalSlug: 'hanuman_jayanti',
      nativeTitle: 'హనుమాన్ జయంతి',
      englishTitle: 'Hanuman Jayanti',
      dateLabel: 'Apr 30',
    ),
  ];

  /// Keys resolved with [GenreLocalizer] / [FestivalLocalizer] for chip labels.
  static const List<String> trendingExploreTags = [
    'ugadi',
    'goodmorning',
    'heroes',
    'diwali',
    'bhakti',
    'love',
  ];
}
