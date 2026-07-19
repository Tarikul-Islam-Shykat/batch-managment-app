import 'package:get/get.dart';

import '../controller/create_batch_controller.dart';

class CreateBatchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CreateBatchController>()) {
      Get.lazyPut<CreateBatchController>(
        () => CreateBatchController(),
        fenix: true,
      );
    }
  }
}
