// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'డైలీ కథ';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navExplore => 'అన్వేషించు';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get brandTagline => 'శుభాలు పంచుకోండి';

  @override
  String get scrollHint => 'స్క్రోల్ చేయండి';

  @override
  String get sectionForYou => 'మీ కోసం';

  @override
  String get sectionMorning => 'శుభోదయం';

  @override
  String get sectionTrending => 'ట్రెండింగ్';

  @override
  String get sectionFestival => 'పండుగ విశేషాలు';

  @override
  String get sectionEvening => 'సాయంత్రం';

  @override
  String get sectionEntertainment => 'వినోదం';

  @override
  String get onboardingSelectLanguage => 'భాష ఎంచుకోండి';

  @override
  String get onboardingSelectInterests => 'మీ ఆసక్తులు';

  @override
  String get onboardingSelectReligion => 'మతం (ఐచ్ఛికం)';

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
  String get onboardingLanguageQuestion => 'మీ భాష ఏది?';

  @override
  String get onboardingLanguageSubtitle =>
      'మీ రోజువారీ మాట్లాడే భాషలో కంటెంట్ చూపిస్తాం.';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingReligionTitle => 'మీ ఆధ్యాత్మిక మార్గం?';

  @override
  String get onboardingReligionSubtitle =>
      'మీ విశ్వాసానికి గౌరవం ఇచ్చేలా కంటెంట్ సరిచేస్తాం. ఇది ఐచ్ఛికం.';

  @override
  String get onboardingInterestsTitle => 'మీకు ఏం షేర్ చేయడం ఇష్టం?';

  @override
  String get onboardingInterestsSubtitle =>
      'గరిష్ఠంగా 3 ఎంచుకోండి — హోమ్‌ను వీటితో నింపుతాం.';

  @override
  String onboardingInterestCount(int count) {
    return '$count/3 ఎంచుకున్నారు';
  }

  @override
  String get onboardingFinishCta => 'Finish · Start reading ✦';

  @override
  String homeGreetingNightEarly(Object name) {
    return 'శుభ రాత్రి, $name.';
  }

  @override
  String homeGreetingMorning(Object name) {
    return 'శుభోదయం, $name.';
  }

  @override
  String homeGreetingAfternoon(Object name) {
    return 'శుభ మధ్యాహ్నం, $name.';
  }

  @override
  String homeGreetingEvening(Object name) {
    return 'శుభ సాయంత్రం, $name.';
  }

  @override
  String homeGreetingNight(Object name) {
    return 'శుభ రాత్రి, $name.';
  }

  @override
  String get homeGreetingSubline => 'శుభాలతో రోజు మొదలుపెట్టండి';

  @override
  String get homeBrowseGenre => 'శైలి పరంగా చూడండి';

  @override
  String homeQuotesCount(int count) {
    return '$count వ్యాఖ్యలు';
  }

  @override
  String get homeSectionStartTitle => 'ఈరోజు శుభోదయం';

  @override
  String get homeSectionFestivalTitle => 'ఉగాది ప్రత్యేకం';

  @override
  String get homeSectionInterestsTitle => 'మీ ఇష్టాలు';

  @override
  String get homeSectionTrendingTitle => 'ఇప్పుడు ట్రెండింగ్';

  @override
  String get homeSectionCinemaTitle => 'తెలుగు సినిమా';

  @override
  String get festivalBannerKicker => 'ఈ రోజు పండుగ';

  @override
  String get festivalBannerTitle => 'ఉగాది శుభాకాంక్షలు';

  @override
  String get festivalBannerSubtitle => 'షేర్ చేయడానికి 12 కొత్త శుభాకాంక్షలు';

  @override
  String get festivalBannerCta => 'ప్యాక్ తెరవండి →';

  @override
  String get homeViewAll => 'అన్నీ చూడండి →';

  @override
  String get notificationsTitle => 'నోటిఫికేషన్‌లు';

  @override
  String get exploreTabDiscover => 'డిస్కవర్';

  @override
  String get exploreTabBrowse => 'బ్రౌజ్';

  @override
  String get exploreHeadline => 'వెతకండి';

  @override
  String get exploreSubtitle => 'ఈ రోజు ఏం షేర్ చేయాలో అన్వేషించండి';

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
  String get exploreFestivalTitle => 'Ugadi greetings';

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
  String get exploreSearchHint => 'వ్యాఖ్యలు వెతకండి…';

  @override
  String get exploreJumpIn => 'వెంటనే';

  @override
  String get exploreWhatToShare => 'ఏం షేర్ చేస్తారు?';

  @override
  String get exploreTrendingLine => 'ట్రెండింగ్';

  @override
  String get exploreWeekHit => 'ఈ వారం హిట్';

  @override
  String get exploreSeeAll => 'See all →';

  @override
  String get explorePopularSearches => 'ప్రజాదరణ';

  @override
  String get exploreYouMightLike => 'మీకు ఇవి నచ్చవచ్చు';

  @override
  String get exploreUpcomingLine => 'రాబోయే';

  @override
  String get exploreFestivalCalendar => 'పండుగల క్యాలెండర్';

  @override
  String get exploreCategoriesLine => 'వర్గాలు';

  @override
  String get exploreBrowseAll => 'అన్నిటినీ బ్రౌజ్ చేయండి';

  @override
  String get exploreAll => 'అన్నీ';

  @override
  String get exploreEmpty => 'ఏమీ దొరకలేదు';

  @override
  String get profileLiked => 'లైక్ చేసినవి';

  @override
  String get profileSaved => 'సేవ్ చేసినవి';

  @override
  String get profileStatEdits => 'Edits';

  @override
  String get profileShared => 'షేర్ చేసినవి';

  @override
  String get profileSettings => 'సెట్టింగులు';

  @override
  String get profileLanguage => 'భాష';

  @override
  String get profileInterests => 'నా ఆసక్తులు';

  @override
  String get profileDownloads => 'డౌన్‌లోడ్‌లు';

  @override
  String get profileNotificationsOn => 'నోటిఫికేషన్‌లు ఆన్';

  @override
  String get profileHelp => 'సహాయం';

  @override
  String get profileSignOut => 'సైన్ అవుట్';

  @override
  String get profileFooter => 'డైలీ కథ · ప్రేమతో తయారు';

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
  String get profileEmptySharedTitle => 'మీరు షేర్ చేసినవి ఇక్కడ కనిపిస్తాయి';

  @override
  String get profileEmptySharedSubtitle =>
      'ఫీడ్ నుండి కార్డ్ షేర్ చేస్తే ఇక్కడ కనిపిస్తుంది.';

  @override
  String profileInterestCountTrailing(int count) {
    return '$count ఎంచుకున్నారు';
  }

  @override
  String get profileLogout => 'లాగ్ అవుట్';

  @override
  String get languageUpdated => 'భాష మారింది';

  @override
  String get errorFeedLoad => 'ఫీడ్ లోడ్ కాలేదు';

  @override
  String get errorGeneric => 'ఏదో తప్పు జరిగింది';

  @override
  String get noCards => 'కార్డులు లేవు';

  @override
  String get preparingCard => 'మీ కార్డ్ సిద్ధం చేస్తున్నాం…';

  @override
  String get snackSaveTodo => 'గ్యాలరీకి సేవ్ త్వరలో వస్తుంది.';

  @override
  String get snackEditTodo => 'కార్డ్ సవరణ త్వరలో వస్తుంది.';

  @override
  String get loginWelcome => 'స్వాగతం.';

  @override
  String get loginSubtitle =>
      'మీ నంబర్ ఇవ్వండి. రోజువారీ శుభాకాంక్షలు, పండుగ సందేశాలు — మీ ఫోన్‌కే పంపుతాం.';

  @override
  String get loginMobileLabel => 'మొబైల్ నంబర్';

  @override
  String get loginSendOtp => 'OTP పంపు';

  @override
  String get loginTerms =>
      'కొనసాగితే SMS OTP మరియు సేవా అప్‌డేట్‌లు అందవచ్చు. క్యారియర్ ఛార్జీలు వర్తించవచ్చు.';

  @override
  String get otpEnterCode => 'కోడ్ ఇవ్వండి';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone';
  }

  @override
  String get otpVerify => 'Verify';

  @override
  String get otpResend => 'Resend';

  @override
  String get otpSmsHintLive =>
      'We sent a 6-digit code by SMS to this number. Test lines 123456xxxx may use a fixed code.';

  @override
  String get otpDevModeHint => 'Dev mode: enter any 6 digits to continue.';

  @override
  String get splashTagline => 'శుభాలు పంచుకోండి';

  @override
  String get homeHeroKicker => 'Your card today';

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
  String get dateToday => 'ఈ రోజు';

  @override
  String get footerDailyKatha => 'డైలీ కథ';
}
