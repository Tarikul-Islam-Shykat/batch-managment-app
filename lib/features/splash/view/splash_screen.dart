import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/icons_path.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/loading.dart';
import '../../../core/global/spacing.dart';
import '../../../core/service/image/app_network_image_v2.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: SplashController.logoHeroTag,
                      child: ResponsiveImage.asset(
                        assetPath: IconsPath.appIcon,
                        shape: ImageShape.roundedRectangle,
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    verticalSpace(12),
                    brandText(
                      text: 'app_brand'.tr,
                      color: const Color(0xFF8A8A8A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3.2,
                    ),
                    verticalSpace(2),
                    brandText(
                      text: 'app_name_bn'.tr,
                      color: AppColors.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: loading(),
            ),
          ],
        ),
      ),
    );
  }
}
