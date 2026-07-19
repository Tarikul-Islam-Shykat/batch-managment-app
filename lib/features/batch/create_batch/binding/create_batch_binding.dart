import 'package:get/get.dart';

import '../controller/create_batch_controller.dart';

class CreateBatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateBatchController>(() => CreateBatchController());
  }
}
