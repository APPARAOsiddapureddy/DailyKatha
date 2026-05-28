// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'डेली कथा';

  @override
  String get navHome => 'होम';

  @override
  String get navExplore => 'खोजें';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get brandTagline => 'आशीर्वाद बाँटिए';

  @override
  String get scrollHint => 'स्क्रॉल करें';

  @override
  String get sectionForYou => 'आपके लिए';

  @override
  String get sectionMorning => 'सुबह की शुरुआत';

  @override
  String get sectionTrending => 'ट्रेंडिंग';

  @override
  String get sectionFestival => 'त्योहार विशेष';

  @override
  String get sectionEvening => 'शाम';

  @override
  String get sectionEntertainment => 'मनोरंजन';

  @override
  String get onboardingSelectLanguage => 'भाषा चुनें';

  @override
  String get onboardingSelectInterests => 'अपनी रुचियाँ';

  @override
  String get onboardingSelectReligion => 'धर्म (वैकल्पिक)';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingDone => 'Get Started';

  @override
  String get onboardingStep1 => 'Step 1 of 3';

  @override
  String get onboardingStep2 => 'Step 2 of 3';

  @override
  String get onboardingStep3 => 'Step 3 of 3';

  @override
  String get onboardingLanguageQuestion => 'आपकी भाषा क्या है?';

  @override
  String get onboardingLanguageSubtitle =>
      'हम सामग्री उसी भाषा में दिखाएँगे जिसमें आप रोज़ बात करते हैं।';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingReligionTitle => 'आपका आध्यात्मिक मार्ग?';

  @override
  String get onboardingReligionSubtitle =>
      'हम सामग्री को आपके विश्वास के अनुरूप ढालेंगे। यह वैकल्पिक है।';

  @override
  String get onboardingInterestsTitle => 'आप क्या शेयर करना पसंद करते हैं?';

  @override
  String get onboardingInterestsSubtitle =>
      'अधिकतम 3 चुनें — हम आपके होम को इन्हीं से भर देंगे।';

  @override
  String onboardingInterestCount(int count) {
    return '$count/3 चुने';
  }

  @override
  String get onboardingFinishCta => 'Finish · Start reading ✦';

  @override
  String homeGreetingNightEarly(Object name) {
    return 'शुभ रात्रि, $name.';
  }

  @override
  String homeGreetingMorning(Object name) {
    return 'सुप्रभात, $name.';
  }

  @override
  String homeGreetingAfternoon(Object name) {
    return 'शुभ दोपहर, $name.';
  }

  @override
  String homeGreetingEvening(Object name) {
    return 'शुभ संध्या, $name.';
  }

  @override
  String homeGreetingNight(Object name) {
    return 'शुभ रात्रि, $name.';
  }

  @override
  String get homeGreetingSubline => 'आशीर्वाद के साथ दिन शुरू करें';

  @override
  String get homeBrowseGenre => 'शैली से देखें';

  @override
  String homeQuotesCount(int count) {
    return '$count उद्धरण';
  }

  @override
  String get homeSectionStartTitle => 'सुबह की शुरुआत आशीर्वाद से';

  @override
  String get homeSectionFestivalTitle => 'आज के उगादि विशेष';

  @override
  String get homeSectionInterestsTitle => 'जो आप पसंद करते हैं';

  @override
  String get homeSectionTrendingTitle => 'सब क्या शेयर कर रहे हैं';

  @override
  String get homeSectionCinemaTitle => 'तेलुगु सिनेमा से';

  @override
  String get festivalBannerKicker => 'आज का त्योहार';

  @override
  String get festivalBannerTitle => 'उगादि की हार्दिक शुभकामनाएँ';

  @override
  String get festivalBannerSubtitle => 'शेयर करने के लिए 12 नए संदेश';

  @override
  String get festivalBannerCta => 'पैक खोलें →';

  @override
  String get homeViewAll => 'सभी देखें →';

  @override
  String get notificationsTitle => 'सूचनाएँ';

  @override
  String get exploreTabDiscover => 'डिस्कवर';

  @override
  String get exploreTabBrowse => 'ब्राउज़';

  @override
  String get exploreHeadline => 'खोजें';

  @override
  String get exploreSubtitle => 'आज क्या शेयर करें, खोजें';

  @override
  String get exploreByInterest => 'By interest';

  @override
  String get exploreByInterestSub => 'Tap to browse';

  @override
  String get exploreCuratedPacks => 'Curated packs';

  @override
  String get exploreCuratedPacksSub => 'Hand-picked sets you can save';

  @override
  String get exploreFestivalLive => 'Festival Pack · Live';

  @override
  String get exploreFestivalTitle => 'Festival greetings';

  @override
  String get exploreFestivalBody => '12 cards · refreshed daily until 14 May';

  @override
  String get explorePack1Title => 'Monday strength';

  @override
  String get explorePack1Sub => '8 motivation cards · for the week ahead';

  @override
  String get explorePack2Title => 'Mother\'s Day';

  @override
  String get explorePack2Sub => '10 cards · for the woman who started it all';

  @override
  String get explorePack3Title => 'Quiet evenings';

  @override
  String get explorePack3Sub => '6 cards · slow down with these';

  @override
  String get exploreSearchHint => 'उद्धरण खोजें…';

  @override
  String get exploreSearchNoMatch =>
      'No match — try morning, birthday, love, festival…';

  @override
  String get exploreJumpIn => 'शुरू करें';

  @override
  String get exploreWhatToShare => 'क्या शेयर करेंगे?';

  @override
  String get exploreTrendingLine => 'ट्रेंडिंग';

  @override
  String get exploreWeekHit => 'इस हफ़्ते की हिट';

  @override
  String get exploreSeeAll => 'See all →';

  @override
  String get explorePopularSearches => 'लोकप्रिय खोजें';

  @override
  String get exploreYouMightLike => 'आपको ये पसंद आ सकते हैं';

  @override
  String get exploreUpcomingLine => 'आगामी';

  @override
  String get exploreFestivalCalendar => 'त्योहार कैलेंडर';

  @override
  String get exploreCategoriesLine => 'श्रेणियाँ';

  @override
  String get exploreBrowseAll => 'सभी ब्राउज़ करें';

  @override
  String get exploreAll => 'सभी';

  @override
  String get exploreEmpty => 'कुछ नहीं मिला';

  @override
  String get profileLiked => 'पसंद की गई';

  @override
  String get profileSaved => 'सहेजी गई';

  @override
  String get profileStatEdits => 'Edits';

  @override
  String get profileShared => 'शेयर की गई';

  @override
  String get profileSettings => 'सेटिंग्स';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get profileInterests => 'रुचियाँ';

  @override
  String get profileDownloads => 'डाउनलोड';

  @override
  String get profileNotificationsOn => 'सूचनाएँ चालू';

  @override
  String get profileHelp => 'सहायता';

  @override
  String get namePromptTitle => 'आपको किस नाम से बुलाएं?';

  @override
  String get namePromptBody =>
      'हम इस नाम का उपयोग होम पर और प्रोफ़ाइल पर दिखाएँगे।';

  @override
  String get namePromptHint => 'आपका नाम';

  @override
  String get namePromptSave => 'सहेजें';

  @override
  String get namePromptSkip => 'अभी नहीं';

  @override
  String get profileYourName => 'आपका नाम';

  @override
  String get profileYourNameSub => 'होम पर अभिवादन में दिखेगा';

  @override
  String get profileEditNameTitle => 'नाम संपादित करें';

  @override
  String get profileEditNameCancel => 'रद्द करें';

  @override
  String get profileSignOut => 'साइन आउट';

  @override
  String get profileFooter => 'डेली कथा · प्यार से बनाया गया';

  @override
  String get profileStreakSub => 'You\'ve sent a card every day this week.';

  @override
  String get profileSectionLibrary => 'Library';

  @override
  String get profileSectionPreferences => 'Preferences';

  @override
  String get profileSectionAbout => 'About';

  @override
  String get profilePathTradition => 'Path / tradition';

  @override
  String get profileRowSavedCards => 'Saved cards';

  @override
  String profileRowSavedSub(int count) {
    return '$count cards';
  }

  @override
  String get profileRowMyEdits => 'My edits';

  @override
  String profileRowMyEditsSub(int count) {
    return '$count cards with your photos';
  }

  @override
  String get profileRowMyShares => 'My shares';

  @override
  String profileRowMySharesSub(int count) {
    return '$count cards shared';
  }

  @override
  String get profileDialogNoSavedTitle => 'No saved cards yet';

  @override
  String get profileDialogNoSavedBody =>
      'Save a card from Home or the feed to build your gallery.';

  @override
  String get profileDialogNoEditsTitle => 'No edits yet';

  @override
  String get profileDialogNoEditsBody =>
      'Create a card with your photos to see it here.';

  @override
  String get profileDialogNoSharesTitle => 'Nothing shared yet';

  @override
  String get profileDialogNoSharesBody =>
      'Share a card to WhatsApp Status from the feed and it will appear here.';

  @override
  String get profileRowDailyReminder => 'Daily reminder';

  @override
  String get profileRowReminderSub => '7:00 AM';

  @override
  String get profileRowSettingsOnly => 'Settings';

  @override
  String get feedScreenLabel => 'Feed';

  @override
  String feedIndexOf(int n, int total) {
    return '$n of $total';
  }

  @override
  String get shareToWhatsAppStatus => 'Share to WhatsApp Status';

  @override
  String get profileEmptySharedTitle => 'आपके शेयर यहाँ दिखेंगे';

  @override
  String get profileEmptySharedSubtitle =>
      'फ़ीड से कार्ड शेयर करें तो यहाँ दिखेगा।';

  @override
  String profileInterestCountTrailing(int count) {
    return '$count चुने';
  }

  @override
  String get profileLogout => 'लॉगआउट';

  @override
  String get languageUpdated => 'भाषा बदल गई';

  @override
  String get errorFeedLoad => 'फ़ीड लोड नहीं हो सकी';

  @override
  String get errorGeneric => 'कुछ गलत हो गया';

  @override
  String get noCards => 'कोई कार्ड नहीं';

  @override
  String get preparingCard => 'आपका कार्ड तैयार हो रहा है…';

  @override
  String get snackSaveTodo => 'गैलरी में सेव जल्द आ रहा है।';

  @override
  String get snackEditTodo => 'कार्ड संपादन जल्द आ रहा है।';

  @override
  String get loginWelcome => 'आपका स्वागत है।';

  @override
  String get loginSubtitle =>
      'अपना नंबर दें। रोज़ाना शुभकामनाएँ, त्योहार के संदेश — सीधे आपके फ़ोन पर।';

  @override
  String get loginMobileLabel => 'मोबाइल नंबर';

  @override
  String get loginSendOtp => 'Continue with Truecaller';

  @override
  String get loginTerms => 'By continuing you agree to use Truecaller for sign-in.';

  @override
  String get otpEnterCode => 'Continue';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone';
  }

  @override
  String get otpVerify => 'Continue';

  @override
  String get otpResend => 'Try again';

  @override
  String get otpSmsHintLive => 'Truecaller sign-in is used for this build.';

  @override
  String get otpDevModeHint => 'Development build: continue with Truecaller.';

  @override
  String get splashTagline => 'आशीर्वाद बाँटिए';

  @override
  String get homeHeroKicker => 'Your card today';

  @override
  String get homeTodayPickHint =>
      'Tap a side card to bring it to the center; tap the center card to open it.';

  @override
  String get homeShareToStatus => 'Share to Status';

  @override
  String homeRailNewToday(int count) {
    return '$count new today';
  }

  @override
  String get sectionPreviewSubline =>
      'A clean line for today, then more behind a tap.';

  @override
  String sectionOpenAll(int count) {
    return 'Open all $count cards';
  }

  @override
  String get sectionAlsoToday => 'Also today';

  @override
  String get dateToday => 'आज';

  @override
  String get footerDailyKatha => 'डेली कथा';
}
