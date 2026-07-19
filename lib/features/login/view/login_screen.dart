import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/icons_path.dart';
import '../../../core/global/app_btn.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/spacing.dart';
import '../../../core/global/text_form_field.dart';
import '../../../core/service/image/app_network_image_v2.dart';
import '../../splash/controller/splash_controller.dart';
import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(18),
              Center(
                child: Hero(
                  tag: SplashController.logoHeroTag,
                  child: ResponsiveImage.asset(
                    assetPath: IconsPath.appIcon,
                    shape: ImageShape.roundedRectangle,
                    width: 72.w,
                    height: 72.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              verticalSpace(18),
              Center(
                child: brandText(
                  text: 'স্বাগতম! 👋',
                  color: AppColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              verticalSpace(8),
              Center(
                child: normalText(
                  text: 'এন্ট্রি লগইন করে আপনার ব্যাচ ও স্টুডেন্ট ম্যানেজ করুন',
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
              verticalSpace(28),
              GlobalTextField(
                controller: controller.emailController,
                hintText: 'ইমেইল',
                labelText: 'ইমেইল',
                isMandatory: true,
                keyboardType: TextInputType.emailAddress,
                borderRadius: 10,
              ),
              verticalSpace(16),
              GlobalTextField(
                controller: controller.passwordController,
                hintText: '******',
                labelText: 'পাসওয়ার্ড',
                isMandatory: true,
                isHidden: true,
                borderRadius: 10,
              ),
              verticalSpace(8),
              Align(
                alignment: Alignment.centerRight,
                child: smallText(
                  text: 'পাসওয়ার্ড ভুলে গিয়েছেন?',
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalSpace(26),
              Obx(
                () => GlobalAppButton(
                  text: 'লগ-ইন করুন',
                  onTap: controller.login,
                  height: 52.h,
                  borderRadius: 10,
                  isLoading: controller.isLoading.value,
                ),
              ),
              verticalSpace(18),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    smallText(
                      text: 'একাউন্ট নেই? ',
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                    smallText(
                      text: 'রেজিস্টার করুন',
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}
