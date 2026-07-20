import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/loading.dart';
import '../../../core/global/spacing.dart';
import '../controller/profile_tab_controller.dart';

class ProfileTab extends GetView<ProfileTabController> {
  const ProfileTab({super.key});

  Widget _infoCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: labelValueText(
        label: '$label: ',
        value: value,
        labelColor: Colors.black54,
        valueColor: AppColors.blackColor,
        labelWeight: FontWeight.w500,
        valueWeight: FontWeight.w700,
        maxLines: 3,
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    final color = destructive ? Colors.redAccent : AppColors.blackColor;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: color),
              SizedBox(width: 12.w),
              Expanded(
                child: normalText(
                  text: title,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: false,
        title: brandText(
          text: 'profile'.tr,
          color: AppColors.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        actions: [
          IconButton(
            onPressed: controller.fetchProfile,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.profileData.isEmpty) {
            return Center(child: loading());
          }

          return RefreshIndicator(
            onRefresh: controller.fetchProfile,
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
                      children: [
                        Container(
                          width: 72.w,
                          height: 72.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.12,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 38.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        verticalSpace(14),
                        brandText(
                          text: controller.displayName,
                          color: AppColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(4),
                        normalText(
                          text: controller.displayRole,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(16),
                  _menuTile(
                    icon: Icons.badge_outlined,
                    title: 'personal_info'.tr,
                    onTap: () {},
                  ),
                  verticalSpace(10),
                  _menuTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'email'.tr,
                    onTap: () {},
                  ),
                  verticalSpace(10),
                  _menuTile(
                    icon: Icons.phone_outlined,
                    title: 'phone'.tr,
                    onTap: () {},
                  ),
                  verticalSpace(10),
                  _menuTile(
                    icon: Icons.list_alt_rounded,
                    title: 'account_details'.tr,
                    onTap: () {},
                  ),
                  verticalSpace(16),
                  if (controller.profileFields.isNotEmpty) ...[
                    brandText(
                      text: 'details'.tr,
                      color: AppColors.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                    verticalSpace(12),
                    ...controller.profileFields.asMap().entries.expand((entry) {
                      final index = entry.key;
                      final field = entry.value;
                      return [
                        _infoCard(label: field.key, value: field.value),
                        if (index != controller.profileFields.length - 1)
                          verticalSpace(10),
                      ];
                    }),
                    verticalSpace(16),
                  ],
                  _menuTile(
                    icon: Icons.logout_rounded,
                    title: 'logout'.tr,
                    onTap: controller.logout,
                    destructive: true,
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
