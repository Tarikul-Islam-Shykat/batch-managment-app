import 'package:get/get.dart';
import '../../features/batch/create_batch/binding/create_batch_binding.dart';
import '../../features/batch/create_batch/view/create_batch_screen.dart';
import '../../features/batch/list/binding/batch_list_binding.dart';
import '../../features/batch/list/view/batch_list_screen.dart';
import '../../features/student/batch_students/binding/batch_students_binding.dart';
import '../../features/student/batch_students/view/batch_students_screen.dart';
import '../../features/student/enroll/binding/student_enroll_binding.dart';
import '../../features/student/enroll/view/student_enroll_screen.dart';
import '../../features/navbar/binding/navbar_binding.dart';
import '../../features/navbar/view/navbar_screen.dart';
import '../../features/app_status/binding/app_status_binding.dart';
import '../../features/app_status/view/app_status_screen.dart';
import '../../features/super_admin/binding/super_admin_binding.dart';
import '../../features/super_admin/view/super_admin_screen.dart';
import '../../features/login/binding/login_binding.dart';
import '../../features/login/view/login_screen.dart';
import '../../features/register/binding/otp_verification_binding.dart';
import '../../features/register/binding/register_binding.dart';
import '../../features/register/view/otp_verification_screen.dart';
import '../../features/register/view/register_screen.dart';
import '../../features/splash/binding/splash_binding.dart';
import '../../features/splash/view/splash_screen.dart';

class AppRoute {
  static String init = "/splash";
  static String loginScreen = "/login";
  static String navBarScreen = "/nav-bar";
  static String createBatchScreen = "/create-batch";
  static String batchListScreen = "/batch-list";
  static String studentEnrollScreen = "/student-enroll";
  static String batchStudentsScreen = "/batch-students";
  static String registerScreen = "/register";
  static String otpVerificationScreen = "/otp-verification";
  static String appStatusScreen = "/app-status";
  static String superAdminScreen = "/super-admin";

  static List<GetPage> routes = [
    GetPage(
      name: init,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: registerScreen,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: navBarScreen,
      page: () => const NavbarScreen(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: superAdminScreen,
      page: () => const SuperAdminScreen(),
      binding: SuperAdminBinding(),
    ),
    GetPage(
      name: appStatusScreen,
      page: () => const AppStatusScreen(),
      binding: AppStatusBinding(),
    ),
    GetPage(
      name: createBatchScreen,
      page: () => const CreateBatchScreen(),
      binding: CreateBatchBinding(),
    ),
    GetPage(
      name: batchListScreen,
      page: () => const BatchListScreen(),
      binding: BatchListBinding(),
    ),
    GetPage(
      name: studentEnrollScreen,
      page: () => const StudentEnrollScreen(),
      binding: StudentEnrollBinding(),
    ),
    GetPage(
      name: batchStudentsScreen,
      page: () => const BatchStudentsScreen(),
      binding: BatchStudentsBinding(),
    ),
  ];
}
