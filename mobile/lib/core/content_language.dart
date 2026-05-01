import 'package:flutter/material.dart';

import '../models/user_profile.dart';

const Set<String> kSupportedContentLanguages = {'te', 'hi', 'ta', 'kn', 'ml', 'en'};

/// Quote + card text language: English until onboarding completes.
String effectiveContentLanguage(UserSession? session) {
  if (session == null || !session.profile.onboardingComplete) return 'en';
  final c = session.profile.contentLanguage;
  if (kSupportedContentLanguages.contains(c)) return c;
  return 'en';
}

/// App UI locale: English until onboarding, then matches content language.
Locale effectiveAppLocale(UserSession? session) {
  if (session == null || !session.profile.onboardingComplete) {
    return const Locale('en');
  }
  final c = session.profile.contentLanguage;
  if (kSupportedContentLanguages.contains(c)) return Locale(c);
  return const Locale('en');
}
