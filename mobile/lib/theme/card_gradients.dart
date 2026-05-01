import 'package:flutter/material.dart';

/// Mood → gradient surfaces (PRD `getCardBg` mapping).
abstract final class CardGradients {
  static CardPalette paletteFor(String mood) {
    return switch (mood) {
      'devotional' => const CardPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD63A2E), Color(0xFFB3261E), Color(0xFF7A1410)],
          ),
          accent: Color(0xFFF5D06B),
          ink: Color(0xFFFFF8DE),
        ),
      'bold' => const CardPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8D4A8), Color(0xFFC89B3C), Color(0xFF7A5F24)],
          ),
          accent: Color(0xFFFFF3D4),
          ink: Color(0xFF2A1505),
        ),
      'festive' => const CardPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC89B3C), Color(0xFFB3261E), Color(0xFF4A0E0A)],
          ),
          accent: Color(0xFFF5D06B),
          ink: Color(0xFFFFF8DE),
        ),
      'calm' => const CardPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3A3380), Color(0xFF2A2566), Color(0xFF0F0B2E)],
          ),
          accent: Color(0xFFF5D06B),
          ink: Color(0xFFFFF8DE),
        ),
      'romantic' => const CardPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE54D64), Color(0xFFB3261E), Color(0xFF6A0F1C)],
          ),
          accent: Color(0xFFFFDCC8),
          ink: Color(0xFFFFF8DE),
        ),
      'cool' => const CardPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1D8A7A), Color(0xFF0F6E5E), Color(0xFF053A31)],
          ),
          accent: Color(0xFFF5D06B),
          ink: Color(0xFFFFF8DE),
        ),
      _ => const CardPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5D06B), Color(0xFFC89B3C), Color(0xFF8A6A2F)],
          ),
          accent: Color(0xFFFFE8B8),
          ink: Color(0xFF2A1505),
        ),
    };
  }
}

@immutable
class CardPalette {
  const CardPalette({
    required this.gradient,
    required this.accent,
    required this.ink,
  });

  final Gradient gradient;
  final Color accent;
  final Color ink;
}
