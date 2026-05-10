import 'package:shared_preferences/shared_preferences.dart';

/// One-time UX: prompts for a preferred name after onboarding; stored independently of JWT profile.
abstract final class DisplayNamePromptStore {
  static const _kKey = 'dk_display_name_prompt_done_v1';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kKey) ?? false;
  }

  static Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kKey, true);
  }
}
