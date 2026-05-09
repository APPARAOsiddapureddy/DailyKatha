import 'package:flutter/material.dart';

/// Brand palette (PRD) + **dark UI tokens** (viewer-aligned).
abstract final class AppColors {
  // —— Legacy / print warm tones (cards, illustrations) ——
  static const Color cream = Color(0xFFFBF4E6);
  static const Color creamDeep = Color(0xFFF2E7CE);
  static const Color ink = Color(0xFF1F1410);
  static const Color inkSoft = Color(0xFF5A3E2A);
  static const Color inkMute = Color(0xFF8A6F56);

  /// Primary UI accent — **gold** (replaces orange #F97316 / marigold in chrome).
  static const Color accentGold = Color(0xFFC89B3C);
  static const Color accentGoldSubtleBg = Color(0x1FC89B3C); // rgba(200,155,60,0.12)
  static const Color accentGoldBorder = Color(0x40C89B3C); // rgba(200,155,60,0.25)

  /// Kept as aliases → gold for backward compatibility in gradients not yet migrated.
  static const Color marigold = accentGold;
  static const Color marigoldDeep = Color(0xFF9A7530);
  static const Color marigoldLight = Color(0xFFE0C47A);

  static const Color kumkum = Color(0xFFB3261E);
  static const Color kumkumDeep = Color(0xFF7A1410);

  static const Color gold = accentGold;
  static const Color goldDeep = Color(0xFF9B7213);
  static const Color goldLight = Color(0xFFF5D06B);

  static const Color peacock = Color(0xFF0F6E5E);
  static const Color peacockDeep = Color(0xFF084E42);

  static const Color indigo = Color(0xFF2A2566);
  static const Color indigoDeep = Color(0xFF181445);

  static const Color white = Color(0xFFFFFCF3);

  // —— Dark shell tokens ——
  /// Softer charcoal (less “pure black”) for better readability.
  static const Color scaffoldDark = Color(0xFF0B0F14);
  static const Color surfaceDark = Color(0xFF111823);
  static const Color surfaceElevatedDark = Color(0xFF17202C);
  static const Color bottomNavDark = Color(0xFF0D131B);

  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  /// ~50% white on dark (for const contexts).
  static const Color textSecondaryDark = Color(0x80FFFFFF);
  /// ~28% white on dark.
  static const Color textTertiaryDark = Color(0x47FFFFFF);
  static const Color borderOnDark = Color(0x14FFFFFF);
  static const Color borderOnDarkStrong = Color(0x1AFFFFFF);

  static Color line(BuildContext context) => ink.withValues(alpha: 0.12);
  static Color lineStrong(BuildContext context) => ink.withValues(alpha: 0.22);

  /// Feed / editor dark canvas — matches `screens-feed.jsx` (`#0A0807`).
  static const Color feedScaffold = Color(0xFF0A0807);

  // —— Prototype.html “chrome” (light cream app shell) ——
  static const Color protoCream = Color(0xFFFBF6EC);
  static const Color protoSurface = Color(0xFFFFFFFF);
  static const Color protoSurfaceAlt = Color(0xFFF4ECDD);
  static const Color protoBorder = Color(0xFFE8DFD0);
  static const Color protoDivider = Color(0xFFEDE3D2);
  static const Color protoInk = Color(0xFF1A1410);
  static const Color protoInk2 = Color(0xFF4A3F36);
  static const Color protoInk3 = Color(0xFF8A7C6E);
  static const Color protoInk4 = Color(0xFFB4A696);
  static const Color protoBrand = Color(0xFFB33A20);
  /// ~12% alpha brand (chips / selections on cream).
  static const Color protoBrand12 = Color(0x1FB33A20);
  static const Color protoBrandOutline25 = Color(0x40B33A20);
  /// Matches `tokens.js` brandDeep (splash / deep brand).
  static const Color protoBrandDeep = Color(0xFF7E1F0E);
  static const Color protoSaffron = Color(0xFFE89B2C);
  static const Color protoTabIdle = Color(0xFF8A7C6E);
}
