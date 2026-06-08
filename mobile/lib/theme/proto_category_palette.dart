import 'package:flutter/material.dart';

/// Matches `tokens.js` → `DK.cat` (prototype quote-card category backgrounds).
abstract final class ProtoCategoryPalette {
  static Color bg(String category) {
    return switch (category) {
      'mahabharata' => const Color(0xFF5B3220),
      'ramayana' => const Color(0xFF7E1F0E),
      'shiv_puran' => const Color(0xFF3A2548),
      'bhagavad_gita' => const Color(0xFFC66829),
      'hanuman' => const Color(0xFFB94E11),
      'krishna_leela' => const Color(0xFF7A2540),
      'devi_mahatmya' => const Color(0xFFB33A20),
      'vedic_wisdom' => const Color(0xFF5C7062),
      'upanishads' => const Color(0xFF3A2548),
      'puranas' => const Color(0xFFC66829),
      'ancient_history' => const Color(0xFF463520),
      'saints_sages' => const Color(0xFF5C7062),
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
