import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../controller/batch_students_controller.dart';

class BatchStudentFilterSheet extends StatefulWidget {
  final BatchStudentsController controller;

  const BatchStudentFilterSheet({super.key, required this.controller});

  @override
  State<BatchStudentFilterSheet> createState() =>
      _BatchStudentFilterSheetState();
}

class _BatchStudentFilterSheetState extends State<BatchStudentFilterSheet> {
  late String _selectedMonth;
  late String _selectedStatus;

  BatchStudentsController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _selectedMonth = controller.activeFinanceMonthLabel;
    _selectedStatus = controller.paymentFilter.value;
  }

  @override
  Widget build(BuildContext context) {
    final monthOptions = controller.availableFinanceMonthOptions;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              text: 'filter_students'.tr,
              color: AppColors.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
            SizedBox(height: 4.h),
            smallText(
              text: 'payment_status'.tr,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            verticalSpace(16),
            DropdownButtonFormField<String>(
              initialValue: _selectedMonth,
              decoration: InputDecoration(
                labelText: 'finance_month'.tr,
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
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
              ),
              isExpanded: true,
              items: monthOptions
                  .map(
                    (month) => DropdownMenuItem<String>(
                      value: month,
                      child: Text(month, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedMonth = value);
              },
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'payment_status'.tr,
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
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
                if (value == null) return;
                setState(() => _selectedStatus = value);
              },
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedMonth = controller.currentFinanceMonth();
                        _selectedStatus =
                            BatchStudentsController.paymentFilterAll;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: const BorderSide(color: AppColors.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text('reset'.tr),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.changeFinanceMonth(_selectedMonth);
                      controller.setPaymentFilter(_selectedStatus);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text('apply'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
