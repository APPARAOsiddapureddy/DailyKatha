import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../theme/app_colors.dart';

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
    const minSplash = Duration(milliseconds: 1650);
    final remaining = minSplash - sw.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (!mounted || _navigated) return;
    _navigated = true;

    // Notification deep-link: if user opened the app from a reminder, route there first.
    final pending = await ref.read(notificationServiceProvider).consumePendingRoute();
    if (!mounted) return;
    if (pending != null) {
      await ref.read(analyticsProvider).log(
        AEvents.notificationOpened,
        props: {'route': pending},
      );
      // ignore: use_build_context_synchronously
      context.go(pending);
      return;
    }

    final session = ref.read(sessionHolderProvider);
    if (session?.profile.onboardingComplete == true) {
      // ignore: use_build_context_synchronously
      context.go('/home');
    } else {
      // ignore: use_build_context_synchronously
      context.go('/onboarding/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.protoBrandDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.35),
                radius: 1.15,
                colors: [
                  Color.lerp(AppColors.protoSaffron, Colors.white, 0.12)!.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.protoSaffron,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.protoSaffron.withValues(alpha: 0.65),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.protoSaffron.withValues(alpha: 0.35),
                          blurRadius: 48,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Daily ',
                          style: GoogleFonts.spectral(
                            fontSize: 52,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.6,
                            height: 1.0,
                          ),
                        ),
                        TextSpan(
                          text: 'Katha',
                          style: GoogleFonts.spectral(
                            fontSize: 52,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: AppColors.protoSaffron,
                            letterSpacing: -0.6,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.splashTagline.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                      color: Colors.white.withValues(alpha: 0.58),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
