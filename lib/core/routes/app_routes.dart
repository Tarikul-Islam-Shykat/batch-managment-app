import 'package:get/get.dart';
import '../../features/splash/binding/splash_binding.dart';
import '../../features/splash/view/splash_screen.dart';

class AppRoute {
  static String init = "/splash";
  static String onboardingScreen = "/onboardingScreen";

  static List<GetPage> routes = [
    GetPage(
      name: init,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
  ];
}
