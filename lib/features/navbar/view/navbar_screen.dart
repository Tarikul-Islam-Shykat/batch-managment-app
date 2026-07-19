import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../batch/create_batch/view/create_batch_screen.dart';
import '../../batch/list/view/batch_list_screen.dart';
import '../../home/view/home_tab.dart';
import '../controller/navbar_controller.dart';

class NavbarScreen extends GetView<NavbarController> {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeTab(),
      const BatchListScreen(),
      const CreateBatchScreen(showBackButton: false),
    ];

    return Scaffold(
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.switchTab,
          backgroundColor: AppColors.whiteColor,
          indicatorColor: AppColors.primaryColor.withValues(alpha: 0.12),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.view_list_outlined),
              selectedIcon: const Icon(Icons.view_list),
              label: 'batches'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.add_circle_outline),
              selectedIcon: const Icon(Icons.add_circle),
              label: 'new_batch'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
