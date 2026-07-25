import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/loading.dart';
import '../../../../core/global/spacing.dart';
import '../controller/batch_history_controller.dart';
import '../model/batch_history_entry_model.dart';

class BatchHistoryScreen extends GetView<BatchHistoryController> {
  const BatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              brandText(
                text: 'batch_history'.tr,
                color: AppColors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                textAlign: TextAlign.start,
              ),
              if (controller.batchName.value.isNotEmpty)
                smallText(
                  text: controller.batchName.value,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.refreshHistory,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.entries.isEmpty) {
            return Center(child: loading());
          }

          return RefreshIndicator(
            onRefresh: controller.refreshHistory,
            child: controller.entries.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.w),
                    children: [
                      SizedBox(height: 120.h),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.history_toggle_off_rounded,
                              size: 54.sp,
                              color: Colors.black26,
                            ),
                            verticalSpace(10),
                            normalText(
                              text: 'no_history_found'.tr,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
                    itemCount: controller.entries.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return _HistoryCard(
                        entry: controller.entries[index],
                        formatTime: controller.formatTime,
                      );
                    },
                  ),
          );
        }),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final BatchHistoryEntryModel entry;
  final String Function(String value) formatTime;

  const _HistoryCard({required this.entry, required this.formatTime});

  Color _badgeColor() {
    final action = entry.action.toLowerCase();
    if (action.contains('delete')) return const Color(0xFFEF4444);
    if (action.contains('create')) return const Color(0xFF16A34A);
    if (action.contains('update') || action.contains('edit')) {
      return const Color(0xFFF59E0B);
    }
    return AppColors.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _badgeColor();
    final details = entry.details.entries.toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: smallText(
                  text: entry.action.isNotEmpty ? entry.action : 'history'.tr,
                  color: badgeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (entry.createdAt.isNotEmpty)
                smallText(
                  text: formatTime(entry.createdAt),
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  textAlign: TextAlign.end,
                ),
            ],
          ),
          verticalSpace(10),
          brandText(
            text: entry.title,
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            textAlign: TextAlign.start,
            maxLines: 2,
          ),
          if (entry.description.isNotEmpty) ...[
            verticalSpace(6),
            normalText(
              text: entry.description,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              maxLines: 4,
              textAlign: TextAlign.start,
            ),
          ],
          if (details.isNotEmpty) ...[
            verticalSpace(12),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: details.take(4).map((item) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.blackColor.withValues(alpha: 0.06),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: '${item.key}: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: item.value.toString(),
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (entry.actorName.isNotEmpty || entry.actorRole.isNotEmpty) ...[
            verticalSpace(12),
            Row(
              children: [
                if (entry.actorName.isNotEmpty)
                  Expanded(
                    child: labelValueText(
                      label: '${'actor'.tr}: ',
                      value: entry.actorName,
                      labelColor: Colors.black54,
                      valueColor: AppColors.blackColor,
                      labelWeight: FontWeight.w500,
                      valueWeight: FontWeight.w700,
                      maxLines: 1,
                    ),
                  ),
                if (entry.actorRole.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: smallText(
                      text: entry.actorRole,
                      color: badgeColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
