import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics.dart';

final analyticsProvider = Provider<Analytics>((ref) {
  // Default to no-op. Swap this to FirebaseAnalytics/PostHog implementation when credentials are added.
  return const NoopAnalytics();
});

