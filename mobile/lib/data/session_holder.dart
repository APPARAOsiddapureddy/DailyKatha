import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';

/// Synchronous session mirror for [ApiClient] token resolution.
class SessionHolder extends Notifier<UserSession?> {
  @override
  UserSession? build() => null;

  void setSession(UserSession session) => state = session;

  void clear() => state = null;

  void replaceProfile(UserProfile profile) {
    final current = state;
    if (current == null) return;
    state = UserSession(
      accessToken: current.accessToken,
      refreshToken: current.refreshToken,
      profile: profile,
    );
  }
}
