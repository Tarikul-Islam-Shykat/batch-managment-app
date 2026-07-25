import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../controller/batch_students_controller.dart';

class BatchPaymentFilterBar extends StatelessWidget {
  final BatchStudentsController controller;

  const BatchPaymentFilterBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeMonth = controller.activeFinanceMonthLabel;
      final monthOptions = controller.availableFinanceMonthOptions;
      final currentStatus = controller.paymentFilter.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      brandText(
                        text: 'payment_status'.tr,
                        color: AppColors.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                      SizedBox(height: 2.h),
                      smallText(
                        text: activeMonth,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: activeMonth,
              decoration: InputDecoration(
                labelText: 'finance_month'.tr,
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
              isExpanded: true,
              items: monthOptions
                  .map(
                    (monthItem) => DropdownMenuItem(
                      value: monthItem,
                      child: Text(monthItem, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.changeFinanceMonth(value);
                }
              },
            ),
            SizedBox(height: 10.h),
            DropdownButtonFormField<String>(
              initialValue: currentStatus,
              decoration: InputDecoration(
                labelText: 'payment_status'.tr,
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: BatchStudentsController.paymentFilterAll,
                  child: Text('all'.tr),
                ),
                DropdownMenuItem(
                  value: BatchStudentsController.paymentFilterPaid,
                  child: Text('paid'.tr),
                ),
                DropdownMenuItem(
                  value: BatchStudentsController.paymentFilterUnpaid,
                  child: Text('unpaid'.tr),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.setPaymentFilter(value);
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
