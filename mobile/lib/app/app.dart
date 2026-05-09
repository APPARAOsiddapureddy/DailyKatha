import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/flavor_config.dart';
import '../core/content_language.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'router.dart';

class DailyKathaApp extends ConsumerWidget {
  const DailyKathaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final session = ref.watch(sessionHolderProvider);
    return MaterialApp.router(
      title: FlavorConfig.appLabel,
      theme: AppTheme.chrome(),
      // Same tokens as light shell so system / OEM night mode never falls back to a dark Material theme.
      darkTheme: AppTheme.chrome(),
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: effectiveAppLocale(session),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.protoSurface,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: AppColors.protoDivider,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
