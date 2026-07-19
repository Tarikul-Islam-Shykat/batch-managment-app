import 'package:get/get.dart';

import '../controller/batch_students_controller.dart';

class BatchStudentsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BatchStudentsController>()) {
      Get.lazyPut<BatchStudentsController>(
        () => BatchStudentsController(),
        fenix: true,
      );
    }
  }
}
