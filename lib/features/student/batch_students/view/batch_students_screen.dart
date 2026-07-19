import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/loading.dart';
import '../../../../core/global/spacing.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../controller/batch_students_controller.dart';
import '../widget/batch_student_card.dart';

class BatchStudentsScreen extends GetView<BatchStudentsController> {
  const BatchStudentsScreen({super.key});

  BatchListItemModel? get _batch => controller.selectedBatch.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: normalText(
          text: 'course_students'.tr,
          fontWeight: FontWeight.w700,
          color: AppColors.blackColor,
        ),
        actions: [
          IconButton(
            onPressed: controller.refreshStudents,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final batch = _batch;

          return Column(
            children: [
              if (batch != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
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
                        smallText(
                          text: 'course_students'.tr,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        verticalSpace(8),
                        brandText(
                          text: batch.batchName,
                          color: AppColors.blackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                        verticalSpace(4),
                        normalText(
                          text: '${'subject'.tr}: ${batch.subject}',
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        verticalSpace(4),
                        normalText(
                          text: '${'start_date'.tr}: ${batch.startDate}',
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                        verticalSpace(4),
                        normalText(
                          text: '${'end_date'.tr}: ${batch.endDate}',
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: controller.isLoading.value
                    ? Center(child: loading())
                    : RefreshIndicator(
                        onRefresh: controller.refreshStudents,
                        child: controller.students.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.all(16.w),
                                children: [
                                  SizedBox(height: 120.h),
                                  Center(
                                    child: normalText(
                                      text: 'no_students_found'.tr,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  0,
                                  16.w,
                                  16.h,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final student = controller.students[index];
                                  return BatchStudentCard(student: student);
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 12.h),
                                itemCount: controller.students.length,
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
