import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/loading.dart';
import '../../../core/global/spacing.dart';
import '../../../core/global/text_form_field.dart';
import '../controller/profile_tab_controller.dart';

class ProfileEditSheet extends StatefulWidget {
  final ProfileTabController controller;

  const ProfileEditSheet({super.key, required this.controller});

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController institutionNameController;
  late final TextEditingController teachingLevelController;
  late final TextEditingController institutionLocationController;
  late final TextEditingController bioController;
  final isSaving = false.obs;

  ProfileTabController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    institutionNameController = TextEditingController(
      text: controller.institutionName == '-' ? '' : controller.institutionName,
    );
    teachingLevelController = TextEditingController(
      text: controller.teachingLevel == '-' ? '' : controller.teachingLevel,
    );
    institutionLocationController = TextEditingController(
      text: controller.institutionLocation == '-'
          ? ''
          : controller.institutionLocation,
    );
    bioController = TextEditingController(
      text: controller.bio == '-' ? '' : controller.bio,
    );
  }

  @override
  void dispose() {
    institutionNameController.dispose();
    teachingLevelController.dispose();
    institutionLocationController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final payload = <String, dynamic>{};

    void addIfChanged(String key, String current, String original) {
      final currentText = current.trim();
      final originalText = original.trim();
      if (currentText != originalText && currentText.isNotEmpty) {
        payload[key] = currentText;
      }
    }

    addIfChanged(
      'institution_name',
      institutionNameController.text,
      controller.institutionName == '-' ? '' : controller.institutionName,
    );
    addIfChanged(
      'teaching_level',
      teachingLevelController.text,
      controller.teachingLevel == '-' ? '' : controller.teachingLevel,
    );
    addIfChanged(
      'institution_location',
      institutionLocationController.text,
      controller.institutionLocation == '-'
          ? ''
          : controller.institutionLocation,
    );
    addIfChanged(
      'bio',
      bioController.text,
      controller.bio == '-' ? '' : controller.bio,
    );

    if (payload.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'no_profile_changes'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSaving.value = true;
      final success = await controller.updateProfile(payload);
      if (success) {
        Get.back();
        Get.snackbar(
          'success'.tr,
          'profile_updated_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'failed'.tr,
          'profile_update_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isSaving.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              brandText(
                text: 'edit_profile'.tr,
                color: AppColors.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
              SizedBox(height: 4.h),
              smallText(
                text: controller.displayName,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              verticalSpace(16),
              GlobalTextField(
                controller: institutionNameController,
                hintText: 'institution_name'.tr,
                labelText: 'institution_name'.tr,
              ),
              verticalSpace(12),
              GlobalTextField(
                controller: teachingLevelController,
                hintText: 'teaching_level'.tr,
                labelText: 'teaching_level'.tr,
              ),
              verticalSpace(12),
              GlobalTextField(
                controller: institutionLocationController,
                hintText: 'institution_location'.tr,
                labelText: 'institution_location'.tr,
              ),
              verticalSpace(12),
              GlobalTextField(
                controller: bioController,
                hintText: 'bio'.tr,
                labelText: 'bio'.tr,
                maxLines: 4,
              ),
              verticalSpace(18),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving.value ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: isSaving.value
                        ? loading(value: 18)
                        : Text('save_changes'.tr),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
