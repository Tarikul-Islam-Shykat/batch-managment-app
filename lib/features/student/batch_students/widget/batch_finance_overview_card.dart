import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/loading.dart';
import '../controller/batch_students_controller.dart';
import 'batch_payment_statement_sheet.dart';

class BatchFinanceOverviewCard extends StatelessWidget {
  final BatchStudentsController controller;

  const BatchFinanceOverviewCard({super.key, required this.controller});

  void _openStatementSheet() {
    Get.bottomSheet(
      BatchPaymentStatementSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Opacity(
            opacity: controller.isFinanceLoading.value ? 0.7 : 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColors.blackColor.withValues(alpha: 0.06),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: _openStatementSheet,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'show_details'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextButton.icon(
                      onPressed: _openStatementSheet,
                      icon: Icon(Icons.receipt_long_rounded, size: 16.sp),
                      label: Text('finance_statement'.tr),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        backgroundColor: AppColors.primaryColor.withValues(
                          alpha: 0.08,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isFinanceLoading.value)
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 58.w,
                  height: 58.w,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: loading(value: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
