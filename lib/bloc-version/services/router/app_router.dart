import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/splash_view.dart';
import '../../features/login/presentation/login_view.dart';
import '../../features/register/presentation/register_view.dart';
import '../../features/otp_verification/presentation/otp_verification_view.dart';
import '../../features/navbar/presentation/navbar_view.dart';
import '../../features/create_batch/presentation/create_batch_view.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home';
  static const String navbar = '/navbar';
  static const String createBatch = '/create-batch';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashView()),
      GoRoute(path: login, builder: (context, state) => const LoginView()),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: verifyOtp,
        builder: (context, state) => OtpVerificationView(
          arguments: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(path: home, builder: (context, state) => const NavbarView()),
      GoRoute(path: navbar, builder: (context, state) => const NavbarView()),
      GoRoute(
        path: createBatch,
        builder: (context, state) =>
            const CreateBatchView(showBackButton: true),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
  );
}
