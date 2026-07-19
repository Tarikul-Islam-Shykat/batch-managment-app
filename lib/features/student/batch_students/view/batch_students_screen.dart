import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/loading.dart';
import '../../../../core/global/spacing.dart';
import '../../../../core/global/text_form_field.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../controller/batch_students_controller.dart';
import '../widget/batch_student_card.dart';
import '../widget/batch_students_header_card.dart';
import '../widget/batch_students_summary_card.dart';

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
        centerTitle: false,
        titleSpacing: 0,
        title: Obx(() {
          final batch = _batch;
          return brandText(
            text: batch?.batchName ?? 'batch_students_title'.tr,
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            textAlign: TextAlign.start,
          );
        }),
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
          final visibleStudents = controller.filteredStudents;

          if (controller.isLoading.value && controller.students.isEmpty) {
            return Center(child: loading());
          }

          return RefreshIndicator(
            onRefresh: controller.refreshStudents,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
              children: [
                if (batch != null) ...[
                  BatchStudentsHeaderCard(batch: batch, controller: controller),
                  verticalSpace(14),
                ],
                Row(
                  children: [
                    Expanded(
                      child: BatchStudentsSummaryCard(
                        label: 'total_fee'.tr,
                        value: controller.totalFee.toStringAsFixed(0),
                        icon: Icons.warning_amber_rounded,
                        accentColor: const Color(0xFF2F80ED),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: BatchStudentsSummaryCard(
                        label: 'total_payable'.tr,
                        value: controller.totalPayable.toStringAsFixed(0),
                        icon: Icons.timelapse_rounded,
                        accentColor: const Color(0xFFF28C28),
                      ),
                    ),
                  ],
                ),
                verticalSpace(14),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          brandText(
                            text: 'student_list'.tr,
                            color: AppColors.blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(width: 8.w),
                          normalText(
                            text:
                                '${visibleStudents.length} ${'students_unit'.tr}',
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    if (controller.searchQuery.value.isNotEmpty)
                      TextButton(
                        onPressed: controller.clearSearch,
                        child: smallText(
                          text: 'clear'.tr,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
                verticalSpace(10),
                GlobalTextField(
                  controller: controller.searchController,
                  hintText: 'search_students'.tr,
                  prefixIcon: const Icon(Icons.search_rounded),
                  onChanged: controller.onSearchChanged,
                ),
                verticalSpace(14),
                if (visibleStudents.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: normalText(
                        text: 'no_students_found'.tr,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  ...visibleStudents.asMap().entries.expand((entry) {
                    final index = entry.key;
                    final student = entry.value;
                    return [
                      BatchStudentCard(student: student),
                      if (index != visibleStudents.length - 1)
                        verticalSpace(12),
                    ];
                  }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
