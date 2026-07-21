import 'package:get/get.dart';

class SuperAdminController extends GetxController {
  final currentIndex = 0.obs;

  void switchTab(int index) {
    currentIndex.value = index;
  }
}
