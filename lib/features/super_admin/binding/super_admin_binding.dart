import 'package:get/get.dart';

import '../../app_status/controller/app_status_controller.dart';
import '../../profile/controller/profile_tab_controller.dart';
import '../controller/super_admin_controller.dart';

class SuperAdminBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SuperAdminController>()) {
      Get.lazyPut<SuperAdminController>(
        () => SuperAdminController(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ProfileTabController>()) {
      Get.lazyPut<ProfileTabController>(
        () => ProfileTabController(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AppStatusController>()) {
      Get.lazyPut<AppStatusController>(
        () => AppStatusController(),
        fenix: true,
      );
    }
  }
}
