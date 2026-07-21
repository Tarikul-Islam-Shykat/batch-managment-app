import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/app_btn.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/loading.dart';
import '../../../core/global/spacing.dart';
import '../../../core/global/text_form_field.dart';
import '../controller/app_status_controller.dart';

class AppStatusScreen extends GetView<AppStatusController> {
  const AppStatusScreen({super.key});

  Widget _sectionTitle(String title) {
    return brandText(
      text: title,
      color: AppColors.blackColor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      textAlign: TextAlign.start,
    );
  }

  Widget _statusChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected
          ? AppColors.primaryColor
          : AppColors.primaryColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: smallText(
            text: label,
            color: selected ? AppColors.whiteColor : AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _statusCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: labelValueText(
        label: '$title: ',
        value: value,
        labelColor: Colors.black54,
        valueColor: AppColors.blackColor,
        labelWeight: FontWeight.w500,
        valueWeight: FontWeight.w700,
        maxLines: 4,
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
          text: 'app_status_title'.tr,
          color: AppColors.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        actions: [
          IconButton(
            onPressed: controller.fetchStatuses,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.appStatuses.isEmpty) {
            return Center(child: loading());
          }

          return RefreshIndicator(
            onRefresh: controller.fetchStatuses,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('app_status_form'.tr),
                  verticalSpace(12),
                  GlobalTextField(
                    controller: controller.appVersionController,
                    hintText: '1.0.1',
                    labelText: 'app_version'.tr,
                    isMandatory: true,
                  ),
                  verticalSpace(14),
                  Row(
                    children: [
                      _statusChip(
                        label: 'active'.tr,
                        selected: controller.selectedStatus.value == 'active',
                        onTap: () => controller.selectedStatus.value = 'active',
                      ),
                      SizedBox(width: 10.w),
                      _statusChip(
                        label: 'maintenance'.tr,
                        selected:
                            controller.selectedStatus.value == 'maintenance',
                        onTap: () =>
                            controller.selectedStatus.value = 'maintenance',
                      ),
                    ],
                  ),
                  verticalSpace(14),
                  GlobalTextField(
                    controller: controller.appMaintenanceMessageController,
                    hintText: 'app_maintenance_message_hint'.tr,
                    labelText: 'app_maintenance_message'.tr,
                    maxLines: 3,
                  ),
                  verticalSpace(14),
                  GlobalTextField(
                    controller: controller.appUpdateLinkController,
                    hintText: 'https://example.com/releases/1.0.1',
                    labelText: 'app_update_link'.tr,
                  ),
                  verticalSpace(14),
                  GlobalTextField(
                    controller: controller.appVersionLastUpdateController,
                    hintText: '2026-07-21T00:00:00Z',
                    labelText: 'app_version_last_update'.tr,
                  ),
                  verticalSpace(14),
                  GlobalTextField(
                    controller: controller.appUpdatedFixesController,
                    hintText: 'Initial release\nMongoDB connection fix',
                    labelText: 'app_updated_fixes'.tr,
                    maxLines: 4,
                  ),
                  verticalSpace(20),
                  Obx(
                    () => GlobalAppButton(
                      text: controller.selectedStatusModel == null
                          ? 'create'.tr
                          : 'update'.tr,
                      onTap: controller.saveStatus,
                      height: 52.h,
                      borderRadius: 12,
                      isLoading: controller.isSaving.value,
                    ),
                  ),
                  verticalSpace(24),
                  _sectionTitle('app_status_list'.tr),
                  verticalSpace(12),
                  if (controller.appStatuses.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: normalText(
                        text: 'no_app_status_found'.tr,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    ...controller.appStatuses.asMap().entries.expand((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return [
                        InkWell(
                          onTap: () => controller.selectStatus(item),
                          borderRadius: BorderRadius.circular(16.r),
                          child: _statusCard(
                            title: '${'app_version'.tr} #${index + 1}',
                            value:
                                '${item.appVersion}\n${item.appStatus}\n${item.appMaintenanceMessage ?? '-'}',
                          ),
                        ),
                        if (index != controller.appStatuses.length - 1)
                          verticalSpace(10),
                      ];
                    }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
