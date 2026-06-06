import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/admin/admin_generate_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/create/create_card_screen.dart';
import '../features/editor/card_editor_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/section_preview_screen.dart';
import '../features/onboarding/interests_screen.dart';
import '../features/onboarding/language_screen.dart';
import '../features/onboarding/religion_screen.dart';
import '../features/profile/edit_interests_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/daily_reminder_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/today_picks/today_picks_screen.dart';
import '../models/card_editor_args.dart';
import '../models/feed_route_args.dart';
import '../models/onboarding_args.dart';
import '../models/otp_route_args.dart';
import '../models/section_preview_args.dart';
import '../models/user_profile.dart';
import '../widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final _routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier();
  ref.listen<UserSession?>(
    sessionHolderProvider,
    (UserSession? previous, UserSession? next) => notifier.refresh(),
  );
  ref.listen<AsyncValue<UserSession?>>(
    bootstrapProvider,
    (AsyncValue<UserSession?>? previous, AsyncValue<UserSession?> next) => notifier.refresh(),
  );
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Bridges Riverpod state to [GoRouter.refreshListenable].
class RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

String? _redirectLogic(Ref ref, GoRouterState state) {
  final path = state.matchedLocation;
  final bootstrap = ref.read(bootstrapProvider);
  final session = ref.read(sessionHolderProvider);

  if (bootstrap.isLoading) {
    const loadingAllowed = {
      '/splash',
      '/login',
      '/otp',
      '/onboarding/language',
      '/onboarding/religion',
      '/onboarding/interests',
      '/home',
      '/explore',
      '/profile',
    };
    if (!loadingAllowed.contains(path)) {
      return '/splash';
    }
    return null;
  }

  final isAuth = session != null;
  final done = session?.profile.onboardingComplete ?? false;
  final isAdmin = session?.profile.isAdmin ?? false;

  const onboardingPaths = <String>{
    '/onboarding/language',
    '/onboarding/religion',
    '/onboarding/interests',
  };

  if (path == '/login' || path == '/otp') {
    return isAuth ? (done ? '/home' : '/onboarding/language') : null;
  }

  if (isAuth && done && onboardingPaths.contains(path)) {
    return '/home';
  }

  if (isAuth && !done) {
    const mainPaths = {'/home', '/explore', '/profile', '/feed'};
    if (mainPaths.contains(path)) {
      return '/onboarding/language';
    }
  }

  if (path.startsWith('/admin')) {
    if (!isAuth) return '/onboarding/language';
    if (!isAdmin) return '/home';
  }

  if (!isAuth && {'/home', '/explore', '/profile', '/feed', '/onboarding/language', '/onboarding/religion', '/onboarding/interests'}.contains(path)) {
    return '/login';
  }

  return null;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) => _redirectLogic(ref, state),
    errorBuilder: (context, state) {
      return Scaffold(
        backgroundColor: const Color(0xFF080808),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Color(0xFFC89B3C), size: 48),
                const SizedBox(height: 16),
                Text(
                  'Page not found: ${state.uri}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/splash'),
                  child: const Text('Restart'),
                ),
              ],
            ),
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final args = state.extra as OtpRouteArgs;
          return OtpScreen(args: args);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/admin/generate',
        builder: (context, state) => const AdminGenerateScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/today-picks',
        builder: (context, state) => const TodayPicksScreen(),
      ),
      GoRoute(
        path: '/onboarding/language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/onboarding/religion',
        builder: (context, state) {
          final lang = state.extra as String? ?? 'en';
          return ReligionScreen(uiLanguage: lang);
        },
      ),
      GoRoute(
        path: '/onboarding/interests',
        builder: (context, state) {
          final args = state.extra as OnboardingArgs? ?? const OnboardingArgs(contentLanguage: 'en');
          return InterestsScreen(args: args);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/create',
        builder: (context, state) => const CreateCardScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                pageBuilder: (context, state) => const NoTransitionPage(child: ExploreScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/feed',
        builder: (context, state) {
          final ex = state.extra;
          final args = ex is FeedRouteArgs ? ex : FeedRouteArgs(initialIndex: ex is int ? ex : 0);
          return FeedScreen(args: args);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/section',
        builder: (context, state) {
          final args = state.extra as SectionPreviewArgs;
          return SectionPreviewScreen(args: args);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/edit',
        builder: (context, state) {
          final args = state.extra as CardEditorArgs;
          return CardEditorScreen(args: args, shareService: ref.read(shareServiceProvider));
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile/interests',
        builder: (context, state) => const EditInterestsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/reminder',
        builder: (context, state) => const DailyReminderScreen(),
      ),
    ],
  );
});
