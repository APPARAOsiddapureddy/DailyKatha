import 'package:flutter/foundation.dart';

@immutable
class AnalyticsEvent {
  const AnalyticsEvent(this.name, [this.props = const {}]);

  final String name;
  final Map<String, Object?> props;
}

/// Minimal analytics contract. Implement with Firebase/PostHog later.
abstract class Analytics {
  Future<void> log(String name, {Map<String, Object?> props = const {}});

  Future<void> setUserId(String? id);

  Future<void> setUserProperties(Map<String, Object?> props);
}

class NoopAnalytics implements Analytics {
  const NoopAnalytics();

  @override
  Future<void> log(String name, {Map<String, Object?> props = const {}}) async {}

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> setUserProperties(Map<String, Object?> props) async {}
}

abstract final class AEvents {
  static const onboardingComplete = 'onboarding_complete';
  static const interestChanged = 'interest_changed';
  static const feedOpened = 'feed_opened';
  static const editorOpened = 'editor_opened';
  static const imageSelected = 'image_selected';
  static const shareClicked = 'share_clicked';
  static const shareSheetOpened = 'share_sheet_opened';
  static const reminderEnabled = 'reminder_enabled';
  static const notificationOpened = 'notification_opened';
  static const cardCreated = 'card_created';
  /// Like toggled from feed (double-tap or heart control).
  static const cardLikeToggled = 'card_like_toggled';
}

