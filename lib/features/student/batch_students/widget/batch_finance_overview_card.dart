import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/loading.dart';
import '../../../../core/global/spacing.dart';
import '../controller/batch_students_controller.dart';

class BatchFinanceOverviewCard extends StatefulWidget {
  final BatchStudentsController controller;

  const BatchFinanceOverviewCard({super.key, required this.controller});

  @override
  State<BatchFinanceOverviewCard> createState() =>
      _BatchFinanceOverviewCardState();
}

class _BatchFinanceOverviewCardState extends State<BatchFinanceOverviewCard> {
  bool _showDetails = false;

  Map<String, dynamic> get summary => controller.financeSummary;
  BatchStudentsController get controller => widget.controller;
  String get month => controller.financeMonthLabel.value;

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is num) return value.toStringAsFixed(0);
    return value.toString();
  }

  Widget _metricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 16.sp),
          ),
          SizedBox(height: 10.h),
          smallText(
            text: label,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            maxLines: 2,
          ),
          SizedBox(height: 6.h),
          brandText(
            text: value,
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (summary.isEmpty) return const SizedBox.shrink();

    return Obx(
      () => Stack(
        children: [
          Opacity(
            opacity: controller.isFinanceLoading.value ? 0.42 : 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColors.blackColor.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: brandText(
                          text: 'finance_summary'.tr,
                          color: AppColors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      SizedBox(
                        width: 140.w,
                        child: DropdownButtonFormField<String>(
                          initialValue:
                              controller.selectedFinanceMonth.value.isEmpty
                              ? month
                              : controller.selectedFinanceMonth.value,
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
                          items: controller.availableFinanceMonthOptions
                              .map(
                                (monthItem) => DropdownMenuItem(
                                  value: monthItem,
                                  child: Text(
                                    monthItem,
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
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: () =>
                            setState(() => _showDetails = !_showDetails),
                        borderRadius: BorderRadius.circular(999.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgColor,
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: AppColors.blackColor.withValues(
                                alpha: 0.08,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              smallText(
                                text: _showDetails
                                    ? 'hide_details'.tr
                                    : 'show_details'.tr,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                _showDetails
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: AppColors.primaryColor,
                                size: 18.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: _metricCard(
                              label: 'total_students'.tr,
                              value: _formatValue(summary['total_students']),
                              icon: Icons.groups_rounded,
                              accentColor: const Color(0xFF2F80ED),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _metricCard(
                              label: 'expected_amount'.tr,
                              value: _formatValue(
                                summary['total_expected_amount'],
                              ),
                              icon: Icons.payments_outlined,
                              accentColor: const Color(0xFFF28C28),
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _metricCard(
                                  label: 'total_students'.tr,
                                  value: _formatValue(
                                    summary['total_students'],
                                  ),
                                  icon: Icons.groups_rounded,
                                  accentColor: const Color(0xFF2F80ED),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _metricCard(
                                  label: 'paid_students'.tr,
                                  value: _formatValue(summary['paid_students']),
                                  icon: Icons.check_circle_outline_rounded,
                                  accentColor: const Color(0xFF11A36A),
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(10),
                          Row(
                            children: [
                              Expanded(
                                child: _metricCard(
                                  label: 'expected_amount'.tr,
                                  value: _formatValue(
                                    summary['total_expected_amount'],
                                  ),
                                  icon: Icons.payments_outlined,
                                  accentColor: const Color(0xFFF28C28),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _metricCard(
                                  label: 'remaining_amount'.tr,
                                  value: _formatValue(
                                    summary['remaining_amount'],
                                  ),
                                  icon: Icons.account_balance_wallet_outlined,
                                  accentColor: const Color(0xFFEB5757),
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(10),
                          Row(
                            children: [
                              Expanded(
                                child: _metricCard(
                                  label: 'paid_amount'.tr,
                                  value: _formatValue(
                                    summary['total_paid_amount'],
                                  ),
                                  icon: Icons.receipt_long_outlined,
                                  accentColor: const Color(0xFF7C3AED),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _metricCard(
                                  label: 'finance_month'.tr,
                                  value: _formatValue(summary['fee_month']),
                                  icon: Icons.calendar_month_outlined,
                                  accentColor: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    crossFadeState: _showDetails
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 220),
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
      ),
    );
  }
}
