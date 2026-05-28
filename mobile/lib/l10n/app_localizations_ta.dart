// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'டெய்லி கதை';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navExplore => 'ஆராய்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get brandTagline => 'ஆசியை பகிருங்கள்';

  @override
  String get scrollHint => 'மேலே ஸ்க்ரோல்';

  @override
  String get sectionForYou => 'உங்களுக்காக';

  @override
  String get sectionMorning => 'காலை தொடக்கம்';

  @override
  String get sectionTrending => 'பிரபலமானவை';

  @override
  String get sectionFestival => 'திருவிழா சிறப்பு';

  @override
  String get sectionEvening => 'மாலை';

  @override
  String get sectionEntertainment => 'பொழுதுபோக்கு';

  @override
  String get onboardingSelectLanguage => 'மொழி தேர்ந்தெடுக்கவும்';

  @override
  String get onboardingSelectInterests => 'உங்கள் ஆர்வங்கள்';

  @override
  String get onboardingSelectReligion => 'மதம் (விரும்பினால்)';

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
  String get onboardingLanguageQuestion => 'உங்கள் மொழி எது?';

  @override
  String get onboardingLanguageSubtitle =>
      'நீங்கள் தினமும் பேசும் மொழியில் உள்ளடக்கத்தைக் காட்டுவோம்.';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingReligionTitle => 'உங்கள் ஆன்மீகப் பாதை?';

  @override
  String get onboardingReligionSubtitle =>
      'உங்கள் நம்பிக்கைக்கு மரியாதை செலுத்த உள்ளடக்கத்தைச் சரிசெய்வோம். இது விருப்பம்.';

  @override
  String get onboardingInterestsTitle => 'எதைப் பகிர விரும்புகிறீர்கள்?';

  @override
  String get onboardingInterestsSubtitle =>
      'அதிகபட்சம் 3 — உங்கள் முகப்பை இவற்றால் நிரப்புவோம்.';

  @override
  String onboardingInterestCount(int count) {
    return '$count/3 தேர்ந்தெடுக்கப்பட்டது';
  }

  @override
  String get onboardingFinishCta => 'Finish · Start reading ✦';

  @override
  String homeGreetingNightEarly(Object name) {
    return 'இரவு வணக்கம், $name.';
  }

  @override
  String homeGreetingMorning(Object name) {
    return 'காலை வணக்கம், $name.';
  }

  @override
  String homeGreetingAfternoon(Object name) {
    return 'மதிய வணக்கம், $name.';
  }

  @override
  String homeGreetingEvening(Object name) {
    return 'மாலை வணக்கம், $name.';
  }

  @override
  String homeGreetingNight(Object name) {
    return 'இரவு வணக்கம், $name.';
  }

  @override
  String get homeGreetingSubline => 'ஆசியுடன் நாளைத் தொடங்குங்கள்';

  @override
  String get homeBrowseGenre => 'வகை வாரியாக பார்க்க';

  @override
  String homeQuotesCount(int count) {
    return '$count மேற்கோள்கள்';
  }

  @override
  String get homeSectionStartTitle => 'காலை ஆசீர்வாதத்துடன் தொடங்குங்கள்';

  @override
  String get homeSectionFestivalTitle => 'இன்றைய உகாதி சிறப்புகள்';

  @override
  String get homeSectionInterestsTitle => 'நீங்கள் விரும்புவதை அடிப்படையாக';

  @override
  String get homeSectionTrendingTitle => 'அனைவரும் பகிர்வது';

  @override
  String get homeSectionCinemaTitle => 'தெலுங்கு சினிமாவிலிருந்து';

  @override
  String get festivalBannerKicker => 'இன்றைய திருவிழா';

  @override
  String get festivalBannerTitle => 'உகாதி நல்வாழ்த்துக்கள்';

  @override
  String get festivalBannerSubtitle => 'பகிர 12 புதிய வாழ்த்துக்கள் தயார்';

  @override
  String get festivalBannerCta => 'தொகுப்பைத் திற →';

  @override
  String get homeViewAll => 'அனைத்தையும் காண்க →';

  @override
  String get notificationsTitle => 'அறிவிப்புகள்';

  @override
  String get exploreTabDiscover => 'கண்டுபிடி';

  @override
  String get exploreTabBrowse => 'உலாவு';

  @override
  String get exploreHeadline => 'தேடு';

  @override
  String get exploreSubtitle => 'இன்று எதைப் பகிரலாம் என ஆராயுங்கள்';

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
  String get exploreSearchHint => 'மேற்கோள் தேடு…';

  @override
  String get exploreSearchNoMatch =>
      'No match — try morning, birthday, love, festival…';

  @override
  String get exploreJumpIn => 'உள்ளே செல்';

  @override
  String get exploreWhatToShare => 'எதைப் பகிர்கிறீர்கள்?';

  @override
  String get exploreTrendingLine => 'பிரபலம்';

  @override
  String get exploreWeekHit => 'இந்த வாரம் ஹிட்';

  @override
  String get exploreSeeAll => 'See all →';

  @override
  String get explorePopularSearches => 'பிரபல தேடல்கள்';

  @override
  String get exploreYouMightLike => 'இவை உங்களுக்குப் பிடிக்கலாம்';

  @override
  String get exploreUpcomingLine => 'வரவிருப்பவை';

  @override
  String get exploreFestivalCalendar => 'திருவிழா நாட்காட்டி';

  @override
  String get exploreCategoriesLine => 'வகைகள்';

  @override
  String get exploreBrowseAll => 'அனைத்தையும் உலாவு';

  @override
  String get exploreAll => 'அனைத்தும்';

  @override
  String get exploreEmpty => 'எதுவும் கிடைக்கவில்லை';

  @override
  String get profileLiked => 'விரும்பியவை';

  @override
  String get profileSaved => 'சேமித்தவை';

  @override
  String get profileStatEdits => 'Edits';

  @override
  String get profileShared => 'பகிர்ந்தவை';

  @override
  String get profileSettings => 'அமைப்புகள்';

  @override
  String get profileLanguage => 'மொழி';

  @override
  String get profileInterests => 'ஆர்வங்கள்';

  @override
  String get profileDownloads => 'பதிவிறக்கங்கள்';

  @override
  String get profileNotificationsOn => 'அறிவிப்புகள் இயக்கம்';

  @override
  String get profileHelp => 'உதவி';

  @override
  String get namePromptTitle => 'உங்களை எப்படி அழைக்கலாம்?';

  @override
  String get namePromptBody =>
      'முகப்பு வாழ்த்திலும் சுயவிவரத்திலும் பயன்படுத்துவோம்.';

  @override
  String get namePromptHint => 'உங்கள் பெயர்';

  @override
  String get namePromptSave => 'சேமி';

  @override
  String get namePromptSkip => 'இப்போது வேண்டாம்';

  @override
  String get profileYourName => 'உங்கள் பெயர்';

  @override
  String get profileYourNameSub => 'முகப்பில் வாழ்த்தில் காட்டப்படும்';

  @override
  String get profileEditNameTitle => 'பெயரை மாற்று';

  @override
  String get profileEditNameCancel => 'ரத்து';

  @override
  String get profileSignOut => 'வெளியேறு';

  @override
  String get profileFooter => 'டெய்லி கதை · அக்கறையுடன்';

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
  String get profileEmptySharedTitle => 'நீங்கள் பகிர்ந்தவை இங்கே தோன்றும்';

  @override
  String get profileEmptySharedSubtitle =>
      'ஃபீடில் இருந்து கார்டைப் பகிர்ந்தால் இங்கே காண்போம்.';

  @override
  String profileInterestCountTrailing(int count) {
    return '$count தேர்ந்தெடுக்கப்பட்டது';
  }

  @override
  String get profileLogout => 'வெளியேறு';

  @override
  String get languageUpdated => 'மொழி மாற்றப்பட்டது';

  @override
  String get errorFeedLoad => 'ஃபீட் ஏற்ற முடியவில்லை';

  @override
  String get errorGeneric => 'ஏதோ தவறு நடந்தது';

  @override
  String get noCards => 'கார்டுகள் இல்லை';

  @override
  String get preparingCard => 'உங்கள் கார்டு தயாராகிறது…';

  @override
  String get snackSaveTodo => 'கேலரியில் சேமிப்பு விரைவில்.';

  @override
  String get snackEditTodo => 'கார்டு திருத்தம் விரைவில்.';

  @override
  String get loginWelcome => 'வரவேற்கிறோம்.';

  @override
  String get loginSubtitle =>
      'உங்கள் எண்ணை உள்ளிடுங்கள். தினசரி வாழ்த்துக்கள், திருவிழா செய்திகள் — உங்கள் தொலைபேசிக்கு.';

  @override
  String get loginMobileLabel => 'கைபேசி எண்';

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
  String get splashTagline => 'ஆசியை பகிருங்கள்';

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
  String get dateToday => 'இன்று';

  @override
  String get footerDailyKatha => 'டெய்லி கதை';
}
