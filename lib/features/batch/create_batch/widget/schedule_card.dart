import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/text_form_field.dart';
import '../controller/create_batch_controller.dart';

class ScheduleCard extends StatelessWidget {
  final int index;
  final CreateBatchController controller;

  const ScheduleCard({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final item = controller.scheduleItems[index];
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              normalText(
                text: controller.displayDayLabel(item.day),
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => controller.applyDefaultTimeToItem(index),
                child: smallText(
                  text: 'reset_to_default'.tr,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GlobalTextField(
                  controller: item.startController,
                  hintText: 'start_time'.tr,
                  labelText: 'start_time'.tr,
                  isMandatory: true,
                  readOnly: true,
                  onTap: () => controller.pickScheduleStartTime(context, index),
                  suffixIcon: const Icon(Icons.access_time_rounded),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GlobalTextField(
                  controller: item.endController,
                  hintText: 'end_time'.tr,
                  labelText: 'end_time'.tr,
                  isMandatory: true,
                  readOnly: true,
                  onTap: () => controller.pickScheduleEndTime(context, index),
                  suffixIcon: const Icon(Icons.access_time_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
