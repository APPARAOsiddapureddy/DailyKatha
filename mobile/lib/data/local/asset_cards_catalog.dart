import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/katha_card.dart';

/// Loads [KathaCard] lists from bundled JSON (see `scripts/export_language_catalogs.py`).
abstract final class AssetCardsCatalog {
  static Future<List<KathaCard>> load(String assetPath) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
