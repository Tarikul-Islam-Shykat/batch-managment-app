import 'package:get/get.dart';

import '../controller/batch_history_controller.dart';

class BatchHistoryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BatchHistoryController>()) {
      Get.lazyPut<BatchHistoryController>(
        () => BatchHistoryController(),
        fenix: true,
      );
    }
  }
}
