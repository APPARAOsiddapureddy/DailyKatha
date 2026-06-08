import 'package:flutter/foundation.dart';

import '../../models/katha_card.dart';

@immutable
class StoryPackOption {
  const StoryPackOption({
    required this.id,
    required this.emoji,
    required this.nativeTitle,
    required this.englishTitle,
    required this.daysLabel,
    required this.summary,
  });

  final String id;
  final String emoji;
  final String nativeTitle;
  final String englishTitle;
  final String daysLabel;
  final String summary;
}

abstract final class StoryPackCatalog {
  static const List<StoryPackOption> packs = [
    StoryPackOption(
      id: 'mahabharata',
      emoji: '🏹',
      nativeTitle: 'మహాభారతం',
      englishTitle: 'Mahabharata',
      daysLabel: '100 days',
      summary: 'Dharma, choices, and courage',
    ),
    StoryPackOption(
      id: 'ramayana',
      emoji: '🛕',
      nativeTitle: 'రామాయణం',
      englishTitle: 'Ramayanam',
      daysLabel: '60 days',
      summary: 'Maryada, love, and the noble path',
    ),
    StoryPackOption(
      id: 'shiv_puran',
      emoji: '🔱',
      nativeTitle: 'శివ పురాణం',
      englishTitle: 'Shiv Puranam',
      daysLabel: '40 days',
      summary: 'Stillness, strength, and devotion',
    ),
    StoryPackOption(
      id: 'bhagavad_gita',
      emoji: '📖',
      nativeTitle: 'భగవద్గీత',
      englishTitle: 'Bhagavad Gita',
      daysLabel: '18 days',
      summary: 'Action, clarity, and surrender',
    ),
    StoryPackOption(
      id: 'hanuman',
      emoji: '🪵',
      nativeTitle: 'హనుమాన్',
      englishTitle: 'Hanuman',
      daysLabel: '21 days',
      summary: 'Service, strength, and fearless faith',
    ),
    StoryPackOption(
      id: 'krishna_leela',
      emoji: '🎶',
      nativeTitle: 'కృష్ణలీల',
      englishTitle: 'Krishna Leela',
      daysLabel: '30 days',
      summary: 'Joy, wisdom, and divine play',
    ),
    StoryPackOption(
      id: 'devi_mahatmya',
      emoji: '🌺',
      nativeTitle: 'దేవీ మహాత్మ్యం',
      englishTitle: 'Devi Mahatmya',
      daysLabel: '9 days',
      summary: 'Grace, protection, and courage',
    ),
    StoryPackOption(
      id: 'vedic_wisdom',
      emoji: '🔥',
      nativeTitle: 'వేదజ్ఞానం',
      englishTitle: 'Vedic Wisdom',
      daysLabel: '24 days',
      summary: 'Ancient light for daily life',
    ),
    StoryPackOption(
      id: 'upanishads',
      emoji: '📜',
      nativeTitle: 'ఉపనిషత్తులు',
      englishTitle: 'Upanishads',
      daysLabel: '12 days',
      summary: 'The self, the mind, and awareness',
    ),
    StoryPackOption(
      id: 'puranas',
      emoji: '🪔',
      nativeTitle: 'పురాణాలు',
      englishTitle: 'Puranas',
      daysLabel: '50 days',
      summary: 'Timeless stories of virtue',
    ),
    StoryPackOption(
      id: 'ancient_history',
      emoji: '👑',
      nativeTitle: 'ప్రాచీన చరిత్ర',
      englishTitle: 'Ancient History',
      daysLabel: '28 days',
      summary: 'Kings, kingdoms, and dharma',
    ),
    StoryPackOption(
      id: 'saints_sages',
      emoji: '🙏',
      nativeTitle: 'సంతులు & ఋషులు',
      englishTitle: 'Saints & Sages',
      daysLabel: '15 days',
      summary: 'Quiet lives that changed ages',
    ),
  ];

  static const List<StoryPackOption> featuredPacks = [
    StoryPackOption(
      id: 'mahabharata',
      emoji: '🏹',
      nativeTitle: 'మహాభారతం',
      englishTitle: 'Mahabharata',
      daysLabel: '100 days',
      summary: 'Dharma, choices, and courage',
    ),
    StoryPackOption(
      id: 'ramayana',
      emoji: '🛕',
      nativeTitle: 'రామాయణం',
      englishTitle: 'Ramayanam',
      daysLabel: '60 days',
      summary: 'Maryada, love, and the noble path',
    ),
    StoryPackOption(
      id: 'shiv_puran',
      emoji: '🔱',
      nativeTitle: 'శివ పురాణం',
      englishTitle: 'Shiv Puranam',
      daysLabel: '40 days',
      summary: 'Stillness, strength, and devotion',
    ),
    StoryPackOption(
      id: 'bhagavad_gita',
      emoji: '📖',
      nativeTitle: 'భగవద్గీత',
      englishTitle: 'Bhagavad Gita',
      daysLabel: '18 days',
      summary: 'Action, clarity, and surrender',
    ),
    StoryPackOption(
      id: 'hanuman',
      emoji: '🪵',
      nativeTitle: 'హనుమాన్',
      englishTitle: 'Hanuman',
      daysLabel: '21 days',
      summary: 'Service, strength, and fearless faith',
    ),
  ];

  static const StoryPackOption moreTile = StoryPackOption(
    id: 'more',
    emoji: '➕',
    nativeTitle: 'మరిన్ని',
    englishTitle: 'More',
    daysLabel: 'All stories',
    summary: 'Browse everything we offer',
  );

  static Map<String, String> _six({
    required String te,
    required String hi,
    required String ta,
    required String kn,
    required String ml,
    required String en,
  }) {
    return {'te': te, 'hi': hi, 'ta': ta, 'kn': kn, 'ml': ml, 'en': en};
  }

  static final List<KathaCard> cards = [
    KathaCard(
      id: 'story_mahabharata_1',
      section: 'trending',
      category: 'mahabharata',
      mood: 'bold',
      quote: _six(
        te: 'ధర్మం నిలిచిన చోట\nవిజయం కూడా నిలుస్తుంది',
        hi: 'जहाँ धर्म खड़ा हो\nवहीं विजय भी खड़ी होती है',
        ta: 'தர்மம் நிற்கும் இடத்தில்\nவெற்றியும் நிற்கிறது',
        kn: 'ಧರ್ಮ ನಿಲ್ಲುವ ಜಾಗದಲ್ಲಿ\nವಿಜಯವೂ ನಿಲ್ಲುತ್ತದೆ',
        ml: 'ധർമ്മം നിൽക്കുന്നിടത്ത്\nവിജയവും നിൽക്കും',
        en: 'Where dharma stands,\nvictory also stands',
      ),
      author: _six(
        te: '— మహాభారత బోధ',
        hi: '— महाभारत की सीख',
        ta: '— மகாபாரதப் பாடம்',
        kn: '— ಮಹಾಭಾರತದ ಪಾಠ',
        ml: '— മഹാഭാരത പാഠം',
        en: '— a Mahabharata lesson',
      ),
    ),
    KathaCard(
      id: 'story_ramayana_1',
      section: 'trending',
      category: 'ramayana',
      mood: 'warm',
      quote: _six(
        te: 'నైతికమైన మార్గం\nఇతరులకు దీపమవుతుంది',
        hi: 'मर्यादा का मार्ग\nदूसरों के लिए दीपक बनता है',
        ta: 'மரியாதையின் பாதை\nமற்றவர்களுக்கு விளக்காகும்',
        kn: 'ಮರ್ಯಾದೆಯ ದಾರಿ\nಇತರರಿಗೆ ದೀಪವಾಗುತ್ತದೆ',
        ml: 'മര്യാദയുടെ വഴി\nമറ്റുള്ളവർക്ക് ദീപമാകും',
        en: 'A noble path\nbecomes a lamp for others',
      ),
      author: _six(
        te: '— రామాయణ సారం',
        hi: '— रामायण का सार',
        ta: '— இராமாயணத்தின் சாரம்',
        kn: '— ರಾಮಾಯಣದ ಸಾರ',
        ml: '— രാമായണത്തിന്റെ സാരം',
        en: '— the heart of Ramayanam',
      ),
    ),
    KathaCard(
      id: 'story_shiv_puran_1',
      section: 'trending',
      category: 'shiv_puran',
      mood: 'calm',
      quote: _six(
        te: 'నిశ్శబ్ద భక్తి\nమనసుకు అపార బలమివ్వుతుంది',
        hi: 'मौन भक्ति\nमन को अपार शक्ति देती है',
        ta: 'அமைதியான பக்தி\nமனத்திற்கு அளவில்லா வலிமை தருகிறது',
        kn: 'ಮೌನ ಭಕ್ತಿ\nಮನಸ್ಸಿಗೆ ಅಪಾರ ಬಲ ನೀಡುತ್ತದೆ',
        ml: 'നിശ്ശബ്ദ ഭക്തി\nമനസ്സിന് അപാര ബലം നൽകുന്നു',
        en: 'Silent devotion\ngives the mind immense strength',
      ),
      author: _six(
        te: '— శివ పురాణ బోధ',
        hi: '— शिव पुराण की सीख',
        ta: '— சிவ புராணப் பாடம்',
        kn: '— ಶಿವ ಪುರಾಣದ ಪಾಠ',
        ml: '— ശിവ പുരാണ പാഠം',
        en: '— a Shiv Puranam lesson',
      ),
    ),
    KathaCard(
      id: 'story_bhagavad_gita_1',
      section: 'trending',
      category: 'bhagavad_gita',
      mood: 'devotional',
      quote: _six(
        te: 'కర్తవ్యాన్ని చేయి\nఫలితాన్ని దేవుడికి వదిలి పెట్టు',
        hi: 'कर्तव्य करो\nफल को ईश्वर पर छोड़ दो',
        ta: 'கடமையை செய்\nபலனை இறைவனிடம் விடு',
        kn: 'ಕರ್ತವ್ಯವನ್ನು ಮಾಡು\nಫಲವನ್ನು ದೇವರಿಗೆ ಬಿಡು',
        ml: 'കർമ്മം ചെയ്യുക\nഫലം ദൈവത്തിന് വിടുക',
        en: 'Do your duty,\nand leave the result to the Divine',
      ),
      author: _six(
        te: '— గీతా బోధ',
        hi: '— गीता की सीख',
        ta: '— கீதைப் பாடம்',
        kn: '— ಗೀತೆಯ ಪಾಠ',
        ml: '— ഗീതാ പാഠം',
        en: '— a Gita lesson',
      ),
    ),
    KathaCard(
      id: 'story_hanuman_1',
      section: 'trending',
      category: 'hanuman',
      mood: 'bold',
      quote: _six(
        te: 'ప్రేమను గుర్తుచేసే సేవ\nబలంగా మారుతుంది',
        hi: 'प्रेम को याद रखने वाली सेवा\nशक्ति बन जाती है',
        ta: 'அன்பை நினைக்கும் சேவை\nவலிமையாகிறது',
        kn: 'ಪ್ರೀತಿಯನ್ನು ನೆನಪಿಸುವ ಸೇವೆ\nಶಕ್ತಿಯಾಗುತ್ತದೆ',
        ml: 'സ്നേഹത്തെ ഓർക്കുന്ന സേവനം\nശക്തിയാകുന്നു',
        en: 'Service that remembers love\nbecomes strength',
      ),
      author: _six(
        te: '— హనుమాన్ కథ',
        hi: '— हनुमान कथा',
        ta: '— அனுமன் கதை',
        kn: '— ಹನುಮಾನ್ ಕಥೆ',
        ml: '— ഹനുമാൻ കഥ',
        en: '— a Hanuman story',
      ),
    ),
    KathaCard(
      id: 'story_krishna_leela_1',
      section: 'trending',
      category: 'krishna_leela',
      mood: 'warm',
      quote: _six(
        te: 'ఆనందం కూడా\nజ్ఞానాన్ని మోసుకెళ్లగలదు',
        hi: 'आनंद भी\nज्ञान को साथ ले चलता है',
        ta: 'ஆனந்தமும்\nஞானத்தைத் தாங்கி செல்லும்',
        kn: 'ಆನಂದವೂ\nಜ್ಞಾನವನ್ನು ಹೊತ್ತುಕೊಂಡು ಹೋಗುತ್ತದೆ',
        ml: 'ആനന്ദത്തിനും\nജ്ഞാനത്തെ കൊണ്ടുപോകാം',
        en: 'Joy can carry wisdom\nwhen the heart is pure',
      ),
      author: _six(
        te: '— కృష్ణలీల బోధ',
        hi: '— कृष्ण लीला की सीख',
        ta: '— கிருஷ்ண லீலைப் பாடம்',
        kn: '— ಕೃಷ್ಣ ಲೀಲೆಯ ಪಾಠ',
        ml: '— കൃഷ്ണലീല പാഠം',
        en: '— a Krishna Leela lesson',
      ),
    ),
    KathaCard(
      id: 'story_devi_mahatmya_1',
      section: 'festival',
      category: 'devi_mahatmya',
      mood: 'festive',
      isFestival: true,
      festivalTag: 'Navaratri',
      quote: _six(
        te: 'భయం ముగిసిన చోట\nకరుణ వెలుగుతుంది',
        hi: 'जहाँ भय समाप्त होता है\nवहाँ करुणा चमकती है',
        ta: 'பயம் முடிந்த இடத்தில்\nகருணை ஒளிர்கிறது',
        kn: 'ಭಯ ಮುಗಿಯುವ ಜಾಗದಲ್ಲಿ\nಕರುಣೆ ಬೆಳಗುತ್ತದೆ',
        ml: 'ഭയം അവസാനിക്കുന്നിടത്ത്\nകരുണ പ്രകാശിക്കുന്നു',
        en: 'Where fear ends,\ncompassion begins to shine',
      ),
      author: _six(
        te: '— దేవీ మహాత్మ్యం',
        hi: '— देवी महात्म्य',
        ta: '— தேவி மாஹாத்மியம்',
        kn: '— ದೇವಿ ಮಹಾತ್ಮ್ಯ',
        ml: '— ദേവീ മഹാത്മ്യം',
        en: '— Devi Mahatmya',
      ),
    ),
    KathaCard(
      id: 'story_vedic_wisdom_1',
      section: 'trending',
      category: 'vedic_wisdom',
      mood: 'calm',
      quote: _six(
        te: 'పురాతన వెలుగు\nఇప్పటికీ దారి చూపుతుంది',
        hi: 'पुराना प्रकाश\nआज भी राह दिखाता है',
        ta: 'பழமையான ஒளி\nஇன்றும் வழி காட்டுகிறது',
        kn: 'ಪ್ರಾಚೀನ ಬೆಳಕು\nಇಂದಿಗೂ ದಾರಿ ತೋರಿಸುತ್ತದೆ',
        ml: 'പുരാതന വെളിച്ചം\nഇന്നും വഴി കാണിക്കുന്നു',
        en: 'Ancient light\nstill shows the way',
      ),
      author: _six(
        te: '— వేద జ్ఞానం',
        hi: '— वैदिक ज्ञान',
        ta: '— வேத ஞானம்',
        kn: '— ವೇದ ಜ್ಞಾನ',
        ml: '— വേദ വിജ്ഞാനം',
        en: '— Vedic wisdom',
      ),
    ),
    KathaCard(
      id: 'story_upanishads_1',
      section: 'trending',
      category: 'upanishads',
      mood: 'devotional',
      quote: _six(
        te: 'ఆత్మను తెలుసుకుంటే\nప్రపంచం సుస్పష్టం అవుతుంది',
        hi: 'जब आत्मा को जानो\nतो संसार स्पष्ट हो जाता है',
        ta: 'ஆத்மாவை அறிந்தால்\nஉலகம் தெளிவாகிறது',
        kn: 'ಆತ್ಮವನ್ನು ತಿಳಿದರೆ\nಜಗತ್ತು ಸ್ಪಷ್ಟವಾಗುತ್ತದೆ',
        ml: 'ആത്മാവിനെ അറിഞ്ഞാൽ\nലോകം വ്യക്തമാകും',
        en: 'Know the self,\nand the world becomes clear',
      ),
      author: _six(
        te: '— ఉపనిషత్తుల బోధ',
        hi: '— उपनिषदों की सीख',
        ta: '— உபநிஷதங்களின் பாடம்',
        kn: '— ಉಪನಿಷತ್ತುಗಳ ಪಾಠ',
        ml: '— ഉപനിഷത്തുകളുടെ പാഠം',
        en: '— an Upanishadic teaching',
      ),
    ),
    KathaCard(
      id: 'story_puranas_1',
      section: 'trending',
      category: 'puranas',
      mood: 'warm',
      quote: _six(
        te: 'కథలు గుర్తును ఉంచుతాయి\nతరాలు దాటినా',
        hi: 'कहानियाँ यादों को जिंदा रखती हैं\nपीढ़ियों तक',
        ta: 'கதைகள் நினைவுகளை உயிர்ப்பாக வைத்திருக்கும்\nதலைமுறைகள் கடந்தும்',
        kn: 'ಕಥೆಗಳು ನೆನಪುಗಳನ್ನು ಜೀವಂತವಾಗಿರಿಸುತ್ತವೆ\nತಲೆಮಾರುಗಳವರೆಗೆ',
        ml: 'കഥകൾ ഓർമ്മകളെ ജീവിപ്പിക്കുന്നു\nതലമുറകൾ കടന്നും',
        en: 'Stories keep memory alive\nacross generations',
      ),
      author: _six(
        te: '— పురాణ బోధ',
        hi: '— पुराणों की सीख',
        ta: '— புராணப் பாடம்',
        kn: '— ಪುರಾಣದ ಪಾಠ',
        ml: '— പുരാണ പാഠം',
        en: '— a Purana lesson',
      ),
    ),
    KathaCard(
      id: 'story_ancient_history_1',
      section: 'trending',
      category: 'ancient_history',
      mood: 'bold',
      quote: _six(
        te: 'రాజులు గుర్తుండేది\nవారు రక్షించిన ధర్మమే',
        hi: 'राजा वही याद रखे जाते हैं\nजिन्होंने धर्म की रक्षा की',
        ta: 'அரசர்கள் நினைவில் நிற்பது\nஅவர்கள் காத்த தர்மமே',
        kn: 'ರಾಜರು ನೆನಪಾಗುವುದು\nಅವರು ರಕ್ಷಿಸಿದ ಧರ್ಮದಿಂದಲೇ',
        ml: 'രാജാക്കന്മാരെ ഓർക്കുന്നത്\nഅവർ കാത്ത ധർമ്മം കൊണ്ടാണ്',
        en: 'Kings are remembered\nfor the dharma they protected',
      ),
      author: _six(
        te: '— ప్రాచీన చరిత్ర',
        hi: '— प्राचीन इतिहास',
        ta: '— பண்டைய வரலாறு',
        kn: '— ಪ್ರಾಚೀನ ಇತಿಹಾಸ',
        ml: '— പ്രാചീന ചരിത്രം',
        en: '— ancient history',
      ),
    ),
    KathaCard(
      id: 'story_saints_sages_1',
      section: 'trending',
      category: 'saints_sages',
      mood: 'calm',
      quote: _six(
        te: 'నిశ్శబ్దమైన నిజమైన జీవితం\nయుగాన్ని మార్చగలదు',
        hi: 'एक शांत और सच्चा जीवन\nएक पूरे युग को बदल सकता है',
        ta: 'அமைதியான உண்மை வாழ்க்கை\nஒரு யுகத்தையே மாற்றும்',
        kn: 'ಶಾಂತವಾದ ಸತ್ಯ ಜೀವನ\nಒಂದು ಯುಗವನ್ನೇ ಬದಲಾಯಿಸಬಹುದು',
        ml: 'ശാന്തമായ സത്യജീവിതം\nഒരു യുഗത്തെ മാറ്റാം',
        en: 'A quiet life of truth\ncan change an age',
      ),
      author: _six(
        te: '— సంతులు & ఋషులు',
        hi: '— संत और ऋषि',
        ta: '— சான்றோர் & முனிவர்கள்',
        kn: '— ಸಂತರು & ಋಷಿಗಳು',
        ml: '— സന്തന്മാർ & മുനിമാർ',
        en: '— saints and sages',
      ),
    ),
  ];

  static bool isSupportedCategory(String category) =>
      packs.any((p) => p.id == category);

  static StoryPackOption? packById(String id) {
    for (final pack in packs) {
      if (pack.id == id) return pack;
    }
    return id == moreTile.id ? moreTile : null;
  }

  static List<KathaCard> cardsFor(String category) {
    return cards.where((c) => c.category == category).toList(growable: false);
  }

  static List<KathaCard> cardsForAny(Iterable<String> categories) {
    final set = categories.toSet();
    return cards.where((c) => set.contains(c.category)).toList(growable: false);
  }
}
