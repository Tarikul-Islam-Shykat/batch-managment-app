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
          _InfoLine(text: '${'subject'.tr}: ${batch.subject}'),
          verticalSpace(4),
          _InfoLine(text: '${'fees'.tr}: ${batch.fees.toStringAsFixed(0)}'),
          verticalSpace(4),
          _InfoLine(
            text:
                '${'start_date'.tr}: ${controller.formatDate(batch.startDate)}',
          ),
          verticalSpace(4),
          _InfoLine(
            text: '${'end_date'.tr}: ${controller.formatDate(batch.endDate)}',
          ),
          verticalSpace(4),
          _InfoLine(text: controller.scheduleText()),
          verticalSpace(14),
          Row(
            children: [
              Expanded(
                child: _PrimaryButton(
                  text: 'add_student'.tr,
                  backgroundColor: AppColors.primaryColor,
                  onTap: () => Get.toNamed(
                    AppRoute.studentEnrollScreen,
                    arguments: batch,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _PrimaryButton(
                  text: 'fee_calculation'.tr,
                  backgroundColor: AppColors.blackColor,
                  onTap: () => Get.snackbar(
                    'info'.tr,
                    'fee_calculation'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                ),
              ),
            ],
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
  final String text;

  const _InfoLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return normalText(
      text: text,
      color: Colors.black54,
      fontWeight: FontWeight.w400,
      maxLines: 2,
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
