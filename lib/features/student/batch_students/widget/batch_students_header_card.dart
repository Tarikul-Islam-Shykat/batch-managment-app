import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../controller/batch_students_controller.dart';

class BatchStudentsHeaderCard extends StatelessWidget {
  final BatchListItemModel batch;
  final BatchStudentsController controller;

  const BatchStudentsHeaderCard({
    super.key,
    required this.batch,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: smallText(
                  text: 'current_batches'.tr,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _ActionIconButton(
                icon: Icons.delete_outline_rounded,
                onTap: () => Get.snackbar(
                  'info'.tr,
                  '${batch.batchName}\n${'delete'.tr}',
                  snackPosition: SnackPosition.BOTTOM,
                ),
              ),
              SizedBox(width: 8.w),
              _ActionIconButton(
                icon: Icons.edit_outlined,
                onTap: () => Get.snackbar(
                  'info'.tr,
                  '${batch.batchName}\n${'edit'.tr}',
                  snackPosition: SnackPosition.BOTTOM,
                ),
              ),
            ],
          ),
          verticalSpace(12),
          brandText(
            text: batch.batchName,
            color: AppColors.blackColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
          verticalSpace(8),
          _InfoLine(
            label: '${'subject'.tr} : ',
            value: batch.subject,
            labelColor: Colors.black54,
            valueColor: Colors.black87,
          ),
          verticalSpace(4),
          _InfoLine(
            label: '${'fees'.tr} : ',
            value: batch.fees.toStringAsFixed(0),
            labelColor: Colors.black54,
            valueColor: Colors.black87,
          ),
          verticalSpace(4),
          _InfoLine(
            label: '${'start_date'.tr} : ',
            value: controller.formatDate(batch.startDate),
            labelColor: Colors.black54,
            valueColor: Colors.black87,
          ),
          verticalSpace(4),
          _InfoLine(
            label: '${'end_date'.tr} : ',
            value: controller.formatDate(batch.endDate),
            labelColor: Colors.black54,
            valueColor: Colors.black87,
          ),
          verticalSpace(4),
          _InfoLine(
            label: '${'class_days'.tr} : ',
            value: controller.scheduleText(),
            labelColor: Colors.black54,
            valueColor: Colors.black87,
            maxLines: 2,
          ),
          verticalSpace(14),
          _PrimaryButton(
            text: 'add_student'.tr,
            backgroundColor: AppColors.primaryColor,
            onTap: () =>
                Get.toNamed(AppRoute.studentEnrollScreen, arguments: batch),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.blackColor),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final int maxLines;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return labelValueText(
      label: label,
      value: value,
      labelColor: labelColor,
      valueColor: valueColor,
      maxLines: maxLines,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 46.h,
          alignment: Alignment.center,
          child: brandText(
            text: text,
            color: AppColors.whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
