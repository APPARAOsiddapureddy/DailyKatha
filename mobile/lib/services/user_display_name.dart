import 'package:characters/characters.dart';

import '../models/user_profile.dart';

/// User-entered [UserProfile.displayName] is always shown in **English / Latin** in the UI
/// (no script transliteration).
abstract final class UserDisplayName {
  /// Clears any legacy native-script cache when persisting profile.
  static UserProfile withNativeSynced(UserProfile p) => p.copyWith(displayNameNative: null);

  static String displayAsEntered(UserProfile profile) {
    final t = profile.displayName.trim();
    if (t.isEmpty || isPlaceholderDisplayName(t)) return 'Friend';
    return t;
  }

  static String firstWord(UserProfile profile) {
    final s = displayAsEntered(profile);
    if (s == 'Friend') return 'Friend';
    final parts = s.split(RegExp(r'\s+'));
    return parts.first;
  }

  static String avatarInitial(UserProfile profile) {
    final s = displayAsEntered(profile);
    if (s == 'Friend') return '\u2022';
    final it = Characters(s);
    if (it.isEmpty) return '\u2022';
    return it.first.toUpperCase();
  }
}
