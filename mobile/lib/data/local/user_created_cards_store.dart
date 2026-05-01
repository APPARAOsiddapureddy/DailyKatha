import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/katha_card.dart';

/// Persists user-created cards locally for retention/testing.
///
/// Stored as JSON array in SharedPreferences.
abstract final class UserCreatedCardsStore {
  static const String _k = 'dk_user_created_cards_v1';

  static Future<List<KathaCard>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_k);
      if (raw == null || raw.trim().isEmpty) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<dynamic, dynamic>>()
          .map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e)))
          .where((c) => c.id.isNotEmpty)
          .toList(growable: false);
    } catch (e) {
      debugPrint('UserCreatedCardsStore.load failed: $e');
      return const [];
    }
  }

  static Future<void> saveAll(List<KathaCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(cards.map((c) => c.toJson()).toList(growable: false));
    await prefs.setString(_k, payload);
  }

  static Future<void> add(KathaCard card) async {
    final existing = await load();
    final next = [card, ...existing];
    await saveAll(next);
  }
}

