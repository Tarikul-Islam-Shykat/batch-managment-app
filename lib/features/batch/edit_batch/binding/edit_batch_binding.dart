import 'package:get/get.dart';

import '../controller/edit_batch_controller.dart';

class EditBatchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EditBatchController>()) {
      Get.lazyPut<EditBatchController>(
        () => EditBatchController(),
        fenix: true,
      );
    }
  }
}
