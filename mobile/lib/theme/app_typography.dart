import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  /// Typography aligned with `prototype.html` — DM Sans (UI) + Spectral (display).
  static TextTheme chromeTextTheme(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
    ).textTheme;
    final dm = GoogleFonts.dmSansTextTheme(base);
    return dm.copyWith(
      displayLarge: GoogleFonts.spectral(
        fontSize: 56,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.6,
        height: 1.0,
        color: scheme.onSurface,
      ),
      headlineMedium: GoogleFonts.spectral(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.4,
        height: 1.18,
        color: scheme.onSurface,
      ),
      headlineSmall: GoogleFonts.spectral(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
        height: 1.15,
        color: scheme.onSurface,
      ),
      titleLarge: GoogleFonts.spectral(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: -0.1,
        color: scheme.onSurface,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontWeight: FontWeight.w500,
        fontSize: 15,
        height: 1.45,
        color: scheme.onSurface,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontWeight: FontWeight.w500,
        fontSize: 13,
        height: 1.4,
        color: AppColors.protoInk3,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColors.protoInk3,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 2,
        color: AppColors.protoBrand,
      ),
    );
  }

  static TextTheme textTheme(ColorScheme scheme) {
    final onSurface = scheme.onSurface;
    final secondary = scheme.onSurface.withValues(alpha: 0.72);
    const serif = 'Georgia';
    const sans = 'sans-serif';

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: serif,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        color: onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: serif,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: serif,
        fontWeight: FontWeight.w800,
        fontSize: 22,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: sans,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: sans,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.45,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: sans,
        fontSize: 14,
        height: 1.4,
        color: secondary,
      ),
      bodySmall: TextStyle(
        fontFamily: sans,
        fontSize: 12,
        color: secondary.withValues(alpha: 0.85),
      ),
      labelLarge: TextStyle(
        fontFamily: sans,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        fontSize: 12,
        color: secondary,
      ),
    ).apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );
  }

  static TextStyle telugu(BuildContext context, TextStyle base) {
    return base.copyWith(
      fontFamily: 'Noto Serif Telugu',
      fontFamilyFallback: const [
        'Apple SD Gothic Neo',
        'sans-serif',
      ],
    );
  }
}
