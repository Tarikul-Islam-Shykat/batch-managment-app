import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../model/batch_student_model.dart';

class BatchStudentCard extends StatelessWidget {
  final BatchStudentModel student;
  final bool isSelected;
  final VoidCallback onSelectionChanged;
  final VoidCallback onViewProfile;

  const BatchStudentCard({
    super.key,
    required this.student,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onViewProfile,
  });

  double get _payableMonthlyAmount {
    return (student.monthlyFee - student.discount).clamp(0, double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : AppColors.blackColor.withValues(alpha: 0.05),
          width: isSelected ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primaryColor.withValues(alpha: 0.08)
                : AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: brandText(
                  text: student.firstName,
                  color: AppColors.blackColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  textAlign: TextAlign.start,
                ),
              ),
              Checkbox(
                value: isSelected,
                activeColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                onChanged: (_) => onSelectionChanged(),
              ),
            ],
          ),
          verticalSpace(10),
          labelValueText(
            label: '${'roll_number'.tr}: ',
            value: student.rollNumber,
            labelColor: Colors.black54,
            valueColor: Colors.black87,
            labelWeight: FontWeight.w500,
            valueWeight: FontWeight.w700,
          ),
          verticalSpace(6),
          labelValueText(
            label: '${'payable_fee'.tr}: ',
            value: _payableMonthlyAmount.toStringAsFixed(0),
            labelColor: Colors.black54,
            valueColor: AppColors.primaryColor,
            labelWeight: FontWeight.w500,
            valueWeight: FontWeight.w700,
          ),
          verticalSpace(12),
          Row(
            children: [
              const Spacer(),
              Material(
                color: AppColors.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14.r),
                child: InkWell(
                  onTap: onViewProfile,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 11.h,
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
