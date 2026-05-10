import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locally persisted lists for Library screens + category affinity for Home ordering.
@immutable
class UserEngagementSnapshot {
  const UserEngagementSnapshot({
    required this.savedCardIds,
    required this.sharedCardIds,
    required this.categoryAffinity,
  });

  final List<String> savedCardIds;
  final List<String> sharedCardIds;
  final Map<String, int> categoryAffinity;
}

abstract final class UserEngagementStore {
  static const _kSaved = 'dk_eng_saved_ids_v1';
  static const _kShared = 'dk_eng_shared_ids_v1';
  static const _kAffinity = 'dk_eng_category_affinity_v1';

  static Future<UserEngagementSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = _decodeIds(prefs.getString(_kSaved));
    final shared = _decodeIds(prefs.getString(_kShared));
    final aff = _decodeAffinity(prefs.getString(_kAffinity));
    return UserEngagementSnapshot(
      savedCardIds: saved,
      sharedCardIds: shared,
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

  static Future<void> _writeIds(String key, List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(ids.take(300).toList()));
  }

  static Future<void> recordSaved(String cardId) async {
    if (cardId.isEmpty) return;
    final snap = await load();
    if (snap.savedCardIds.contains(cardId)) return;
    final next = [cardId, ...snap.savedCardIds];
    await _writeIds(_kSaved, next);
  }

  static Future<void> recordShared(String cardId) async {
    if (cardId.isEmpty) return;
    final snap = await load();
    if (snap.sharedCardIds.contains(cardId)) return;
    final next = [cardId, ...snap.sharedCardIds];
    await _writeIds(_kShared, next);
  }

  static Future<void> bumpCategoryAffinity(String category, {int delta = 1}) async {
    if (category.isEmpty) return;
    final snap = await load();
    final m = Map<String, int>.from(snap.categoryAffinity);
    m[category] = (m[category] ?? 0) + delta;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAffinity, jsonEncode(m));
  }
}
