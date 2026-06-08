import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/safe_nav.dart';

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

  /// Only navigate to routes GoRouter knows about (strip query params from reminders).
  String? _normalizePendingRoute(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final path = Uri.tryParse(raw.trim())?.path ?? raw.trim();
    const allowed = {
      '/home',
      '/explore',
      '/profile',
      '/feed',
      '/login',
      '/onboarding/language',
    };
    return allowed.contains(path) ? path : null;
  }

  Future<void> _run() async {
    final sw = Stopwatch()..start();
    try {
      await ref.read(bootstrapProvider.future).timeout(const Duration(seconds: 10));
    } catch (e, st) {
      debugPrint('Splash bootstrap failed, continuing to login/home: $e\n$st');
    }
    const minSplash = Duration(milliseconds: 1650);
    final remaining = minSplash - sw.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (!mounted || _navigated) return;
    _navigated = true;

    // Notification deep-link: if user opened the app from a reminder, route there first.
    final pending = _normalizePendingRoute(
      await ref.read(notificationServiceProvider).consumePendingRoute(),
    );
    if (!mounted) return;
    if (pending != null) {
      await ref.read(analyticsProvider).log(
        AEvents.notificationOpened,
        props: {'route': pending},
      );
      if (!mounted) return;
      safeGo(context, pending);
      return;
    }

    final session = ref.read(sessionHolderProvider);
    if (!mounted) return;
    if (session?.profile.onboardingComplete == true) {
      safeGo(context, '/home');
    } else if (session != null) {
      safeGo(context, '/onboarding/language');
    } else {
      safeGo(context, '/login');
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
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 52,
                                color: Colors.white,
                                letterSpacing: -0.6,
                              ),
                        ),
                        TextSpan(
                          text: 'Katha',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 52,
                                color: AppColors.protoSaffron,
                                letterSpacing: -0.6,
                              ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.splashTagline.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12,
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
