import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/app_btn.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/spacing.dart';
import '../controller/otp_verification_controller.dart';

class OtpVerificationScreen extends GetView<OtpVerificationController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: false,
        title: brandText(
          text: 'otp_verification_title'.tr,
          color: AppColors.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              brandText(
                text: controller.name.isEmpty
                    ? 'check_email_for_otp'.tr
                    : '${controller.name}, ${'check_email_for_otp'.tr}',
                color: AppColors.blackColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                maxLines: 2,
              ),
              verticalSpace(8),
              normalText(
                text: controller.email.isEmpty
                    ? 'otp_sent_to_email'.tr
                    : '${'otp_sent_to_email'.tr} ${controller.email}',
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                maxLines: 3,
              ),
              if (controller.role.isNotEmpty || controller.emailVerified) ...[
                verticalSpace(10),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    if (controller.role.isNotEmpty)
                      _InfoChip(label: controller.role),
                    _InfoChip(
                      label: controller.emailVerified
                          ? 'email_verified'.tr
                          : 'email_not_verified'.tr,
                    ),
                    _InfoChip(
                      label: controller.verificationSent
                          ? 'verification_sent'.tr
                          : 'verification_pending'.tr,
                    ),
                  ],
                ),
              ],
              verticalSpace(28),
              Row(
                children: [
                  normalText(
                    text: 'otp_code'.tr,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(width: 4.w),
                  smallText(
                    text: '*',
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              verticalSpace(8),
              Pinput(
                controller: controller.otpController,
                length: 6,
                autofocus: true,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  width: 48.w,
                  height: 54.w,
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.blackColor.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 48.w,
                  height: 54.w,
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.6,
                    ),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 48.w,
                  height: 54.w,
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.blackColor.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 18.w,
                      height: 2.h,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              verticalSpace(18),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.resendOtp,
                  child: smallText(
                    text: 'resend_otp'.tr,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              verticalSpace(24),
              Obx(
                () => GlobalAppButton(
                  text: 'verify_otp'.tr,
                  onTap: controller.verifyOtp,
                  height: 52.h,
                  borderRadius: 10,
                  isLoading: controller.isLoading.value,
                ),
              ),
              verticalSpace(18),
              Center(
                child: GestureDetector(
                  onTap: controller.backToLogin,
                  child: smallText(
                    text: 'back_to_login'.tr,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
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

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: smallText(
        text: label,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
