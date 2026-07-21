import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/spacing.dart';

class AppMaintenanceScreen extends StatefulWidget {
  const AppMaintenanceScreen({super.key});

  @override
  State<AppMaintenanceScreen> createState() => _AppMaintenanceScreenState();
}

class _AppMaintenanceScreenState extends State<AppMaintenanceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Map<String, dynamic> get _args =>
      Map<String, dynamic>.from(Get.arguments as Map? ?? {});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = _args['maintenance_message']?.toString() ?? '';
    final appStatus = _args['app_status']?.toString() ?? 'maintenance';

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final t = _controller.value;
                  return CustomPaint(
                    painter: _MaintenanceBackdropPainter(progress: t),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final scale = 0.92 + (_controller.value * 0.10);
                      final opacity = 0.85 + (_controller.value * 0.15);
                      return Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Transform.scale(scale: scale, child: child),
                      );
                    },
                    child: Container(
                      width: 104.w,
                      height: 104.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primaryColor.withValues(alpha: 0.20),
                            AppColors.primaryColor.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.construction_rounded,
                        size: 50.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  verticalSpace(24),
                  brandText(
                    text: 'maintenance_page_title'.tr,
                    color: AppColors.blackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  verticalSpace(8),
                  normalText(
                    text: message.isNotEmpty
                        ? message
                        : 'maintenance_page_default'.tr,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  ),
                  verticalSpace(18),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFF),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: AppColors.blackColor.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelValueText(
                          label: '${'status'.tr}: ',
                          value: appStatus,
                          labelColor: Colors.black54,
                          valueColor: AppColors.primaryColor,
                        ),
                        verticalSpace(8),
                        normalText(
                          text: 'maintenance_hint'.tr,
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: SystemNavigator.pop,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: brandText(
                        text: 'exit_app'.tr,
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  verticalSpace(12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceBackdropPainter extends CustomPainter {
  final double progress;

  const _MaintenanceBackdropPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = AppColors.primaryColor.withValues(alpha: 0.05);
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.16),
      size.width * (0.18 + (progress * 0.06)),
      paint,
    );

    paint.color = AppColors.primaryColor.withValues(alpha: 0.04);
    canvas.drawCircle(
      Offset(size.width * 0.80, size.height * 0.30),
      size.width * (0.12 + (progress * 0.04)),
      paint,
    );

    paint.color = AppColors.primaryColor.withValues(alpha: 0.03);
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.82),
      size.width * (0.22 + (progress * 0.08)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MaintenanceBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
