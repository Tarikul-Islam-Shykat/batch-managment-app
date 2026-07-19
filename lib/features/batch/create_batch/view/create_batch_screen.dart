import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/app_btn.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../../../../core/global/text_form_field.dart';
import '../controller/create_batch_controller.dart';
import '../widget/schedule_card.dart';

class CreateBatchScreen extends GetView<CreateBatchController> {
  const CreateBatchScreen({super.key});

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
          text: 'create_batch_title'.tr,
          fontWeight: FontWeight.w700,
          color: AppColors.blackColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalTextField(
                        controller: controller.batchNameController,
                        hintText: 'batch_name'.tr,
                        labelText: 'batch_name'.tr,
                        isMandatory: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'enter_batch_name'.tr;
                          }
                          return null;
                        },
                      ),
                      verticalSpace(14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          normalText(
                            text: 'subject_name'.tr,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.blackColor.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.add, size: 18),
                          ),
                        ],
                      ),
                      verticalSpace(6),
                      GlobalTextField(
                        controller: controller.subjectController,
                        hintText: 'subject'.tr,
                        isMandatory: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'enter_subject'.tr;
                          }
                          return null;
                        },
                      ),
                      verticalSpace(14),
                      GlobalTextField(
                        controller: controller.feesController,
                        hintText: 'fees'.tr,
                        labelText: 'fees_per_student'.tr,
                        isMandatory: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'enter_fees'.tr;
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'enter_number'.tr;
                          }
                          return null;
                        },
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Center(
                            widthFactor: 0,
                            child: smallText(
                              text: ' / ${'student'.tr}',
                              color: Colors.black87,
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
                              controller: controller.startDateController,
                              hintText: 'start_date'.tr,
                              labelText: 'start_date'.tr,
                              isMandatory: true,
                              readOnly: true,
                              onTap: () => controller.pickStartDate(context),
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GlobalTextField(
                              controller: controller.endDateController,
                              hintText: 'end_date'.tr,
                              labelText: 'end_date'.tr,
                              isMandatory: true,
                              readOnly: true,
                              onTap: () => controller.pickEndDate(context),
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(16),

                      GlobalTextField(
                        controller: controller.maxStudentsController,
                        hintText: 'max_students'.tr,
                        labelText: 'max_students'.tr,
                        isMandatory: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'enter_max_students'.tr;
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'enter_number'.tr;
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16),
                      Row(
                        children: [
                          normalText(
                            text: 'default_class_time'.tr,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: controller.applyDefaultTimeToAll,
                            child: smallText(
                              text: 'apply_to_all_days'.tr,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(10),
                      Row(
                        children: [
                          Expanded(
                            child: GlobalTextField(
                              controller: controller.defaultStartTimeController,
                              hintText: 'start_time'.tr,
                              labelText: 'start_time'.tr,
                              isMandatory: true,
                              readOnly: true,
                              onTap: () =>
                                  controller.pickDefaultStartTime(context),
                              suffixIcon: const Icon(Icons.access_time_rounded),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GlobalTextField(
                              controller: controller.defaultEndTimeController,
                              hintText: 'end_time'.tr,
                              labelText: 'end_time'.tr,
                              isMandatory: true,
                              readOnly: true,
                              onTap: () =>
                                  controller.pickDefaultEndTime(context),
                              suffixIcon: const Icon(Icons.access_time_rounded),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(16),
                      normalText(
                        text: 'class_days'.tr,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      verticalSpace(10),
                      Obx(
                        () => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.days.map((day) {
                            final selected = controller.selectedDays.contains(
                              day.value,
                            );
                            return ChoiceChip(
                              showCheckmark: true,
                              checkmarkColor: Colors.white,
                              label: normalText(
                                text: day.label,
                                color: selected
                                    ? Colors.white
                                    : AppColors.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              selected: selected,
                              selectedColor: AppColors.blackColor,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                side: BorderSide(
                                  color: selected
                                      ? AppColors.blackColor
                                      : AppColors.blackColor.withValues(
                                          alpha: 0.15,
                                        ),
                                ),
                              ),
                              onSelected: (_) =>
                                  controller.toggleDay(day.value),
                            );
                          }).toList(),
                        ),
                      ),
                      verticalSpace(14),
                      Obx(
                        () => controller.scheduleItems.isEmpty
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  for (
                                    int index = 0;
                                    index < controller.scheduleItems.length;
                                    index++
                                  )
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: ScheduleCard(
                                        index: index,
                                        controller: controller,
                                      ),
                                    ),
                                ],
                              ),
                      ),
                      verticalSpace(24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clearForm();
                        Get.back();
                      },
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
                        text: 'create_batch'.tr,
                        onTap: controller.createBatch,
                        isLoading: controller.isLoading.value,
                        height: 52.h,
                        borderRadius: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
