import 'package:get/get.dart';

import '../controller/student_edit_controller.dart';

class StudentEditBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StudentEditController>()) {
      Get.lazyPut<StudentEditController>(
        () => StudentEditController(),
        fenix: true,
      );
    }
  }
}
