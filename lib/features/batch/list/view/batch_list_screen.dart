import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/loading.dart';
import '../controller/batch_list_controller.dart';
import '../widget/batch_card.dart';

class BatchListScreen extends GetView<BatchListController> {
  const BatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: normalText(
          text: 'batches'.tr,
          fontWeight: FontWeight.w700,
          color: AppColors.blackColor,
        ),
        actions: [
          IconButton(
            onPressed: () => controller.refreshBatches(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Obx(
                () => Row(
                  children: controller.statusOptions.map((status) {
                    final isSelected =
                        controller.selectedStatus.value == status;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: status == controller.statusOptions.last
                              ? 0
                              : 8.w,
                        ),
                        child: GestureDetector(
                          onTap: () => controller.setStatus(status),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.blackColor.withValues(
                                        alpha: 0.06,
                                      ),
                              ),
                            ),
                            child: Center(
                              child: smallText(
                                text: _statusLabel(status),
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.batches.isEmpty) {
                  return Center(child: loading());
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshBatches,
                  child: controller.batches.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16.w),
                          children: [
                            SizedBox(height: 120.h),
                            Center(
                              child: normalText(
                                text: 'no_batches_found'.tr,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                          itemBuilder: (context, index) {
                            if (index == controller.batches.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: controller.isLoadingMore.value
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : const SizedBox.shrink(),
                              );
                            }

                            final batch = controller.batches[index];
                            return BatchCard(
                              batch: batch,
                              controller: controller,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemCount:
                              controller.batches.length +
                              (controller.isLoadingMore.value ? 1 : 0),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'current':
        return 'current_batches'.tr;
      case 'upcoming':
        return 'upcoming_batches'.tr;
      case 'ended':
        return 'ended_batches'.tr;
      default:
        return status;
    }
  }
}
