import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/flavor_config.dart';
import '../core/content_language.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
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
      theme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: effectiveAppLocale(session),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
