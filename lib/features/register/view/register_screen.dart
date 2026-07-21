import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/app_btn.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/spacing.dart';
import '../../../core/global/text_form_field.dart';
import '../controller/register_controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: false,
        title: brandText(
          text: 'create_account'.tr,
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
                text: 'registration_title'.tr,
                color: AppColors.blackColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
              verticalSpace(8),
              normalText(
                text: 'registration_subtitle'.tr,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                maxLines: 2,
              ),
              verticalSpace(28),
              GlobalTextField(
                controller: controller.nameController,
                hintText: 'enter_name'.tr,
                labelText: 'name'.tr,
                isMandatory: true,
                borderRadius: 10,
              ),
              verticalSpace(16),
              GlobalTextField(
                controller: controller.emailController,
                hintText: 'email'.tr,
                labelText: 'email'.tr,
                isMandatory: true,
                keyboardType: TextInputType.emailAddress,
                borderRadius: 10,
              ),
              verticalSpace(16),
              GlobalTextField(
                controller: controller.passwordController,
                hintText: '******',
                labelText: 'password'.tr,
                isMandatory: true,
                isHidden: true,
                borderRadius: 10,
              ),
              verticalSpace(16),
              GlobalTextField(
                controller: controller.confirmPasswordController,
                hintText: '******',
                labelText: 'confirm_password'.tr,
                isMandatory: true,
                isHidden: true,
                borderRadius: 10,
              ),
              verticalSpace(26),
              Obx(
                () => GlobalAppButton(
                  text: 'sign_up'.tr,
                  onTap: controller.signUp,
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
                      text: '${'already_have_account'.tr} ',
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                    GestureDetector(
                      onTap: Get.back,
                      child: smallText(
                        text: 'login'.tr,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
