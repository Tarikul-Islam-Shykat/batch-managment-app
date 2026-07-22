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
  final VoidCallback? onEdit;

  const BatchStudentProfileSheet({
    super.key,
    required this.student,
    required this.batchName,
    required this.formatDate,
    this.onEdit,
  });

  double get _payableMonthlyAmount {
    return (student.monthlyFee - student.discount).clamp(0, double.infinity);
  }

  Color get _statusColor {
    switch (student.status.toLowerCase()) {
      case 'active':
        return const Color(0xFF16A34A);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'inactive':
      case 'blocked':
        return const Color(0xFFEF4444);
      default:
        return AppColors.secondaryColor;
    }
  }

  Widget _sectionTitle(String text) {
    return brandText(
      text: text,
      color: AppColors.blackColor,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      textAlign: TextAlign.start,
    );
  }

  Widget _statTile({
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 18.sp),
          ),
          verticalSpace(10),
          smallText(
            text: label,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            maxLines: 2,
          ),
          verticalSpace(4),
          brandText(
            text: value,
            color: AppColors.blackColor,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
            textAlign: TextAlign.start,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 18.sp),
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
                  maxLines: 1,
                ),
                verticalSpace(4),
                normalText(
                  text: value,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paidMonthsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primaryColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('paid_months'.tr),
                    smallText(
                      text: student.paidMonths.isEmpty
                          ? '—'
                          : '${student.paidMonths.length} month(s) paid',
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (student.paidMonths.isNotEmpty) ...[
            verticalSpace(12),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: student.paidMonths
                  .map(
                    (month) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(999.r),
                        border: Border.all(
                          color: AppColors.blackColor.withValues(alpha: 0.08),
                        ),
                      ),
                      child: smallText(
                        text: month,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.90.sh),
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: AppColors.blackColor.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.22,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: brandText(
                          text: student.firstName.isNotEmpty
                              ? student.firstName[0].toUpperCase()
                              : '?',
                          color: AppColors.whiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          brandText(
                            text: student.firstName,
                            color: AppColors.blackColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
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
                          verticalSpace(10),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _InfoChip(
                                label: 'student_system_id'.tr,
                                value: student.studentSystemId,
                              ),
                            ],
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
                        color: _statusColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: smallText(
                        text: student.status,
                        color: _statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(14),
              _sectionTitle('student_overview'.tr),
              verticalSpace(10),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  SizedBox(
                    width: (1.sw - 16.w * 2 - 10.w) / 2,
                    child: _statTile(
                      label: 'roll_number'.tr,
                      value: student.rollNumber,
                      icon: Icons.confirmation_number_outlined,
                      accentColor: const Color(0xFF2F80ED),
                    ),
                  ),
                  SizedBox(
                    width: (1.sw - 16.w * 2 - 10.w) / 2,
                    child: _statTile(
                      label: 'batch_started_at'.tr,
                      value: formatDate(student.batchStartedAt),
                      icon: Icons.event_available_rounded,
                      accentColor: const Color(0xFFF28C28),
                    ),
                  ),
                  SizedBox(
                    width: (1.sw - 16.w * 2 - 10.w) / 2,
                    child: _statTile(
                      label: 'guardian_phone'.tr,
                      value: student.guardianPhone,
                      icon: Icons.phone_rounded,
                      accentColor: const Color(0xFF11A36A),
                    ),
                  ),
                  SizedBox(
                    width: (1.sw - 16.w * 2 - 10.w) / 2,
                    child: _statTile(
                      label: 'student_system_id'.tr,
                      value: student.studentSystemId,
                      icon: Icons.badge_rounded,
                      accentColor: const Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
              verticalSpace(14),
              _paidMonthsSection(),
              verticalSpace(14),
              _sectionTitle('payment_details'.tr),
              verticalSpace(10),
              _infoCard(
                label: 'monthly_fee'.tr,
                value: student.monthlyFee.toStringAsFixed(0),
                icon: Icons.payments_outlined,
              ),
              verticalSpace(10),
              _infoCard(
                label: 'discount_percent'.tr,
                value: student.discount.toStringAsFixed(0),
                icon: Icons.local_offer_outlined,
              ),
              verticalSpace(10),
              _infoCard(
                label: 'payable_fee'.tr,
                value: _payableMonthlyAmount.toStringAsFixed(0),
                icon: Icons.account_balance_wallet_outlined,
              ),
              verticalSpace(14),
              _sectionTitle('other_info'.tr),
              verticalSpace(10),
              _infoCard(
                label: 'notes'.tr,
                value: student.notes.trim().isEmpty ? '-' : student.notes,
                icon: Icons.notes_rounded,
              ),
              verticalSpace(18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onEdit,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        minimumSize: Size.fromHeight(50.h),
                      ),
                      child: smallText(
                        text: 'edit'.tr,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        minimumSize: Size.fromHeight(50.h),
                      ),
                      child: brandText(
                        text: 'close'.tr,
                        color: AppColors.whiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(18),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          smallText(
            text: '$label: ',
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          smallText(
            text: value,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
