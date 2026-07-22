import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/app_header_bar.dart';
import '../../profile/controller/profile_tab_controller.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileTabController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppHeaderBar(
        title: 'home'.tr,
        subtitle: '',
        subtitleBuilder: () => profileController.displayName,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
