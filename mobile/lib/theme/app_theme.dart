import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  /// Dark design system (Home / Explore / Profile + global Material).
  static ThemeData dark() {
    const accent = AppColors.accentGold;
    final scheme = ColorScheme.dark(
      primary: accent,
      onPrimary: AppColors.scaffoldDark,
      secondary: accent,
      onSecondary: AppColors.scaffoldDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceElevatedDark,
      error: AppColors.kumkum,
      onError: AppColors.textPrimaryDark,
      outline: AppColors.borderOnDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accent,
      scaffoldBackgroundColor: AppColors.scaffoldDark,
      cardColor: AppColors.surfaceDark,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme(scheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.scaffoldDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bottomNavDark,
        indicatorColor: AppColors.accentGoldSubtleBg,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          final selected = s.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? accent : Colors.white.withValues(alpha: 0.3),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          final selected = s.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? accent : Colors.white.withValues(alpha: 0.3),
            size: 22,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        disabledColor: AppColors.surfaceDark,
        selectedColor: AppColors.accentGoldSubtleBg,
        side: BorderSide(color: AppColors.borderOnDark),
        labelStyle: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
        secondaryLabelStyle: TextStyle(color: AppColors.textSecondaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        hintStyle: TextStyle(color: AppColors.textTertiaryDark),
        labelStyle: TextStyle(color: AppColors.textSecondaryDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.borderOnDarkStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.borderOnDarkStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accentGold, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: accent,
          foregroundColor: AppColors.scaffoldDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.surfaceElevatedDark,
          foregroundColor: AppColors.textPrimaryDark,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          foregroundColor: accent,
          side: const BorderSide(color: accent, width: 1.2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return accent;
          return AppColors.textTertiaryDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return accent.withValues(alpha: 0.35);
          return AppColors.surfaceElevatedDark;
        }),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.surfaceDark,
        textColor: AppColors.textPrimaryDark,
        iconColor: accent,
      ),
      dividerTheme: DividerThemeData(color: AppColors.borderOnDark, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        contentTextStyle: const TextStyle(color: AppColors.textPrimaryDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  /// Kept for reference; app uses [dark] only.
  static ThemeData light() => dark();

  /// Light cream shell matching `prototype.html` (onboarding, tabs, home chrome).
  static ThemeData chrome() {
    const brand = AppColors.protoBrand;
    final scheme = ColorScheme.light(
      primary: brand,
      onPrimary: Colors.white,
      secondary: AppColors.protoSaffron,
      onSecondary: AppColors.protoInk,
      surface: AppColors.protoSurface,
      onSurface: AppColors.protoInk,
      surfaceContainerHighest: AppColors.protoSurfaceAlt,
      outline: AppColors.protoBorder,
      outlineVariant: AppColors.protoDivider,
      error: AppColors.kumkum,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: brand,
      scaffoldBackgroundColor: AppColors.protoCream,
      cardColor: AppColors.protoSurface,
      colorScheme: scheme,
      textTheme: AppTypography.chromeTextTheme(scheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.protoCream,
        foregroundColor: AppColors.protoInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          letterSpacing: -0.2,
          color: AppColors.protoInk,
        ),
        iconTheme: const IconThemeData(color: AppColors.protoInk),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.protoSurface,
        indicatorColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black12,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          final selected = s.contains(WidgetState.selected);
          return GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.1,
            color: selected ? brand : AppColors.protoTabIdle,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          final selected = s.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? brand : AppColors.protoTabIdle,
            size: 24,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: brand.withValues(alpha: 0.28),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: brand,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFD7C9B6),
          textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: -0.1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.protoSurface,
          foregroundColor: AppColors.protoInk,
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.protoDivider, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.protoInk,
        contentTextStyle: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
