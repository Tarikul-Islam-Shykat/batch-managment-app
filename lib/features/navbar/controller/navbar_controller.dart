import 'package:get/get.dart';

import '../../home/controller/home_dashboard_controller.dart';

class NavbarController extends GetxController {
  final currentIndex = 0.obs;

  Future<void> switchTab(int index) async {
    currentIndex.value = index;
    if (index == 0 && Get.isRegistered<HomeDashboardController>()) {
      await Get.find<HomeDashboardController>().refreshDashboard();
    }
  }
}
