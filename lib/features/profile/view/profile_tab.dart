import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/controller/language_controller.dart';
import '../../../core/global/app_header_bar.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/loading.dart';
import '../../../core/global/spacing.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/profile_tab_controller.dart';
import '../widget/profile_edit_sheet.dart';

class ProfileTab extends GetView<ProfileTabController> {
  const ProfileTab({super.key});

  Widget _infoCard({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryColor, size: 18.sp),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallText(
                  text: label,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                normalText(
                  text: value,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    normalText(
                      text: title,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      smallText(
                        text: subtitle,
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ],
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

  void _openEditSheet() {
    Get.bottomSheet(
      ProfileEditSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppHeaderBar(
        title: 'profile'.tr,
        subtitle: '',
        subtitleBuilder: () => controller.displayName,
        actions: [
          IconButton(
            onPressed: controller.fetchProfile,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            onPressed: _openEditSheet,
            icon: const Icon(Icons.edit_outlined),
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0A66FF), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.16),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 72.w,
                          height: 72.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 38.sp,
                            color: Colors.white,
                          ),
                        ),
                        verticalSpace(14),
                        brandText(
                          text: controller.displayName,
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(4),
                        normalText(
                          text: controller.displayRole,
                          color: Colors.white.withValues(alpha: 0.82),
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpace(8),
                        smallText(
                          text: controller.displayEmail,
                          color: Colors.white.withValues(alpha: 0.84),
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(16),
                  _infoCard(
                    label: 'institution_name'.tr,
                    value: controller.institutionName.isNotEmpty
                        ? controller.institutionName
                        : 'not_set'.tr,
                    icon: Icons.school_outlined,
                  ),
                  verticalSpace(10),
                  _infoCard(
                    label: 'teaching_level'.tr,
                    value: controller.teachingLevel.isNotEmpty
                        ? controller.teachingLevel
                        : 'not_set'.tr,
                    icon: Icons.cast_for_education_rounded,
                  ),
                  verticalSpace(10),
                  _infoCard(
                    label: 'institution_location'.tr,
                    value: controller.institutionLocation.isNotEmpty
                        ? controller.institutionLocation
                        : 'not_set'.tr,
                    icon: Icons.location_on_outlined,
                  ),
                  verticalSpace(10),
                  _infoCard(
                    label: 'bio'.tr,
                    value: controller.bio.isNotEmpty
                        ? controller.bio
                        : 'not_set'.tr,
                    icon: Icons.notes_rounded,
                  ),
                  if (controller.isSuperAdmin) ...[
                    verticalSpace(16),
                    _menuTile(
                      icon: Icons.system_update_alt_rounded,
                      title: 'app_status_title'.tr,
                      onTap: () => Get.toNamed(AppRoute.appStatusScreen),
                    ),
                  ],
                  verticalSpace(10),
                  _menuTile(
                    icon: Icons.translate_rounded,
                    title: 'language'.tr,
                    subtitle: languageController.isBangla
                        ? 'switch_to_english'.tr
                        : 'switch_to_bangla'.tr,
                    onTap: languageController.toggleLanguage,
                  ),
                  verticalSpace(16),
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
