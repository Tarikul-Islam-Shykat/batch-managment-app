import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/app_btn.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../../../../core/global/text_form_field.dart';
import '../controller/student_enroll_controller.dart';

class StudentEnrollScreen extends GetView<StudentEnrollController> {
  const StudentEnrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: normalText(
          text: 'student_enroll_title'.tr,
          fontWeight: FontWeight.w700,
          color: AppColors.blackColor,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalTextField(
                  controller: controller.studentNameController,
                  hintText: 'enter_student_name'.tr,
                  labelText: 'student_name'.tr,
                  isMandatory: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'enter_student_name'.tr;
                    }
                    return null;
                  },
                ),
                verticalSpace(14),
                GlobalTextField(
                  controller: controller.rollNumberController,
                  hintText: 'enter_roll_number'.tr,
                  labelText: 'roll_number'.tr,
                  isMandatory: true,
                  isDigitOnly: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'enter_roll_number'.tr;
                    }
                    return null;
                  },
                ),
                verticalSpace(14),
                GlobalTextField(
                  controller: controller.guardianPhoneController,
                  hintText: 'enter_guardian_phone'.tr,
                  labelText: 'guardian_phone'.tr,
                  isMandatory: true,
                  isDigitOnly: true,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'enter_guardian_phone'.tr;
                    }
                    return null;
                  },
                ),
                verticalSpace(14),
                GlobalTextField(
                  controller: controller.batchNameController,
                  hintText: 'batch_name'.tr,
                  labelText: 'batch_name'.tr,
                  isMandatory: false,
                  readOnly: true,
                ),
                verticalSpace(14),
                GlobalTextField(
                  controller: controller.monthlyFeeController,
                  hintText: 'monthly_fee'.tr,
                  labelText: 'monthly_fee'.tr,
                  isMandatory: false,
                  readOnly: true,
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Center(
                      widthFactor: 0,
                      child: smallText(
                        text: 'automatic'.tr,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                verticalSpace(14),
                Row(
                  children: [
                    Expanded(
                      child: GlobalTextField(
                        controller: controller.discountController,
                        hintText: 'enter_discount'.tr,
                        labelText: 'discount_percent'.tr,
                        isMandatory: true,
                        isDigitOnly: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final discount = int.tryParse(value?.trim() ?? '');
                          if (discount == null) {
                            return 'enter_discount'.tr;
                          }
                          if (discount < 0 || discount > 100) {
                            return 'discount_between_0_100'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GlobalTextField(
                        controller: controller.payableFeeController,
                        hintText: 'payable_fee'.tr,
                        labelText: 'payable_fee'.tr,
                        isMandatory: false,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                verticalSpace(14),
                GlobalTextField(
                  controller: controller.batchStartedAtController,
                  hintText: 'batch_started_at'.tr,
                  labelText: 'batch_started_at'.tr,
                  isMandatory: true,
                  readOnly: true,
                  onTap: () => controller.pickBatchStartedDate(context),
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'select_start_date'.tr;
                    }
                    return null;
                  },
                ),
                verticalSpace(14),
                GlobalTextField(
                  controller: controller.notesController,
                  hintText: 'enter_notes'.tr,
                  labelText: 'notes'.tr,
                  maxLines: 4,
                ),
                verticalSpace(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: Get.back,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          minimumSize: Size.fromHeight(52.h),
                        ),
                        child: normalText(
                          text: 'cancel'.tr,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Obx(
                        () => GlobalAppButton(
                          text: 'save_student'.tr,
                          onTap: controller.submit,
                          isLoading: controller.isLoading.value,
                          height: 52.h,
                          borderRadius: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
