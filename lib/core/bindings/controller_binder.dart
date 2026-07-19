import 'package:get/get.dart';
import '../controller/language_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put<LanguageController>(LanguageController(), permanent: true);
  }
}
