import 'package:get/get.dart';
import '../../features/batch/create_batch/binding/create_batch_binding.dart';
import '../../features/batch/create_batch/view/create_batch_screen.dart';
import '../../features/login/binding/login_binding.dart';
import '../../features/login/view/login_screen.dart';
import '../../features/splash/binding/splash_binding.dart';
import '../../features/splash/view/splash_screen.dart';

class AppRoute {
  static String init = "/splash";
  static String loginScreen = "/login";
  static String createBatchScreen = "/create-batch";

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
      name: createBatchScreen,
      page: () => const CreateBatchScreen(),
      binding: CreateBatchBinding(),
    ),
  ];
}
