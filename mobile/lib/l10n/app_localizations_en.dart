// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daily Katha';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navProfile => 'Profile';

  @override
  String get brandTagline => 'Share the Blessing';

  @override
  String get scrollHint => 'Swipe for more';

  @override
  String get sectionForYou => 'For You';

  @override
  String get sectionMorning => 'Morning';

  @override
  String get sectionTrending => 'Trending';

  @override
  String get sectionFestival => 'Festival Special';

  @override
  String get sectionEvening => 'Evening';

  @override
  String get sectionEntertainment => 'Entertainment';

  @override
  String get onboardingSelectLanguage => 'Select Language';

  @override
  String get onboardingSelectInterests => 'Your Interests';

  @override
  String get onboardingSelectReligion => 'Religion (Optional)';

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
  String get onboardingLanguageQuestion => 'What\'s your language?';

  @override
  String get onboardingLanguageSubtitle =>
      'We\'ll show content in the language you speak every day.';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingReligionTitle => 'Your spiritual path?';

  @override
  String get onboardingReligionSubtitle =>
      'We\'ll tune content to honour your faith. This is optional.';

  @override
  String get onboardingInterestsTitle => 'What do you love to share?';

  @override
  String get onboardingInterestsSubtitle =>
      'Pick up to 3 — we\'ll fill your home with these.';

  @override
  String onboardingInterestCount(int count) {
    return '$count of 3 selected';
  }

  @override
  String get onboardingFinishCta => 'Finish · Start reading ✦';

  @override
  String homeGreetingNightEarly(Object name) {
    return 'Good night, $name.';
  }

  @override
  String homeGreetingMorning(Object name) {
    return 'Good morning, $name.';
  }

  @override
  String homeGreetingAfternoon(Object name) {
    return 'Good afternoon, $name.';
  }

  @override
  String homeGreetingEvening(Object name) {
    return 'Good evening, $name.';
  }

  @override
  String homeGreetingNight(Object name) {
    return 'Good night, $name.';
  }

  @override
  String get homeGreetingSubline => 'Start the day with blessings';

  @override
  String get homeBrowseGenre => 'Browse by Genre';

  @override
  String homeQuotesCount(int count) {
    return '$count Quotes';
  }

  @override
  String get homeSectionStartTitle => 'Start with morning blessings';

  @override
  String get homeSectionFestivalTitle => 'Today\'s Ugadi specials';

  @override
  String get homeSectionInterestsTitle => 'Based on what you love';

  @override
  String get homeSectionTrendingTitle => 'What everyone is sharing';

  @override
  String get homeSectionCinemaTitle => 'From Telugu cinema';

  @override
  String get festivalBannerKicker => 'TODAY\'S FESTIVAL';

  @override
  String get festivalBannerTitle => 'Happy Ugadi';

  @override
  String get festivalBannerSubtitle => '12 new greetings ready to share';

  @override
  String get festivalBannerCta => 'Open pack →';

  @override
  String get homeViewAll => 'View all →';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get exploreTabDiscover => 'Discover';

  @override
  String get exploreTabBrowse => 'Browse';

  @override
  String get exploreHeadline => 'Search';

  @override
  String get exploreSubtitle => 'Explore what to share today';

  @override
  String get exploreSearchHint => 'Search quotes…';

  @override
  String get exploreJumpIn => 'JUMP IN';

  @override
  String get exploreWhatToShare => 'What are you sharing?';

  @override
  String get exploreTrendingLine => 'TRENDING';

  @override
  String get exploreWeekHit => 'This week\'s hits';

  @override
  String get exploreSeeAll => 'See all →';

  @override
  String get explorePopularSearches => 'POPULAR SEARCHES';

  @override
  String get exploreYouMightLike => 'You might like these';

  @override
  String get exploreUpcomingLine => 'UPCOMING';

  @override
  String get exploreFestivalCalendar => 'Festival calendar';

  @override
  String get exploreCategoriesLine => 'CATEGORIES';

  @override
  String get exploreBrowseAll => 'Browse everything';

  @override
  String get exploreAll => 'All';

  @override
  String get exploreEmpty => 'Nothing found';

  @override
  String get profileLiked => 'Liked';

  @override
  String get profileSaved => 'Saved';

  @override
  String get profileShared => 'Shared';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileInterests => 'Interests';

  @override
  String get profileDownloads => 'Downloads';

  @override
  String get profileNotificationsOn => 'Notifications on';

  @override
  String get profileHelp => 'Help & About';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileFooter => 'Daily Katha · crafted with care';

  @override
  String get profileEmptySharedTitle => 'Items you share will appear here';

  @override
  String get profileEmptySharedSubtitle =>
      'Share a card from the feed to see it in this tab.';

  @override
  String profileInterestCountTrailing(int count) {
    return '$count selected';
  }

  @override
  String get profileLogout => 'Logout';

  @override
  String get languageUpdated => 'Language updated';

  @override
  String get errorFeedLoad => 'Couldn\'t load feed';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get noCards => 'No cards';

  @override
  String get preparingCard => 'Preparing your card…';

  @override
  String get snackSaveTodo => 'Save to gallery coming soon.';

  @override
  String get snackEditTodo => 'Edit card coming soon.';

  @override
  String get loginWelcome => 'Welcome home.';

  @override
  String get loginSubtitle =>
      'Enter your number. We\'ll send daily greetings, festival wishes, and words worth sharing — right to your phone.';

  @override
  String get loginMobileLabel => 'MOBILE NUMBER';

  @override
  String get loginSendOtp => 'Send OTP';

  @override
  String get loginTerms =>
      'By continuing you agree to receive SMS OTPs and service updates. Carrier rates may apply.';

  @override
  String get otpEnterCode => 'Enter code';

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
  String get splashTagline => 'Blessings worth sharing';

  @override
  String get dateToday => 'Today';

  @override
  String get footerDailyKatha => 'DAILY KATHA';
}
