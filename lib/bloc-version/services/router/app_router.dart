import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/splash/presentation/splash_view.dart';
import '../../features/auth/login/presentation/login_view.dart';
import '../../features/auth/register/presentation/register_view.dart';
import '../../features/auth/otp_verification/presentation/otp_verification_view.dart';
import '../../features/navbar/presentation/navbar_view.dart';
import '../../features/batch_list/presentation/batch_list_view.dart';
import '../../features/create_batch/data/models/create_batch_model.dart';
import '../../features/create_batch/presentation/create_batch_view.dart';
import '../../features/create_student/presentation/create_student_view.dart';
import '../../features/batch_students/presentation/batch_students_view.dart';
import '../../features/batch_students/data/models/batch_students_model.dart';
import '../../features/edit_student/presentation/edit_student_view.dart';
import '../../features/super_admin/presentation/super_admin_view.dart';
import '../../features/history/presentation/history_view.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home';
  static const String navbar = '/navbar';
  static const String batches = '/batches';
  static const String createBatch = '/create-batch';
  static const String editBatch = '/edit-batch';
  static const String enrollStudent = '/enroll-student';
  static const String batchStudents = '/batch-students';
  static const String editStudent = '/edit-student';
  static const String superAdmin = '/super-admin';
  static const String batchHistory = '/batch-history';

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
        path: batches,
        builder: (context, state) => const BatchListView(),
      ),
      GoRoute(
        path: createBatch,
        builder: (context, state) =>
            const CreateBatchView(showBackButton: true),
      ),
      GoRoute(
        path: editBatch,
        builder: (context, state) => CreateBatchView(
          showBackButton: true,
          batchToEdit: state.extra as BatchListItemModel?,
        ),
      ),
      GoRoute(
        path: enrollStudent,
        builder: (context, state) =>
            CreateStudentView(batch: state.extra as BatchListItemModel?),
      ),
      GoRoute(
        path: batchStudents,
        builder: (context, state) =>
            BatchStudentsView(batch: state.extra as BatchListItemModel),
      ),
      GoRoute(
        path: editStudent,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return EditStudentView(
            student: args['student'] as BatchStudentModel,
            batch: args['batch'] as BatchListItemModel?,
          );
        },
      ),
      GoRoute(
        path: superAdmin,
        builder: (context, state) => const SuperAdminView(),
      ),
      GoRoute(
        path: batchHistory,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return HistoryView(
            batchId: args?['batch_id'] as String?,
            batchName: args?['batch_name'] as String?,
            studentId: args?['student_id'] as String?,
            studentName: args?['student_name'] as String?,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
  );
}
