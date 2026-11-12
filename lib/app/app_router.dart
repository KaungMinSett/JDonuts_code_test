import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_providers.dart';
import '../auth/domain/auth_repository.dart';
import '../auth/presentation/onboarding_screen.dart';
import '../auth/presentation/screens/date_of_birth_screen.dart';
import '../auth/presentation/screens/name_screen.dart';
import '../auth/presentation/screens/otp_screen.dart';
import '../auth/presentation/screens/phone_number_screen.dart';
import '../auth/presentation/screens/welcome_screen.dart';
import '../core/domain/result.dart';
import '../home/presentation/home_screen.dart';
import '../product/presentation/product_detail_screen.dart';
import '../rewards/presentation/rewards_screen.dart';
import '../settings/presentation/settings_screen.dart';
import 'widgets/app_bottom_navigation_bar.dart';

({String normalizedPhone, bool isLogin})? _otpArguments(Object? extra) {
  if (extra case {
    'normalizedPhone': final String phone,
    'isLogin': final bool isLogin,
  }) {
    return (normalizedPhone: phone, isLogin: isLogin);
  }
  return null;
}

String? _registrationPhone(Object? extra) {
  if (extra case {'normalizedPhone': final String phone}) return phone;
  return null;
}

({String normalizedPhone, String firstName, String? lastName})?
_registrationNameArguments(Object? extra) {
  if (extra case {
    'normalizedPhone': final String phone,
    'firstName': final String firstName,
    'lastName': final String? lastName,
  }) {
    return (normalizedPhone: phone, firstName: firstName, lastName: lastName);
  }
  return null;
}

Future<String?> _redirectForSession(
  AuthRepository auth,
  GoRouterState state,
) async {
  final path = state.uri.path;
  final isAuthPage =
      path == '/' || path == '/phone' || path.startsWith('/phone/');

  // Check secure storage before routing, including on a cold launch.
  final session = await auth.restoreSession();
  if (session case Success(value: String())) {
    // Registration saves the session before navigating to Welcome.
    return isAuthPage ? '/home' : null;
  }

  // Require a confirmed session for the signed-in routes.
  return isAuthPage ? null : '/';
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final router = GoRouter(
    redirect: (_, state) => _redirectForSession(auth, state),
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const OnboardingScreen(key: Key('onboarding')),
      ),
      GoRoute(
        path: '/phone',
        builder: (_, state) => PhoneNumberScreen(
          isLogin: state.uri.queryParameters['mode'] == 'login',
          initialPhone: state.extra is String ? state.extra! as String : '',
        ),
        routes: [
          GoRoute(
            path: 'otp',
            // The phone stays in route arguments and is never included in the URL.
            redirect: (_, state) =>
                _otpArguments(state.extra) == null ? '/phone' : null,
            builder: (_, state) {
              final args = _otpArguments(state.extra)!;
              return OtpScreen(
                normalizedPhone: args.normalizedPhone,
                isLogin: args.isLogin,
              );
            },
          ),
          GoRoute(
            path: 'name',
            redirect: (_, state) =>
                _registrationPhone(state.extra) == null ? '/phone' : null,
            builder: (_, state) =>
                NameScreen(normalizedPhone: _registrationPhone(state.extra)!),
          ),
          GoRoute(
            path: 'date-of-birth',
            redirect: (_, state) =>
                _registrationNameArguments(state.extra) == null
                ? '/phone'
                : null,
            builder: (_, state) {
              final draft = _registrationNameArguments(state.extra)!;
              return DateOfBirthScreen(
                normalizedPhone: draft.normalizedPhone,
                firstName: draft.firstName,
                lastName: draft.lastName,
              );
            },
          ),
        ],
      ),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      ShellRoute(
        // Keep one bar mounted while the nested navigator swaps tab pages.
        builder: (_, state, child) => Scaffold(
          extendBody: true,
          body: child,
          bottomNavigationBar: AppBottomNavigationBar(location: state.uri.path),
        ),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (_, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const HomeScreen(key: Key('home')),
            ),
          ),
          GoRoute(
            name: RewardsScreen.routeName,
            path: '/rewards',
            pageBuilder: (_, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const RewardsScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (_, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        name: ProductDetailScreen.routeName,
        path: '/product/:id',
        builder: (_, state) =>
            ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
