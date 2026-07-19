import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../model/batch_student_model.dart';

class BatchStudentCard extends StatelessWidget {
  final BatchStudentModel student;

  const BatchStudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: brandText(
                  text: student.firstName,
                  color: AppColors.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: smallText(
                  text: student.status,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          normalText(
            text: '${'student_system_id'.tr}: ${student.studentSystemId}',
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          verticalSpace(4),
          normalText(
            text: '${'roll_number'.tr}: ${student.rollNumber}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text: '${'guardian_phone'.tr}: ${student.guardianPhone}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text: '${'join_date'.tr}: ${student.batchStartedAt}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text:
                '${'monthly_fee'.tr}: ${student.monthlyFee.toStringAsFixed(0)}',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(4),
          normalText(
            text:
                '${'discount_percent'.tr}: ${student.discount.toStringAsFixed(0)}%',
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
          verticalSpace(8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: normalText(
                    text: student.notes.trim().isEmpty ? '-' : student.notes,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Material(
                color: AppColors.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: () => Get.snackbar(
                    'info'.tr,
                    '${'view_profile'.tr}: ${student.firstName}',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: smallText(
                      text: 'view_profile'.tr,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
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
