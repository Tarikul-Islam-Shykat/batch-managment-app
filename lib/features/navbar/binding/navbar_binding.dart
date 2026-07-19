import 'package:get/get.dart';

import '../../batch/create_batch/controller/create_batch_controller.dart';
import '../../batch/list/controller/batch_list_controller.dart';
import '../controller/navbar_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NavbarController>()) {
      Get.lazyPut<NavbarController>(() => NavbarController(), fenix: true);
    }
    if (!Get.isRegistered<BatchListController>()) {
      Get.lazyPut<BatchListController>(
        () => BatchListController(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<CreateBatchController>()) {
      Get.lazyPut<CreateBatchController>(
        () => CreateBatchController(),
        fenix: true,
      );
    }
  }
}
