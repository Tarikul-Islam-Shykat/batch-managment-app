import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/loading.dart';
import '../../../../core/global/spacing.dart';
import '../controller/batch_students_controller.dart';

class BatchPaymentStatementSheet extends StatelessWidget {
  final BatchStudentsController controller;

  const BatchPaymentStatementSheet({super.key, required this.controller});

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is num) return value.toStringAsFixed(0);
    return value.toString();
  }

  Widget _statementTile({
    required String label,
    required String value,
    required Color accentColor,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallText(
                  text: label,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                brandText(
                  text: value,
                  color: AppColors.blackColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Obx(() {
          final summary = controller.financeSummary;
          final monthOptions = controller.availableFinanceMonthOptions;
          final selectedMonth = controller.activeFinanceMonthLabel;

          return Stack(
            children: [
              Opacity(
                opacity: controller.isFinanceLoading.value ? 0.42 : 1,
                child: SingleChildScrollView(
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
                        text: 'finance_statement'.tr,
                        color: AppColors.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                      SizedBox(height: 4.h),
                      smallText(
                        text: selectedMonth,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      verticalSpace(16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedMonth,
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
                                child: Text(
                                  month,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeFinanceMonth(value);
                          }
                        },
                      ),
                      verticalSpace(16),
                      if (summary.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 28.h),
                          alignment: Alignment.center,
                          child: smallText(
                            text: 'no_history_found'.tr,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else ...[
                        _statementTile(
                          label: 'total_students'.tr,
                          value: _formatValue(summary['total_students']),
                          accentColor: const Color(0xFF2F80ED),
                          icon: Icons.groups_rounded,
                        ),
                        verticalSpace(10),
                        _statementTile(
                          label: 'paid_students'.tr,
                          value: _formatValue(summary['paid_students']),
                          accentColor: const Color(0xFF11A36A),
                          icon: Icons.check_circle_outline_rounded,
                        ),
                        verticalSpace(10),
                        _statementTile(
                          label: 'expected_amount'.tr,
                          value: _formatValue(summary['total_expected_amount']),
                          accentColor: const Color(0xFFF28C28),
                          icon: Icons.payments_outlined,
                        ),
                        verticalSpace(10),
                        _statementTile(
                          label: 'paid_amount'.tr,
                          value: _formatValue(summary['total_paid_amount']),
                          accentColor: const Color(0xFF7C3AED),
                          icon: Icons.receipt_long_outlined,
                        ),
                        verticalSpace(10),
                        _statementTile(
                          label: 'remaining_amount'.tr,
                          value: _formatValue(summary['remaining_amount']),
                          accentColor: const Color(0xFFEB5757),
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ],
                      verticalSpace(18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text('close'.tr),
                        ),
                      ),
                    ],
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
          );
        }),
      ),
    );
  }
}
