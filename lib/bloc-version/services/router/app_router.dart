import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/splash_view.dart';
import '../../features/login/presentation/login_view.dart';
import '../../features/register/presentation/register_view.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashView()),
      GoRoute(path: login, builder: (context, state) => const LoginView()),
      GoRoute(path: register, builder: (context, state) => const RegisterView()),
      GoRoute(
        path: home,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text(
              'BLoC Home Screen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
  );
}
