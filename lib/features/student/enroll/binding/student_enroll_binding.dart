import 'package:get/get.dart';

import '../controller/student_enroll_controller.dart';

class StudentEnrollBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StudentEnrollController>()) {
      Get.lazyPut<StudentEnrollController>(
        () => StudentEnrollController(),
        fenix: true,
      );
    }
  }
}
