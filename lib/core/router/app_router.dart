import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_paths.dart';
import '../providers/auth_provider.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/shell/main_shell_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/events/screens/features_screen.dart';
import '../../features/events/screens/create_event_screen.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/community/screens/group_profile_screen.dart';
import '../../features/polls/screens/create_poll_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/edit_username_screen.dart';
import '../../features/settings/screens/notifications_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Exposed as a provider listening to `authStateProvider` with a `redirect:`
/// that bounces signed-out users to /login and signed-in users away from auth screens.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/${RoutePaths.splash}',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authValue = authAsync.value;
      final isAuthenticated = authValue != null;

      final location = state.matchedLocation;
      final isAuthOrSplashRoute = location == '/${RoutePaths.splash}' ||
          location == '/${RoutePaths.onboarding}' ||
          location == '/${RoutePaths.login}' ||
          location == '/${RoutePaths.signUp}' ||
          location == '/${RoutePaths.forgotPassword}';

      if (isAuthenticated && isAuthOrSplashRoute && location != '/${RoutePaths.splash}') {
        return '/${RoutePaths.home}';
      }

      if (!isAuthenticated && !isAuthOrSplashRoute) {
        return '/${RoutePaths.login}';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/${RoutePaths.splash}',
        name: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/${RoutePaths.onboarding}',
        name: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/${RoutePaths.signUp}',
        name: RoutePaths.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/${RoutePaths.login}',
        name: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${RoutePaths.forgotPassword}',
        name: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/${RoutePaths.home}',
              name: RoutePaths.home,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: RoutePaths.createEvent,
                  name: RoutePaths.createEvent,
                  builder: (context, state) => const CreateEventScreen(),
                ),
                GoRoute(
                  path: '${RoutePaths.eventDetail}/:eventId',
                  name: RoutePaths.eventDetail,
                  builder: (context, state) => EventDetailScreen(
                    eventId: state.pathParameters['eventId']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/${RoutePaths.features}',
              name: RoutePaths.features,
              builder: (context, state) => const FeaturesScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/${RoutePaths.community}',
              name: RoutePaths.community,
              builder: (context, state) => const CommunityScreen(),
              routes: [
                GoRoute(
                  path: RoutePaths.createPoll,
                  name: RoutePaths.createPoll,
                  builder: (context, state) => const CreatePollScreen(),
                ),
                GoRoute(
                  path: '${RoutePaths.groupProfile}/:groupId',
                  name: RoutePaths.groupProfile,
                  builder: (context, state) => GroupProfileScreen(
                    groupId: state.pathParameters['groupId']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/${RoutePaths.favorites}',
              name: RoutePaths.favorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/${RoutePaths.settings}',
              name: RoutePaths.settings,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: RoutePaths.editUsername,
                  name: RoutePaths.editUsername,
                  builder: (context, state) => const EditUsernameScreen(),
                ),
                GoRoute(
                  path: RoutePaths.notifications,
                  name: RoutePaths.notifications,
                  builder: (context, state) => const NotificationsScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
