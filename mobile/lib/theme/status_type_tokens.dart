import 'package:flutter/material.dart';

/// Backdrop behind the centered quote block (`type.scrim`).
enum LuxeScrimKind { none, soft, strong, paper }

/// Per-category typography + scrim — single source for hero / English echo (design spec).
@immutable
class StatusTypeTokens {
  const StatusTypeTokens({
    required this.heroColor,
    required this.heroWeight,
    required this.heroSize,
    required this.heroShadows,
    required this.subColor,
    required this.subWeight,
    this.subShadows,
    required this.scrimKind,
  });

  final Color heroColor;
  final FontWeight heroWeight;

  /// Logical px at export width 360.
  final double heroSize;
  final List<Shadow> heroShadows;
  final Color subColor;
  final FontWeight subWeight;
  final List<Shadow>? subShadows;
  final LuxeScrimKind scrimKind;

  static String _norm(String category) {
    switch (category) {
      case 'calm':
        return 'goodnight';
      default:
        return category;
    }
  }

  static StatusTypeTokens forCategory(String category) {
    switch (_norm(category)) {
      case 'goodmorning':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFF6DC),
          heroWeight: FontWeight.w700,
          heroSize: 27,
          heroShadows: _goodmorningHero,
          subColor: Color(0xFFFFEFC6),
          subWeight: FontWeight.w500,
          subShadows: null,
          scrimKind: LuxeScrimKind.soft,
        );
      case 'goodnight':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFF8E8),
          heroWeight: FontWeight.w600,
          heroSize: 26,
          heroShadows: _goodnightHero,
          subColor: Color(0xFFE5D5FF),
          subWeight: FontWeight.w400,
          subShadows: null,
          scrimKind: LuxeScrimKind.none,
        );
      case 'love':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFF6F1),
          heroWeight: FontWeight.w700,
          heroSize: 26,
          heroShadows: _loveHero,
          subColor: Color(0xFFFFE3EA),
          subWeight: FontWeight.w500,
          subShadows: null,
          scrimKind: LuxeScrimKind.soft,
        );
      case 'bhakti':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFE9A8),
          heroWeight: FontWeight.w700,
          heroSize: 27,
          heroShadows: _bhaktiHero,
          subColor: Color(0xFFFFE3B8),
          subWeight: FontWeight.w500,
          subShadows: null,
          scrimKind: LuxeScrimKind.soft,
        );
      case 'motivation':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFFFFF),
          heroWeight: FontWeight.w700,
          heroSize: 27,
          heroShadows: _motivationHero,
          subColor: Color(0xFFFFE9B8),
          subWeight: FontWeight.w500,
          subShadows: null,
          scrimKind: LuxeScrimKind.soft,
        );
      case 'festival':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFEFC6),
          heroWeight: FontWeight.w700,
          heroSize: 26,
          heroShadows: _festivalHero,
          subColor: Color(0xFFFFF1D6),
          subWeight: FontWeight.w600,
          subShadows: null,
          scrimKind: LuxeScrimKind.strong,
        );
      case 'family':
        return const StatusTypeTokens(
          heroColor: Color(0xFF2A0E04),
          heroWeight: FontWeight.w700,
          heroSize: 26,
          heroShadows: _familyHero,
          subColor: Color(0xFF5A2A12),
          subWeight: FontWeight.w500,
          subShadows: null,
          scrimKind: LuxeScrimKind.paper,
        );
      case 'cinema':
        return const StatusTypeTokens(
          heroColor: Color(0xFFF8D879),
          heroWeight: FontWeight.w700,
          heroSize: 28,
          heroShadows: _cinemaHero,
          subColor: Color(0xFFF5D06B),
          subWeight: FontWeight.w500,
          subShadows: null,
          scrimKind: LuxeScrimKind.none,
        );
      case 'heroes':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFE9B8),
          heroWeight: FontWeight.w800,
          heroSize: 27,
          heroShadows: _heroesHero,
          subColor: Color(0xFFFFE0B0),
          subWeight: FontWeight.w600,
          subShadows: null,
          scrimKind: LuxeScrimKind.soft,
        );
      case 'poetry':
        return const StatusTypeTokens(
          heroColor: Color(0xFF15201A),
          heroWeight: FontWeight.w700,
          heroSize: 26,
          heroShadows: _poetryHero,
          subColor: Color(0xFF2C3E36),
          subWeight: FontWeight.w500,
          subShadows: null,
          scrimKind: LuxeScrimKind.paper,
        );
      case 'friendship':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFF6DC),
          heroWeight: FontWeight.w700,
          heroSize: 26,
          heroShadows: _friendshipHero,
          subColor: Color(0xFFFFEFC6),
          subWeight: FontWeight.w600,
          subShadows: null,
          scrimKind: LuxeScrimKind.strong,
        );
      case 'birthday':
        return const StatusTypeTokens(
          heroColor: Color(0xFFFFF1F4),
          heroWeight: FontWeight.w700,
          heroSize: 26,
          heroShadows: _birthdayHero,
          subColor: Color(0xFFFFE3EA),
          subWeight: FontWeight.w600,
          subShadows: null,
          scrimKind: LuxeScrimKind.strong,
        );
      default:
        return _cinemaFallbackTokens;
    }
  }

  static const StatusTypeTokens _cinemaFallbackTokens = StatusTypeTokens(
    heroColor: Color(0xFFF8D879),
    heroWeight: FontWeight.w700,
    heroSize: 28,
    heroShadows: _cinemaHero,
    subColor: Color(0xFFF5D06B),
    subWeight: FontWeight.w500,
    subShadows: null,
    scrimKind: LuxeScrimKind.none,
  );
}

// --- Hero shadow stacks (CSS → Flutter Shadow: offset, blurRadius, color) ---

const List<Shadow> _goodmorningHero = [
  Shadow(
    offset: Offset(0, 1),
    blurRadius: 0,
    color: Color.fromRGBO(60, 18, 4, 0.6),
  ),
  Shadow(
    offset: Offset(0, 2),
    blurRadius: 18,
    color: Color.fromRGBO(255, 180, 80, 0.45),
  ),
];

const List<Shadow> _goodnightHero = [
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 22,
    color: Color.fromRGBO(184, 155, 255, 0.45),
  ),
  Shadow(
    offset: Offset(0, 1),
    blurRadius: 2,
    color: Color.fromRGBO(10, 4, 30, 0.7),
  ),
];

const List<Shadow> _loveHero = [
  Shadow(
    offset: Offset(0, 1),
    blurRadius: 1,
    color: Color.fromRGBO(60, 8, 30, 0.7),
  ),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 22,
    color: Color.fromRGBO(255, 140, 170, 0.5),
  ),
];

const List<Shadow> _bhaktiHero = [
  Shadow(
    offset: Offset(0, 1),
    blurRadius: 0,
    color: Color.fromRGBO(60, 8, 4, 0.85),
  ),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 26,
    color: Color.fromRGBO(245, 208, 107, 0.55),
  ),
  Shadow(
    offset: Offset(0, 2),
    blurRadius: 4,
    color: Color.fromRGBO(60, 8, 4, 0.6),
  ),
];

const List<Shadow> _motivationHero = [
  Shadow(
    offset: Offset(0, 2),
    blurRadius: 0,
    color: Color.fromRGBO(0, 30, 40, 0.7),
  ),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 28,
    color: Color.fromRGBO(242, 199, 110, 0.55),
  ),
  Shadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color.fromRGBO(0, 20, 30, 0.55),
  ),
];

const List<Shadow> _festivalHero = [
  Shadow(
    offset: Offset(0, 2),
    blurRadius: 0,
    color: Color.fromRGBO(50, 4, 2, 0.85),
  ),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 24,
    color: Color.fromRGBO(245, 208, 107, 0.6),
  ),
  Shadow(
    offset: Offset(0, 4),
    blurRadius: 14,
    color: Color.fromRGBO(50, 4, 2, 0.7),
  ),
];

const List<Shadow> _familyHero = [
  Shadow(
    offset: Offset(0, 1),
    blurRadius: 0,
    color: Color.fromRGBO(255, 235, 200, 0.6),
  ),
];

const List<Shadow> _cinemaHero = [
  Shadow(offset: Offset(0, 1), blurRadius: 0, color: Color(0xFF2A1A04)),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 24,
    color: Color.fromRGBO(212, 161, 42, 0.7),
  ),
  Shadow(
    offset: Offset(0, 3),
    blurRadius: 12,
    color: Color.fromRGBO(0, 0, 0, 0.7),
  ),
];

const List<Shadow> _heroesHero = [
  Shadow(
    offset: Offset(0, 2),
    blurRadius: 0,
    color: Color.fromRGBO(40, 2, 2, 0.95),
  ),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 28,
    color: Color.fromRGBO(244, 165, 71, 0.55),
  ),
  Shadow(
    offset: Offset(0, 4),
    blurRadius: 14,
    color: Color.fromRGBO(40, 2, 2, 0.7),
  ),
];

const List<Shadow> _poetryHero = [
  Shadow(
    offset: Offset(0, 1),
    blurRadius: 0,
    color: Color.fromRGBO(255, 250, 235, 0.45),
  ),
];

const List<Shadow> _friendshipHero = [
  Shadow(
    offset: Offset(0, 2),
    blurRadius: 0,
    color: Color.fromRGBO(20, 40, 30, 0.85),
  ),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 24,
    color: Color.fromRGBO(245, 208, 107, 0.5),
  ),
  Shadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color.fromRGBO(20, 40, 30, 0.65),
  ),
];

const List<Shadow> _birthdayHero = [
  Shadow(
    offset: Offset(0, 2),
    blurRadius: 0,
    color: Color.fromRGBO(60, 8, 30, 0.85),
  ),
  Shadow(
    offset: Offset(0, 0),
    blurRadius: 24,
    color: Color.fromRGBO(245, 208, 107, 0.55),
  ),
  Shadow(
    offset: Offset(0, 4),
    blurRadius: 14,
    color: Color.fromRGBO(60, 8, 30, 0.65),
  ),
];
