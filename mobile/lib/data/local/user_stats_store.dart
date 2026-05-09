import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class UserStats {
  const UserStats({
    required this.savedCount,
    required this.sharedCount,
  });

  final int savedCount;
  final int sharedCount;

  UserStats copyWith({int? savedCount, int? sharedCount}) {
    return UserStats(
      savedCount: savedCount ?? this.savedCount,
      sharedCount: sharedCount ?? this.sharedCount,
    );
  }
}

abstract final class UserStatsStore {
  static const _kSaved = 'dk_stats_saved_v1';
  static const _kShared = 'dk_stats_shared_v1';

  static Future<UserStats> load() async {
    final prefs = await SharedPreferences.getInstance();
    return UserStats(
      savedCount: prefs.getInt(_kSaved) ?? 0,
      sharedCount: prefs.getInt(_kShared) ?? 0,
    );
  }

  static Future<void> set(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSaved, stats.savedCount);
    await prefs.setInt(_kShared, stats.sharedCount);
  }
}

