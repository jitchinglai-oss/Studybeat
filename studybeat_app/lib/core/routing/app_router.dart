import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/welcome_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/focus/focus_mode_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/session/create_session_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/stats/stats_screen.dart';
import '../../widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatsScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/session/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateSessionScreen(),
      ),
      GoRoute(
        path: '/focus/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FocusModeScreen(sessionId: id);
        },
      ),
    ],
    redirect: (context, state) {
      // Entry flow is handled by Welcome / Onboarding screens.
      return null;
    },
  );
});
