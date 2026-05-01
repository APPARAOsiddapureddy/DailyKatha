import 'package:flutter/material.dart';

abstract final class AppTypography {
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
