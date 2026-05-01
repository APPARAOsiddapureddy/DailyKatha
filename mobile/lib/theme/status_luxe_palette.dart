import 'package:flutter/material.dart';

import '../l10n/genre_localizer.dart';

/// Dark editorial card look (reference: luxe HTML card) — colours per interest.
@immutable
class StatusLuxePalette {
  const StatusLuxePalette({
    required this.accent,
    required this.bg0,
    required this.bg1,
    required this.bg2,
    required this.radialA,
    required this.radialB,
  });

  final Color accent;
  final Color bg0;
  final Color bg1;
  final Color bg2;
  final Color radialA;
  final Color radialB;

  /// Cream hero / echo tints (HTML #f5e6c0 family).
  static const Color heroCream = Color(0xFFF5E6C0);
  static const Color echoCream = Color(0x8CF5E6C0);

  static StatusLuxePalette forCategory(String category) {
    switch (category) {
      case 'bhakti':
        return const StatusLuxePalette(
          accent: Color(0xFFE07840),
          bg0: Color(0xFF180F08),
          bg1: Color(0xFF0D0804),
          bg2: Color(0xFF140A06),
          radialA: Color(0x29C86428),
          radialB: Color(0x1E904020),
        );
      case 'love':
        return const StatusLuxePalette(
          accent: Color(0xFFD4607C),
          bg0: Color(0xFF180A10),
          bg1: Color(0xFF0E0608),
          bg2: Color(0xFF120810),
          radialA: Color(0x28C85078),
          radialB: Color(0x18A04060),
        );
      case 'friendship':
        return const StatusLuxePalette(
          accent: Color(0xFFD08030),
          bg0: Color(0xFF181008),
          bg1: Color(0xFF0E0A04),
          bg2: Color(0xFF120C06),
          radialA: Color(0x28B07020),
          radialB: Color(0x1CA05618),
        );
      case 'motivation':
        return const StatusLuxePalette(
          accent: Color(0xFF5AAB70),
          bg0: Color(0xFF061410),
          bg1: Color(0xFF030B06),
          bg2: Color(0xFF081208),
          radialA: Color(0x243CA050),
          radialB: Color(0x18207040),
        );
      case 'goodmorning':
        return const StatusLuxePalette(
          accent: Color(0xFFE0A030),
          bg0: Color(0xFF16120A),
          bg1: Color(0xFF0C0906),
          bg2: Color(0xFF100C08),
          radialA: Color(0x28C8961E),
          radialB: Color(0x1E886010),
        );
      case 'poetry':
        return const StatusLuxePalette(
          accent: Color(0xFF7070C8),
          bg0: Color(0xFF0C0C18),
          bg1: Color(0xFF060610),
          bg2: Color(0xFF0A0814),
          radialA: Color(0x246464C8),
          radialB: Color(0x18404090),
        );
      case 'goodnight':
      case 'calm':
        return const StatusLuxePalette(
          accent: Color(0xFF8878D0),
          bg0: Color(0xFF0C0C18),
          bg1: Color(0xFF060610),
          bg2: Color(0xFF0A0814),
          radialA: Color(0x226050C0),
          radialB: Color(0x18304090),
        );
      case 'festival':
        return const StatusLuxePalette(
          accent: Color(0xFFE0B040),
          bg0: Color(0xFF181208),
          bg1: Color(0xFF0E0B04),
          bg2: Color(0xFF140C06),
          radialA: Color(0x30D07820),
          radialB: Color(0x20A05018),
        );
      case 'birthday':
        return const StatusLuxePalette(
          accent: Color(0xFFC860C0),
          bg0: Color(0xFF180818),
          bg1: Color(0xFF100510),
          bg2: Color(0xFF140A12),
          radialA: Color(0x30C040B8),
          radialB: Color(0x20803090),
        );
      case 'family':
        return const StatusLuxePalette(
          accent: Color(0xFFA070C8),
          bg0: Color(0xFF120A18),
          bg1: Color(0xFF0A0610),
          bg2: Color(0xFF100814),
          radialA: Color(0x2A8040C0),
          radialB: Color(0x1C503080),
        );
      case 'heroes':
        return const StatusLuxePalette(
          accent: Color(0xFF4090C8),
          bg0: Color(0xFF080C18),
          bg1: Color(0xFF040810),
          bg2: Color(0xFF0A1018),
          radialA: Color(0x283090C8),
          radialB: Color(0x18206090),
        );
      case 'cinema':
      default:
        return const StatusLuxePalette(
          accent: Color(0xFFC89B3C),
          bg0: Color(0xFF1A1208),
          bg1: Color(0xFF0E0B04),
          bg2: Color(0xFF141008),
          radialA: Color(0x2EB47828),
          radialB: Color(0x1FC88C32),
        );
    }
  }

  /// Short pill label per content language (see [GenreLocalizer]).
  static String pillLabel(String category, String contentLanguage) {
    return GenreLocalizer.getName(category, contentLanguage);
  }
}
