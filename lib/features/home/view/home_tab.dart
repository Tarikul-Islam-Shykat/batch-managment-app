import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/app_btn.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/spacing.dart';
import '../../navbar/controller/navbar_controller.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final navbarController = Get.find<NavbarController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: normalText(
          text: 'home'.tr,
          fontWeight: FontWeight.w700,
          color: AppColors.blackColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    brandText(
                      text: 'welcome'.tr,
                      color: AppColors.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                    verticalSpace(8),
                    normalText(
                      text: 'home_subtitle'.tr,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              verticalSpace(16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(title: 'batches'.tr, value: '3'),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SummaryCard(title: 'students'.tr, value: '84'),
                  ),
                ],
              ),
              verticalSpace(16),
              GlobalAppButton(
                text: 'create_batch'.tr,
                onTap: () => navbarController.switchTab(2),
                height: 52.h,
                borderRadius: 12,
              ),
              verticalSpace(12),
              GlobalAppButton(
                text: 'batches'.tr,
                onTap: () => navbarController.switchTab(1),
                height: 52.h,
                borderRadius: 12,
                backgroundColor: AppColors.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          smallText(
            text: title,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
          verticalSpace(8),
          brandText(
            text: value,
            color: AppColors.blackColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ],
      ),
    );
  }
}
