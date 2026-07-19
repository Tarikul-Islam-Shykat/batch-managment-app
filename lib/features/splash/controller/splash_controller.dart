import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  static const String logoHeroTag = 'splash-logo-hero';
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    log('SplashController initialized');
    _timer = Timer(const Duration(seconds: 2), () {
      log('SplashController navigating to login');
      Get.offAllNamed(AppRoute.loginScreen);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
