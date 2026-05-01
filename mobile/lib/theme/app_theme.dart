import 'package:flutter/material.dart';

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
}
