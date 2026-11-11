import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/presentation/onboarding_screen.dart';
import '../auth/presentation/screens/date_of_birth_screen.dart';
import '../auth/presentation/screens/name_screen.dart';
import '../auth/presentation/screens/otp_screen.dart';
import '../auth/presentation/screens/phone_number_screen.dart';
import '../auth/presentation/screens/welcome_screen.dart';
import '../home/presentation/home_screen.dart';
import '../product/presentation/product_detail_screen.dart';

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

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
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
      GoRoute(
        path: '/home',
        builder: (_, _) => const HomeScreen(key: Key('home')),
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
