import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/brand_mark.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final sw = Stopwatch()..start();
    await ref.read(bootstrapProvider.future);
    const minSplash = Duration(milliseconds: 2400);
    final remaining = minSplash - sw.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (!mounted || _navigated) return;
    _navigated = true;
    final session = ref.read(sessionHolderProvider);
    if (session == null) {
      context.go('/login');
      return;
    }
    if (session.profile.onboardingComplete) {
      context.go('/home');
    } else {
      context.go('/onboarding/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentGold.withValues(alpha: 0.06),
              AppColors.scaffoldDark,
              AppColors.accentGold.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🪔', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const BrandMark(compact: false),
              const SizedBox(height: 12),
              Text(
                l10n.splashTagline,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondaryDark,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
