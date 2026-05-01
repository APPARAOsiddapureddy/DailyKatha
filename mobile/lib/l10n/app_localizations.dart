import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('ta'),
    Locale('te'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Daily Katha'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'Share the Blessing'**
  String get brandTagline;

  /// No description provided for @scrollHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe for more'**
  String get scrollHint;

  /// No description provided for @sectionForYou.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get sectionForYou;

  /// No description provided for @sectionMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get sectionMorning;

  /// No description provided for @sectionTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get sectionTrending;

  /// No description provided for @sectionFestival.
  ///
  /// In en, this message translates to:
  /// **'Festival Special'**
  String get sectionFestival;

  /// No description provided for @sectionEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get sectionEvening;

  /// No description provided for @sectionEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get sectionEntertainment;

  /// No description provided for @onboardingSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get onboardingSelectLanguage;

  /// No description provided for @onboardingSelectInterests.
  ///
  /// In en, this message translates to:
  /// **'Your Interests'**
  String get onboardingSelectInterests;

  /// No description provided for @onboardingSelectReligion.
  ///
  /// In en, this message translates to:
  /// **'Religion (Optional)'**
  String get onboardingSelectReligion;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingDone;

  /// No description provided for @onboardingStep1.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 3'**
  String get onboardingStep1;

  /// No description provided for @onboardingStep2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 3'**
  String get onboardingStep2;

  /// No description provided for @onboardingStep3.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 3'**
  String get onboardingStep3;

  /// No description provided for @onboardingLanguageQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your language?'**
  String get onboardingLanguageQuestion;

  /// No description provided for @onboardingLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show content in the language you speak every day.'**
  String get onboardingLanguageSubtitle;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get onboardingContinue;

  /// No description provided for @onboardingReligionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your spiritual path?'**
  String get onboardingReligionTitle;

  /// No description provided for @onboardingReligionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tune content to honour your faith. This is optional.'**
  String get onboardingReligionSubtitle;

  /// No description provided for @onboardingInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you love to share?'**
  String get onboardingInterestsTitle;

  /// No description provided for @onboardingInterestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick up to 3 — we\'ll fill your home with these.'**
  String get onboardingInterestsSubtitle;

  /// No description provided for @onboardingInterestCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of 3 selected'**
  String onboardingInterestCount(int count);

  /// No description provided for @onboardingFinishCta.
  ///
  /// In en, this message translates to:
  /// **'Finish · Start reading ✦'**
  String get onboardingFinishCta;

  /// No description provided for @homeGreetingNightEarly.
  ///
  /// In en, this message translates to:
  /// **'Good night, {name}.'**
  String homeGreetingNightEarly(Object name);

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}.'**
  String homeGreetingMorning(Object name);

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}.'**
  String homeGreetingAfternoon(Object name);

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}.'**
  String homeGreetingEvening(Object name);

  /// No description provided for @homeGreetingNight.
  ///
  /// In en, this message translates to:
  /// **'Good night, {name}.'**
  String homeGreetingNight(Object name);

  /// No description provided for @homeGreetingSubline.
  ///
  /// In en, this message translates to:
  /// **'Start the day with blessings'**
  String get homeGreetingSubline;

  /// No description provided for @homeBrowseGenre.
  ///
  /// In en, this message translates to:
  /// **'Browse by Genre'**
  String get homeBrowseGenre;

  /// No description provided for @homeQuotesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Quotes'**
  String homeQuotesCount(int count);

  /// No description provided for @homeSectionStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with morning blessings'**
  String get homeSectionStartTitle;

  /// No description provided for @homeSectionFestivalTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Ugadi specials'**
  String get homeSectionFestivalTitle;

  /// No description provided for @homeSectionInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Based on what you love'**
  String get homeSectionInterestsTitle;

  /// No description provided for @homeSectionTrendingTitle.
  ///
  /// In en, this message translates to:
  /// **'What everyone is sharing'**
  String get homeSectionTrendingTitle;

  /// No description provided for @homeSectionCinemaTitle.
  ///
  /// In en, this message translates to:
  /// **'From Telugu cinema'**
  String get homeSectionCinemaTitle;

  /// No description provided for @festivalBannerKicker.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S FESTIVAL'**
  String get festivalBannerKicker;

  /// No description provided for @festivalBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Happy Ugadi'**
  String get festivalBannerTitle;

  /// No description provided for @festivalBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'12 new greetings ready to share'**
  String get festivalBannerSubtitle;

  /// No description provided for @festivalBannerCta.
  ///
  /// In en, this message translates to:
  /// **'Open pack →'**
  String get festivalBannerCta;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all →'**
  String get homeViewAll;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @exploreTabDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get exploreTabDiscover;

  /// No description provided for @exploreTabBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get exploreTabBrowse;

  /// No description provided for @exploreHeadline.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get exploreHeadline;

  /// No description provided for @exploreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore what to share today'**
  String get exploreSubtitle;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search quotes…'**
  String get exploreSearchHint;

  /// No description provided for @exploreJumpIn.
  ///
  /// In en, this message translates to:
  /// **'JUMP IN'**
  String get exploreJumpIn;

  /// No description provided for @exploreWhatToShare.
  ///
  /// In en, this message translates to:
  /// **'What are you sharing?'**
  String get exploreWhatToShare;

  /// No description provided for @exploreTrendingLine.
  ///
  /// In en, this message translates to:
  /// **'TRENDING'**
  String get exploreTrendingLine;

  /// No description provided for @exploreWeekHit.
  ///
  /// In en, this message translates to:
  /// **'This week\'s hits'**
  String get exploreWeekHit;

  /// No description provided for @exploreSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all →'**
  String get exploreSeeAll;

  /// No description provided for @explorePopularSearches.
  ///
  /// In en, this message translates to:
  /// **'POPULAR SEARCHES'**
  String get explorePopularSearches;

  /// No description provided for @exploreYouMightLike.
  ///
  /// In en, this message translates to:
  /// **'You might like these'**
  String get exploreYouMightLike;

  /// No description provided for @exploreUpcomingLine.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING'**
  String get exploreUpcomingLine;

  /// No description provided for @exploreFestivalCalendar.
  ///
  /// In en, this message translates to:
  /// **'Festival calendar'**
  String get exploreFestivalCalendar;

  /// No description provided for @exploreCategoriesLine.
  ///
  /// In en, this message translates to:
  /// **'CATEGORIES'**
  String get exploreCategoriesLine;

  /// No description provided for @exploreBrowseAll.
  ///
  /// In en, this message translates to:
  /// **'Browse everything'**
  String get exploreBrowseAll;

  /// No description provided for @exploreAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get exploreAll;

  /// No description provided for @exploreEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get exploreEmpty;

  /// No description provided for @profileLiked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get profileLiked;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileSaved;

  /// No description provided for @profileShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get profileShared;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get profileInterests;

  /// No description provided for @profileDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get profileDownloads;

  /// No description provided for @profileNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'Notifications on'**
  String get profileNotificationsOn;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & About'**
  String get profileHelp;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileFooter.
  ///
  /// In en, this message translates to:
  /// **'Daily Katha · crafted with care'**
  String get profileFooter;

  /// No description provided for @profileEmptySharedTitle.
  ///
  /// In en, this message translates to:
  /// **'Items you share will appear here'**
  String get profileEmptySharedTitle;

  /// No description provided for @profileEmptySharedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share a card from the feed to see it in this tab.'**
  String get profileEmptySharedSubtitle;

  /// No description provided for @profileInterestCountTrailing.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String profileInterestCountTrailing(int count);

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated'**
  String get languageUpdated;

  /// No description provided for @errorFeedLoad.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load feed'**
  String get errorFeedLoad;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @noCards.
  ///
  /// In en, this message translates to:
  /// **'No cards'**
  String get noCards;

  /// No description provided for @preparingCard.
  ///
  /// In en, this message translates to:
  /// **'Preparing your card…'**
  String get preparingCard;

  /// No description provided for @snackSaveTodo.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery coming soon.'**
  String get snackSaveTodo;

  /// No description provided for @snackEditTodo.
  ///
  /// In en, this message translates to:
  /// **'Edit card coming soon.'**
  String get snackEditTodo;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome home.'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your number. We\'ll send daily greetings, festival wishes, and words worth sharing — right to your phone.'**
  String get loginSubtitle;

  /// No description provided for @loginMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'MOBILE NUMBER'**
  String get loginMobileLabel;

  /// No description provided for @loginSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get loginSendOtp;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to receive WhatsApp-style updates. Carrier rates may apply.'**
  String get loginTerms;

  /// No description provided for @otpEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get otpEnterCode;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'+91 {phone}'**
  String otpSentTo(Object phone);

  /// No description provided for @otpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerify;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get otpResend;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Blessings worth sharing'**
  String get splashTagline;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @footerDailyKatha.
  ///
  /// In en, this message translates to:
  /// **'DAILY KATHA'**
  String get footerDailyKatha;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'hi',
    'kn',
    'ml',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
