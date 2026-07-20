import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../model/batch_student_model.dart';

class BatchStudentProfileSheet extends StatelessWidget {
  final BatchStudentModel student;
  final String batchName;
  final String Function(String value) formatDate;

  const BatchStudentProfileSheet({
    super.key,
    required this.student,
    required this.batchName,
    required this.formatDate,
  });

  double get _payableMonthlyAmount {
    return (student.monthlyFee - student.discount).clamp(0, double.infinity);
  }

  Widget _detailRow({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: labelValueText(
        label: '$label: ',
        value: value,
        labelColor: Colors.black54,
        valueColor: AppColors.blackColor,
        labelWeight: FontWeight.w500,
        valueWeight: FontWeight.w700,
        maxLines: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.88.sh),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.blackColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              verticalSpace(16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        brandText(
                          text: student.firstName,
                          color: AppColors.blackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                        verticalSpace(6),
                        if (batchName.trim().isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: smallText(
                              text: batchName,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: smallText(
                      text: student.status,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              _detailRow(
                label: 'student_system_id'.tr,
                value: student.studentSystemId,
              ),
              verticalSpace(10),
              _detailRow(label: 'roll_number'.tr, value: student.rollNumber),
              verticalSpace(10),
              _detailRow(
                label: 'guardian_phone'.tr,
                value: student.guardianPhone,
              ),
              verticalSpace(10),
              _detailRow(
                label: 'batch_started_at'.tr,
                value: formatDate(student.batchStartedAt),
              ),
              verticalSpace(10),
              _detailRow(
                label: 'monthly_fee'.tr,
                value: student.monthlyFee.toStringAsFixed(0),
              ),
              verticalSpace(10),
              _detailRow(
                label: 'discount_percent'.tr,
                value: student.discount.toStringAsFixed(0),
              ),
              verticalSpace(10),
              _detailRow(
                label: 'payable_fee'.tr,
                value: _payableMonthlyAmount.toStringAsFixed(0),
              ),
              verticalSpace(10),
              _detailRow(
                label: 'notes'.tr,
                value: student.notes.trim().isEmpty ? '-' : student.notes,
              ),
              verticalSpace(10),
              _detailRow(label: 'status'.tr, value: student.status),
              verticalSpace(10),
              _detailRow(
                label: 'created_at'.tr,
                value: formatDate(student.createdAt),
              ),
              verticalSpace(10),
              _detailRow(
                label: 'updated_at'.tr,
                value: formatDate(student.updatedAt),
              ),
              verticalSpace(10),
              _detailRow(
                label: 'approved_at'.tr,
                value: formatDate(student.approvedAt),
              ),
              verticalSpace(18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: brandText(
                    text: 'close'.tr,
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
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
