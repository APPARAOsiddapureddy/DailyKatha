import 'package:flutter/material.dart';

import '../l10n/genre_localizer.dart';

/// Visual frame / chrome for status cards — aligned with `themes.jsx` + `card.jsx` (THEMES + palette).
/// Per-theme typography (hero, echo, scrim) lives in `status_type_tokens.dart`.
@immutable
class StatusLuxePalette {
  const StatusLuxePalette({
    required this.chipLabel,
    required this.accent,
    required this.frame,
    required this.centerGlyph,
    required this.cornerEmoji,
  });

  /// Genre pill text on the glass chip (readable on frosted bar).
  final Color chipLabel;

  /// Accent dots, center-glyph strokes, footer diamonds (`palette.accent`).
  final Color accent;

  /// Dashed frames, paisley corners, pill borders (`palette.frame`).
  final Color frame;

  /// Ornament above hero (`CenterGlyph` in `card.jsx`).
  final LuxeCenterGlyphKind centerGlyph;

  /// Top-right badge character (`theme.icon` in JSX).
  final String cornerEmoji;

  static String _normalizedCategory(String category) {
    switch (category) {
      case 'calm':
        return 'goodnight';
      default:
        return category;
    }
  }

  static const StatusLuxePalette _cinemaFallback = StatusLuxePalette(
    chipLabel: Color(0xFFFFFCF3),
    accent: Color(0xFFD4A12A),
    frame: Color(0xFFD4A12A),
    centerGlyph: LuxeCenterGlyphKind.reel,
    cornerEmoji: '▶',
  );

  static StatusLuxePalette forCategory(String category) {
    switch (_normalizedCategory(category)) {
      case 'goodmorning':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFF5D06B),
          frame: Color(0xFFFFD78A),
          centerGlyph: LuxeCenterGlyphKind.sun,
          cornerEmoji: '☀',
        );
      case 'goodnight':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFB89BFF),
          frame: Color(0xFF9C7CE0),
          centerGlyph: LuxeCenterGlyphKind.lotus,
          cornerEmoji: '☾',
        );
      case 'love':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFFFB8C9),
          frame: Color(0xFFFF96AE),
          centerGlyph: LuxeCenterGlyphKind.heart,
          cornerEmoji: '❤',
        );
      case 'bhakti':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFF5DC),
          accent: Color(0xFFF5D06B),
          frame: Color(0xFFFFC066),
          centerGlyph: LuxeCenterGlyphKind.om,
          cornerEmoji: 'ॐ',
        );
      case 'motivation':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFF2C76E),
          frame: Color(0xFF7FB8A8),
          centerGlyph: LuxeCenterGlyphKind.peak,
          cornerEmoji: '↑',
        );
      case 'festival':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFF5D06B),
          frame: Color(0xFFFFC066),
          centerGlyph: LuxeCenterGlyphKind.diya,
          cornerEmoji: '✦',
        );
      case 'family':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFBF5),
          accent: Color(0xFFB94E11),
          frame: Color(0xFF8E3E18),
          centerGlyph: LuxeCenterGlyphKind.home,
          cornerEmoji: '⌂',
        );
      case 'cinema':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFD4A12A),
          frame: Color(0xFFD4A12A),
          centerGlyph: LuxeCenterGlyphKind.reel,
          cornerEmoji: '▶',
        );
      case 'heroes':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFF5D06B),
          frame: Color(0xFFF4A547),
          centerGlyph: LuxeCenterGlyphKind.sword,
          cornerEmoji: '⚔',
        );
      case 'poetry':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFF5F7F3),
          accent: Color(0xFF7A8E66),
          frame: Color(0xFF5C7062),
          centerGlyph: LuxeCenterGlyphKind.quill,
          cornerEmoji: '✒',
        );
      case 'friendship':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFF5D06B),
          frame: Color(0xFFF2C76E),
          centerGlyph: LuxeCenterGlyphKind.leaf,
          cornerEmoji: '✿',
        );
      case 'birthday':
        return const StatusLuxePalette(
          chipLabel: Color(0xFFFFFCF3),
          accent: Color(0xFFF5D06B),
          frame: Color(0xFFFFB8C9),
          centerGlyph: LuxeCenterGlyphKind.candle,
          cornerEmoji: '✦',
        );
      default:
        return _cinemaFallback;
    }
  }

  /// Short pill label per content language (see [GenreLocalizer]).
  static String pillLabel(String category, String contentLanguage) {
    return GenreLocalizer.getName(category, contentLanguage);
  }
}

/// Matches `centerGlyph` strings in `card.jsx` / `themes.jsx`.
enum LuxeCenterGlyphKind {
  lotus,
  sun,
  heart,
  om,
  peak,
  diya,
  home,
  reel,
  sword,
  quill,
  leaf,
  candle,
}
