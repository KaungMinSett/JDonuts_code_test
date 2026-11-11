import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
        const Scaffold(body: Placeholder(key: Key('onboarding'))),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) =>
        const Scaffold(body: Placeholder(key: Key('home'))),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});