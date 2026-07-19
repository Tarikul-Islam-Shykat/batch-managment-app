import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/app_btn.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../controller/batch_list_controller.dart';
import '../model/batch_list_response_model.dart';

class BatchCard extends StatelessWidget {
  final BatchListItemModel batch;
  final BatchListController controller;

  const BatchCard({super.key, required this.batch, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheduleText = batch.schedule
        .map(
          (item) =>
              '${controller.dayLabel(item.day)} ${item.startTime}-${item.endTime}',
        )
        .join(' • ');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: smallText(
                        text: controller.statusLabel(
                          controller.selectedStatus.value,
                        ),
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalSpace(12),
                    brandText(
                      text: batch.batchName,
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    verticalSpace(4),
                    normalText(
                      text: '${'subject'.tr}: ${batch.subject}',
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Get.snackbar(
                  'info'.tr,
                  batch.batchName,
                  snackPosition: SnackPosition.BOTTOM,
                ),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          verticalSpace(10),
          normalText(
            text: '${'start_date'.tr}: ${batch.startDate}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text: '${'end_date'.tr}: ${batch.endDate}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text: '${'fees'.tr}: ${batch.fees.toStringAsFixed(0)}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text: '${'max_students'.tr}: ${batch.maxStudents}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text: scheduleText,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(14),
          Row(
            children: [
              Expanded(
                child: GlobalAppButton(
                  text: 'details'.tr,
                  onTap: () => Get.snackbar(
                    'details'.tr,
                    batch.batchName,
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                  height: 46.h,
                  borderRadius: 12,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GlobalAppButton(
                  text: 'manage_batch'.tr,
                  onTap: () => Get.snackbar(
                    'manage_batch'.tr,
                    batch.batchName,
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                  height: 46.h,
                  borderRadius: 12,
                  backgroundColor: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
