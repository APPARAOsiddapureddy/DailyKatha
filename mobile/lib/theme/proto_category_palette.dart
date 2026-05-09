import 'package:flutter/material.dart';

/// Matches `tokens.js` → `DK.cat` (prototype quote-card category backgrounds).
abstract final class ProtoCategoryPalette {
  static Color bg(String category) {
    return switch (category) {
      'bhakti' => const Color(0xFF5B1A1A),
      'love' => const Color(0xFF7A2540),
      'motivation' => const Color(0xFF1B2D44),
      'festival' => const Color(0xFF7E1F0E),
      'goodmorning' => const Color(0xFFC66829),
      'goodnight' => const Color(0xFF1F2848),
      'friendship' => const Color(0xFF2C5F4A),
      'family' => const Color(0xFF5B3220),
      'poetry' => const Color(0xFF3A2548),
      'birthday' => const Color(0xFFA93757),
      'cinema' => const Color(0xFF1B2D44),
      'heroes' => const Color(0xFF2A2566),
      _ => const Color(0xFF1A1410),
    };
  }
}
