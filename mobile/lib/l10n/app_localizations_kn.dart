// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ಡೈಲಿ ಕಥಾ';

  @override
  String get navHome => 'ಹೋಮ್';

  @override
  String get navExplore => 'ಅನ್ವೇಷಿಸಿ';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get brandTagline => 'ಆಶೀರ್ವಾದ ಹಂಚಿ';

  @override
  String get scrollHint => 'ಸ್ಕ್ರಾಲ್ ಮಾಡಿ';

  @override
  String get sectionForYou => 'ನಿಮಗಾಗಿ';

  @override
  String get sectionMorning => 'ಬೆಳಗಿನ ಆರಂಭ';

  @override
  String get sectionTrending => 'ಟ್ರೆಂಡಿಂಗ್';

  @override
  String get sectionFestival => 'ಹಬ್ಬ ವಿಶೇಷ';

  @override
  String get sectionEvening => 'ಸಂಜೆ';

  @override
  String get sectionEntertainment => 'ಮನರಂಜನೆ';

  @override
  String get onboardingSelectLanguage => 'ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get onboardingSelectInterests => 'ನಿಮ್ಮ ಆಸಕ್ತಿಗಳು';

  @override
  String get onboardingSelectReligion => 'ಧರ್ಮ (ಐಚ್ಛಿಕ)';

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
  String get onboardingLanguageQuestion => 'ನಿಮ್ಮ ಭಾಷೆ ಯಾವುದು?';

  @override
  String get onboardingLanguageSubtitle =>
      'ನೀವು ದಿನನಿತ್ಯ ಮಾತನಾಡುವ ಭಾಷೆಯಲ್ಲಿ ವಿಷಯ ತೋರಿಸುತ್ತೇವೆ.';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingReligionTitle => 'ನಿಮ್ಮ ಆಧ್ಯಾತ್ಮಿಕ ಮಾರ್ಗ?';

  @override
  String get onboardingReligionSubtitle =>
      'ನಿಮ್ಮ ನಂಬಿಕೆಗೆ ಗೌರವ ನೀಡಲು ವಿಷಯವನ್ನು ಹೊಂದಿಸುತ್ತೇವೆ. ಇದು ಐಚ್ಛಿಕ.';

  @override
  String get onboardingInterestsTitle => 'ನೀವು ಏನು ಹಂಚಿಕೊಳ್ಳಲು ಇಷ್ಟಪಡುತ್ತೀರಿ?';

  @override
  String get onboardingInterestsSubtitle =>
      'ಗರಿಷ್ಠ 3 ಆಯ್ಕೆಮಾಡಿ — ನಿಮ್ಮ ಹೋಮ್ ಅನ್ನು ಇವುಗಳಿಂದ ತುಂಬಿಸುತ್ತೇವೆ.';

  @override
  String onboardingInterestCount(int count) {
    return '$count/3 ಆಯ್ಕೆ';
  }

  @override
  String get onboardingFinishCta => 'Finish · Start reading ✦';

  @override
  String homeGreetingNightEarly(Object name) {
    return 'ಶುಭ ರಾತ್ರಿ, $name.';
  }

  @override
  String homeGreetingMorning(Object name) {
    return 'ಶುಭೋದಯ, $name.';
  }

  @override
  String homeGreetingAfternoon(Object name) {
    return 'ಶುಭ ಮಧ್ಯಾಹ್ನ, $name.';
  }

  @override
  String homeGreetingEvening(Object name) {
    return 'ಶುಭ ಸಂಜೆ, $name.';
  }

  @override
  String homeGreetingNight(Object name) {
    return 'ಶುಭ ರಾತ್ರಿ, $name.';
  }

  @override
  String get homeGreetingSubline => 'ಆಶೀರ್ವಾದದೊಂದಿಗೆ ದಿನ ಆರಂಭಿಸಿ';

  @override
  String get homeBrowseGenre => 'ಪ್ರಕಾರದ ಪ್ರಕಾರ ನೋಡಿ';

  @override
  String homeQuotesCount(int count) {
    return '$count ಉಲ್ಲೇಖಗಳು';
  }

  @override
  String get homeSectionStartTitle => 'ಬೆಳಗಿನ ಆಶೀರ್ವಾದದೊಂದಿಗೆ ಪ್ರಾರಂಭ';

  @override
  String get homeSectionFestivalTitle => 'ಇಂದಿನ ಯುಗಾದಿ ವಿಶೇಷ';

  @override
  String get homeSectionInterestsTitle => 'ನೀವು ಇಷ್ಟಪಡುವ ಆಧಾರದ ಮೇಲೆ';

  @override
  String get homeSectionTrendingTitle => 'ಎಲ್ಲರೂ ಹಂಚಿಕೊಳ್ಳುತ್ತಿರುವುದು';

  @override
  String get homeSectionCinemaTitle => 'ತೆಲುಗು ಸಿನಿಮಾದಿಂದ';

  @override
  String get festivalBannerKicker => 'ಇಂದಿನ ಹಬ್ಬ';

  @override
  String get festivalBannerTitle => 'ಯುಗಾದಿ ಶುಭಾಶಯಗಳು';

  @override
  String get festivalBannerSubtitle => 'ಹಂಚಲು 12 ಹೊಸ ಶುಭಾಶಯಗಳು ಸಿದ್ಧ';

  @override
  String get festivalBannerCta => 'ಪ್ಯಾಕ್ ತೆರೆಯಿರಿ →';

  @override
  String get homeViewAll => 'ಎಲ್ಲಾ ನೋಡಿ →';

  @override
  String get notificationsTitle => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get exploreTabDiscover => 'ಡಿಸ್ಕವರ್';

  @override
  String get exploreTabBrowse => 'ಬ್ರೌಸ್';

  @override
  String get exploreHeadline => 'ಹುಡುಕಿ';

  @override
  String get exploreSubtitle => 'ಇಂದು ಏನು ಹಂಚಿಕೊಳ್ಳಬೇಕು ಎಂದು ಅನ್ವೇಷಿಸಿ';

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
  String get exploreSearchHint => 'ಉಲ್ಲೇಖ ಹುಡುಕಿ…';

  @override
  String get exploreSearchNoMatch =>
      'No match — try morning, birthday, love, festival…';

  @override
  String get exploreJumpIn => 'ಒಳಗೆ ಹೋಗಿ';

  @override
  String get exploreWhatToShare => 'ಏನು ಹಂಚಿಕೊಳ್ಳುತ್ತೀರಿ?';

  @override
  String get exploreTrendingLine => 'ಟ್ರೆಂಡಿಂಗ್';

  @override
  String get exploreWeekHit => 'ಈ ವಾರದ ಹಿಟ್';

  @override
  String get exploreSeeAll => 'See all →';

  @override
  String get explorePopularSearches => 'ಜನಪ್ರಿಯ ಹುಡುಕಾಟಗಳು';

  @override
  String get exploreYouMightLike => 'ಇವು ನಿಮಗೆ ಇಷ್ಟವಾಗಬಹುದು';

  @override
  String get exploreUpcomingLine => 'ಮುಂಬರುವ';

  @override
  String get exploreFestivalCalendar => 'ಹಬ್ಬ ಕ್ಯಾಲೆಂಡರ್';

  @override
  String get exploreCategoriesLine => 'ವರ್ಗಗಳು';

  @override
  String get exploreBrowseAll => 'ಎಲ್ಲವನ್ನೂ ಬ್ರೌಸ್ ಮಾಡಿ';

  @override
  String get exploreAll => 'ಎಲ್ಲಾ';

  @override
  String get exploreEmpty => 'ಏನೂ ಸಿಗಲಿಲ್ಲ';

  @override
  String get profileLiked => 'ಇಷ್ಟಪಟ್ಟವು';

  @override
  String get profileSaved => 'ಉಳಿಸಿದವು';

  @override
  String get profileStatEdits => 'Edits';

  @override
  String get profileShared => 'ಹಂಚಿದವು';

  @override
  String get profileSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್';

  @override
  String get profileLanguage => 'ಭಾಷೆ';

  @override
  String get profileInterests => 'ಆಸಕ್ತಿಗಳು';

  @override
  String get profileDownloads => 'ಡೌನ್‌ಲೋಡ್‌ಗಳು';

  @override
  String get profileNotificationsOn => 'ಅಧಿಸೂಚನೆಗಳು ಆನ್';

  @override
  String get profileHelp => 'ಸಹಾಯ';

  @override
  String get namePromptTitle => 'ನಿಮ್ಮನ್ನು ಏನೆಂದು ಕರೆಯೋಣ?';

  @override
  String get namePromptBody =>
      'ಹೋಮ್ ಮತ್ತು ಪ್ರೊಫೈಲ್‌ನಲ್ಲಿ ಈ ಹೆಸರನ್ನು ತೋರಿಸುತ್ತೇವೆ.';

  @override
  String get namePromptHint => 'ನಿಮ್ಮ ಹೆಸರು';

  @override
  String get namePromptSave => 'ಉಳಿಸಿ';

  @override
  String get namePromptSkip => 'ಈಗ ಬೇಡ';

  @override
  String get profileYourName => 'ನಿಮ್ಮ ಹೆಸರು';

  @override
  String get profileYourNameSub => 'ಹೋಮ್ ಅಭಿವಾದನೆಯಲ್ಲಿ ಕಾಣುತ್ತದೆ';

  @override
  String get profileEditNameTitle => 'ಹೆಸರು ಬದಲಾಯಿಸಿ';

  @override
  String get profileEditNameCancel => 'ರದ್ದು';

  @override
  String get profileSignOut => 'ಸೈನ್ ಔಟ್';

  @override
  String get profileFooter => 'ಡೈಲಿ ಕಥಾ · ಪ್ರೀತಿಯಿಂದ ತಯಾರಿಸಲಾಗಿದೆ';

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
  String get profileEmptySharedTitle => 'ನೀವು ಹಂಚಿದವು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ';

  @override
  String get profileEmptySharedSubtitle =>
      'ಫೀಡ್‌ನಿಂದ ಕಾರ್ಡ್ ಹಂಚಿಕೊಂಡರೆ ಇಲ್ಲಿ ಕಾಣುತ್ತದೆ.';

  @override
  String profileInterestCountTrailing(int count) {
    return '$count ಆಯ್ಕೆ';
  }

  @override
  String get profileLogout => 'ಲಾಗ್ ಔಟ್';

  @override
  String get languageUpdated => 'ಭಾಷೆ ಬದಲಾಯಿತು';

  @override
  String get errorFeedLoad => 'ಫೀಡ್ ಲೋಡ್ ಆಗಲಿಲ್ಲ';

  @override
  String get errorGeneric => 'ಏನೋ ತಪ್ಪಾಗಿದೆ';

  @override
  String get noCards => 'ಕಾರ್ಡ್‌ಗಳಿಲ್ಲ';

  @override
  String get preparingCard => 'ನಿಮ್ಮ ಕಾರ್ಡ್ ಸಿದ್ಧವಾಗುತ್ತಿದೆ…';

  @override
  String get snackSaveTodo => 'ಗ್ಯಾಲರಿಗೆ ಉಳಿಸುವಿಕೆ ಶೀಘ್ರದಲ್ಲೇ.';

  @override
  String get snackEditTodo => 'ಕಾರ್ಡ್ ಸಂಪಾದನೆ ಶೀಘ್ರದಲ್ಲೇ.';

  @override
  String get loginWelcome => 'ಸ್ವಾಗತ.';

  @override
  String get loginSubtitle =>
      'ನಿಮ್ಮ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ. ದೈನಂದಿನ ಶುಭಾಶಯಗಳು, ಹಬ್ಬದ ಸಂದೇಶಗಳು — ನಿಮ್ಮ ಫೋನ್‌ಗೆ.';

  @override
  String get loginMobileLabel => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get loginSendOtp => 'OTP ಕಳುಹಿಸಿ';

  @override
  String get loginTerms =>
      'ಮುಂದುವರಿಸಿದರೆ SMS OTP ಮತ್ತು ಸೇವಾ ನವೀಕರಣಗಳು ಬರುವುದಾಗಿರಬಹುದು. ಕ್ಯಾರಿಯರ್ ಶುಲ್ಕಗಳು ಅನ್ವಯವಾಗಬಹುದು.';

  @override
  String get otpEnterCode => 'ಕೋಡ್ ನಮೂದಿಸಿ';

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
  String get splashTagline => 'ಆಶೀರ್ವಾದ ಹಂಚಿ';

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
  String get dateToday => 'ಇಂದು';

  @override
  String get footerDailyKatha => 'ಡೈಲಿ ಕಥಾ';
}
