import 'package:get/get.dart';

import '../controller/batch_list_controller.dart';

class BatchListBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BatchListController>()) {
      Get.lazyPut<BatchListController>(
        () => BatchListController(),
        fenix: true,
      );
    }
  }
}
