import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/loading.dart';
import '../../../core/global/spacing.dart';
import '../../app_status/view/app_status_screen.dart';
import '../../profile/controller/profile_tab_controller.dart';
import '../controller/super_admin_controller.dart';

class SuperAdminScreen extends GetView<SuperAdminController> {
  const SuperAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileTabController>();

    final pages = <Widget>[
      _SuperAdminHomeTab(profileController: profileController),
      const AppStatusScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
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
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard_rounded),
              label: 'super_admin_dashboard'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.system_update_alt_outlined),
              selectedIcon: const Icon(Icons.system_update_alt_rounded),
              label: 'app_status_title'.tr,
            ),
          ],
        ),
      ),
    );
  }
}

class _SuperAdminHomeTab extends StatelessWidget {
  final ProfileTabController profileController;

  const _SuperAdminHomeTab({required this.profileController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: false,
        title: brandText(
          text: 'super_admin_dashboard'.tr,
          color: AppColors.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        actions: [
          IconButton(
            onPressed: profileController.fetchProfile,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (profileController.isLoading.value &&
              profileController.profileData.isEmpty) {
            return Center(child: loading());
          }

          return RefreshIndicator(
            onRefresh: profileController.fetchProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: AppColors.blackColor.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        smallText(
                          text: 'super_admin'.tr,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        verticalSpace(10),
                        brandText(
                          text: profileController.displayName,
                          color: AppColors.blackColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
                        verticalSpace(6),
                        normalText(
                          text: profileController.displayEmail,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                        ),
                        verticalSpace(10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: smallText(
                            text: profileController.displayRole,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(16),
                  _SuperAdminActionCard(
                    icon: Icons.system_update_alt_rounded,
                    title: 'app_status_title'.tr,
                    subtitle: 'super_admin_app_status_subtitle'.tr,
                    onTap: profileController.isSuperAdmin
                        ? () => Get.find<SuperAdminController>().switchTab(1)
                        : () {},
                  ),
                  verticalSpace(12),
                  _SuperAdminActionCard(
                    icon: Icons.logout_rounded,
                    title: 'logout'.tr,
                    subtitle: 'logout_subtitle'.tr,
                    onTap: profileController.logout,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SuperAdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SuperAdminActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: AppColors.blackColor.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    brandText(
                      text: title,
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                    verticalSpace(4),
                    normalText(
                      text: subtitle,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.black38,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
