// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'ഡെയ്‌ലി കഥ';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navExplore => 'അന്വേഷിക്കുക';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String get brandTagline => 'അനുഗ്രഹം പകരുക';

  @override
  String get scrollHint => 'സ്ക്രോൾ ചെയ്യുക';

  @override
  String get sectionForYou => 'നിങ്ങൾക്കായി';

  @override
  String get sectionMorning => 'പ്രഭാതം';

  @override
  String get sectionTrending => 'ട്രെൻഡിംഗ്';

  @override
  String get sectionFestival => 'ഉത്സവ പ്രത്യേകത';

  @override
  String get sectionEvening => 'സന്ധ്യ';

  @override
  String get sectionEntertainment => 'വിനോദം';

  @override
  String get onboardingSelectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get onboardingSelectInterests => 'നിങ്ങളുടെ താൽപ്പര്യങ്ങൾ';

  @override
  String get onboardingSelectReligion => 'മതം (ഐച്ഛികം)';

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
  String get onboardingLanguageQuestion => 'നിങ്ങളുടെ ഭാഷ ഏതാണ്?';

  @override
  String get onboardingLanguageSubtitle =>
      'നിങ്ങൾ ദിവസവും സംസാരിക്കുന്ന ഭാഷയിൽ ഉള്ളടക്കം കാണിക്കും.';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingReligionTitle => 'നിങ്ങളുടെ ആത്മീയ പാത?';

  @override
  String get onboardingReligionSubtitle =>
      'നിങ്ങളുടെ വിശ്വാസത്തെ ബഹുമാനിക്കാൻ ഉള്ളടക്കം ക്രമീകരിക്കും. ഇത് ഐച്ഛികമാണ്.';

  @override
  String get onboardingInterestsTitle =>
      'നിങ്ങൾ എന്ത് പങ്കിടാൻ ഇഷ്ടപ്പെടുന്നു?';

  @override
  String get onboardingInterestsSubtitle =>
      'പരമാവധി 3 തിരഞ്ഞെടുക്കുക — ഹോം ഇവയിൽ നിറയും.';

  @override
  String onboardingInterestCount(int count) {
    return '$count/3 തിരഞ്ഞെടുത്തു';
  }

  @override
  String get onboardingFinishCta => 'Finish · Start reading ✦';

  @override
  String homeGreetingNightEarly(Object name) {
    return 'ശുഭ രാത്രി, $name.';
  }

  @override
  String homeGreetingMorning(Object name) {
    return 'സുപ്രഭാതം, $name.';
  }

  @override
  String homeGreetingAfternoon(Object name) {
    return 'ശുഭ ഉച്ച, $name.';
  }

  @override
  String homeGreetingEvening(Object name) {
    return 'ശുഭ സന്ധ്യ, $name.';
  }

  @override
  String homeGreetingNight(Object name) {
    return 'ശുഭ രാത്രി, $name.';
  }

  @override
  String get homeGreetingSubline => 'അനുഗ്രഹത്തോടെ ദിനം തുടങ്ങുക';

  @override
  String get homeBrowseGenre => 'ഗണം അനുസരിച്ച് കാണുക';

  @override
  String homeQuotesCount(int count) {
    return '$count ഉദ്ധരണികൾ';
  }

  @override
  String get homeSectionStartTitle => 'പ്രഭാത ആശീർവാദത്തോടെ തുടങ്ങുക';

  @override
  String get homeSectionFestivalTitle => 'ഇന്നത്തെ ഉഗാദി പ്രത്യേകത';

  @override
  String get homeSectionInterestsTitle => 'നിങ്ങൾ ഇഷ്ടപ്പെടുന്നതിനനുസരിച്ച്';

  @override
  String get homeSectionTrendingTitle => 'എല്ലാവരും പങ്കിടുന്നത്';

  @override
  String get homeSectionCinemaTitle => 'തെലുങ്ങ് സിനിമയിൽ നിന്ന്';

  @override
  String get festivalBannerKicker => 'ഇന്നത്തെ ഉത്സവം';

  @override
  String get festivalBannerTitle => 'ഉഗാദി ആശംസകൾ';

  @override
  String get festivalBannerSubtitle => 'പങ്കിടാൻ 12 പുതിയ ആശംസകൾ തയ്യാർ';

  @override
  String get festivalBannerCta => 'പായ്ക്ക് തുറക്കുക →';

  @override
  String get homeViewAll => 'എല്ലാം കാണുക →';

  @override
  String get notificationsTitle => 'അറിയിപ്പുകൾ';

  @override
  String get exploreTabDiscover => 'ഡിസ്കവർ';

  @override
  String get exploreTabBrowse => 'ബ്രൗസ്';

  @override
  String get exploreHeadline => 'തിരയുക';

  @override
  String get exploreSubtitle => 'ഇന്ന് എന്ത് പങ്കിടണമെന്ന് അന്വേഷിക്കുക';

  @override
  String get exploreSearchHint => 'ഉദ്ധരണി തിരയുക…';

  @override
  String get exploreJumpIn => 'ഉടൻ പ്രവേശിക്കുക';

  @override
  String get exploreWhatToShare => 'എന്താണ് പങ്കിടുന്നത്?';

  @override
  String get exploreTrendingLine => 'ട്രെൻഡിംഗ്';

  @override
  String get exploreWeekHit => 'ഈ ആഴ്ചത്തെ ഹിറ്റ്';

  @override
  String get exploreSeeAll => 'See all →';

  @override
  String get explorePopularSearches => 'ജനപ്രിയ തിരയലുകൾ';

  @override
  String get exploreYouMightLike => 'നിങ്ങൾക്ക് ഇവ ഇഷ്ടപ്പെടാം';

  @override
  String get exploreUpcomingLine => 'വരാനിരിക്കുന്ന';

  @override
  String get exploreFestivalCalendar => 'ഉത്സവ കലണ്ടർ';

  @override
  String get exploreCategoriesLine => 'വിഭാഗങ്ങൾ';

  @override
  String get exploreBrowseAll => 'എല്ലാം ബ്രൗസ് ചെയ്യുക';

  @override
  String get exploreAll => 'എല്ലാം';

  @override
  String get exploreEmpty => 'ഒന്നും കണ്ടെത്തിയില്ല';

  @override
  String get profileLiked => 'ഇഷ്ടപ്പെട്ടവ';

  @override
  String get profileSaved => 'സേവ് ചെയ്തവ';

  @override
  String get profileShared => 'പങ്കിട്ടവ';

  @override
  String get profileSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get profileLanguage => 'ഭാഷ';

  @override
  String get profileInterests => 'താൽപ്പര്യങ്ങൾ';

  @override
  String get profileDownloads => 'ഡൗൺലോഡുകൾ';

  @override
  String get profileNotificationsOn => 'അറിയിപ്പുകൾ ഓൺ';

  @override
  String get profileHelp => 'സഹായം';

  @override
  String get profileSignOut => 'സൈൻ ഔട്ട്';

  @override
  String get profileFooter => 'ഡെയ്‌ലി കഥ · ശ്രദ്ധയോടെ';

  @override
  String get profileEmptySharedTitle => 'നിങ്ങൾ പങ്കിട്ടവ ഇവിടെ കാണും';

  @override
  String get profileEmptySharedSubtitle =>
      'ഫീഡിൽ നിന്ന് കാർഡ് പങ്കിട്ടാൽ ഇവിടെ കാണിക്കും.';

  @override
  String profileInterestCountTrailing(int count) {
    return '$count തിരഞ്ഞെടുത്തു';
  }

  @override
  String get profileLogout => 'ലോഗ്ഔട്ട്';

  @override
  String get languageUpdated => 'ഭാഷ മാറ്റി';

  @override
  String get errorFeedLoad => 'ഫീഡ് ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get errorGeneric => 'എന്തോ തെറ്റ് സംഭവിച്ചു';

  @override
  String get noCards => 'കാർഡുകളില്ല';

  @override
  String get preparingCard => 'നിങ്ങളുടെ കാർഡ് തയ്യാറാക്കുന്നു…';

  @override
  String get snackSaveTodo => 'ഗാലറിയിലേക്ക് സേവ് ഉടൻ വരുന്നു.';

  @override
  String get snackEditTodo => 'കാർഡ് തിരുത്തൽ ഉടൻ വരുന്നു.';

  @override
  String get loginWelcome => 'സ്വാഗതം.';

  @override
  String get loginSubtitle =>
      'നിങ്ങളുടെ നമ്പർ നൽകുക. ദൈനംദിന ആശംസകൾ, ഉത്സവ സന്ദേശങ്ങൾ — നിങ്ങളുടെ ഫോണിലേക്ക്.';

  @override
  String get loginMobileLabel => 'മൊബൈൽ നമ്പർ';

  @override
  String get loginSendOtp => 'OTP അയയ്ക്കുക';

  @override
  String get loginTerms =>
      'തുടർന്നാൽ SMS OTP ഉം സേവന അപ്‌ഡേറ്റുകളും ലഭിച്ചേക്കാം. കാരിയർ നിരക്കുകൾ ബാധകമായേക്കാം.';

  @override
  String get otpEnterCode => 'കോഡ് നൽകുക';

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
  String get splashTagline => 'അനുഗ്രഹം പകരുക';

  @override
  String get dateToday => 'ഇന്ന്';

  @override
  String get footerDailyKatha => 'ഡെയ്‌ലി കഥ';
}
