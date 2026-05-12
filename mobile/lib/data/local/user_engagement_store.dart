import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locally persisted lists for Library screens + category affinity for Home ordering.
@immutable
class UserEngagementSnapshot {
  const UserEngagementSnapshot({
    required this.savedCardIds,
    required this.sharedCardIds,
    required this.likedCardIds,
    required this.categoryAffinity,
  });

  final List<String> savedCardIds;
  final List<String> sharedCardIds;
  final List<String> likedCardIds;
  final Map<String, int> categoryAffinity;
}

abstract final class UserEngagementStore {
  static const _kSaved = 'dk_eng_saved_ids_v1';
  static const _kShared = 'dk_eng_shared_ids_v1';
  static const _kLiked = 'dk_eng_liked_ids_v1';
  static const _kAffinity = 'dk_eng_category_affinity_v1';

  /// Extra affinity when user taps **Keep** (library-only, no gallery export).
  static const int affinityDeltaKeepNew = 4;
  /// When adding to library but card was already kept — small recap signal.
  static const int affinityDeltaKeepRepeat = 1;
  /// When user double-taps to like — strong personalization for Home picks.
  static const int affinityDeltaLikeOn = 12;
  static const int affinityDeltaLikeOff = -12;

  static Future<UserEngagementSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = _decodeIds(prefs.getString(_kSaved));
    final shared = _decodeIds(prefs.getString(_kShared));
    final liked = _decodeIds(prefs.getString(_kLiked));
    final aff = _decodeAffinity(prefs.getString(_kAffinity));
    return UserEngagementSnapshot(
      savedCardIds: saved,
      sharedCardIds: shared,
      likedCardIds: liked,
      categoryAffinity: aff,
    );
  }

  static List<String> _decodeIds(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    try {
      final d = jsonDecode(raw);
      if (d is! List) return const [];
      return d.map((e) => '$e').where((s) => s.isNotEmpty).toList();
    } catch (_) {
      return const [];
    }
  }

  static Map<String, int> _decodeAffinity(String? raw) {
    if (raw == null || raw.trim().isEmpty) return {};
    try {
      final d = jsonDecode(raw);
      if (d is! Map) return {};
      return d.map((k, v) => MapEntry('$k', (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  static Future<void> _writeIds(String key, List<String> ids, {int cap = 300}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(ids.take(cap).toList()));
  }

  /// Adds [cardId] to the Saved tab list. Returns `true` if it was newly added.
  static Future<bool> recordSaved(String cardId) async {
    if (cardId.isEmpty) return false;
    final snap = await load();
    final key = cardId;
    if (snap.savedCardIds.contains(key)) return false;
    final next = [key, ...snap.savedCardIds];
    await _writeIds(_kSaved, next);
    return true;
  }

  static Future<void> recordShared(String cardId) async {
    if (cardId.isEmpty) return;
    final snap = await load();
    final key = cardId;
    if (snap.sharedCardIds.contains(key)) return;
    final next = [key, ...snap.sharedCardIds];
    await _writeIds(_kShared, next);
  }

  static Future<bool> bumpCategoryAffinity(String category, {int delta = 1}) async {
    if (category.isEmpty) return false;
    final snap = await load();
    final m = Map<String, int>.from(snap.categoryAffinity);
    final next = (m[category] ?? 0) + delta;
    m[category] = next < 0 ? 0 : next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAffinity, jsonEncode(m));
    return true;
  }

  /// Returns new liked state: `true` if now liked, `false` if unliked.
  static Future<bool> toggleLiked(String cardId, String category) async {
    if (cardId.isEmpty) return false;
    final snap = await load();
    final key = cardId;
    final liked = List<String>.from(snap.likedCardIds);
    if (liked.contains(key)) {
      liked.remove(key);
      await _writeIds(_kLiked, liked, cap: 500);
      await bumpCategoryAffinity(category, delta: affinityDeltaLikeOff);
      return false;
    }
    final next = [key, ...liked];
    await _writeIds(_kLiked, next, cap: 500);
    await bumpCategoryAffinity(category, delta: affinityDeltaLikeOn);
    return true;
  }

  static Future<bool> isLiked(String cardId) async {
    if (cardId.isEmpty) return false;
    final snap = await load();
    return snap.likedCardIds.contains(cardId);
  }
}
