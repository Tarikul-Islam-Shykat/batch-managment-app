import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/maintenance_backdrop_painter.dart';

class AppMaintenanceView extends StatefulWidget {
  final String? maintenanceMessage;
  final String? appStatus;

  const AppMaintenanceView({
    super.key,
    this.maintenanceMessage,
    this.appStatus,
  });

  @override
  State<AppMaintenanceView> createState() => _AppMaintenanceViewState();
}

class _AppMaintenanceViewState extends State<AppMaintenanceView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    final message = widget.maintenanceMessage?.trim() ?? '';
    final status = widget.appStatus?.trim().isNotEmpty == true
        ? widget.appStatus!.trim().toUpperCase()
        : 'MAINTENANCE';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: MaintenanceBackdropPainter(
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  const Spacer(),

                  // Animated Maintenance Icon
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
                      width: 108.w,
                      height: 108.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF2563EB).withValues(alpha: 0.20),
                            const Color(0xFF2563EB).withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.construction_rounded,
                        size: 52.sp,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Title
                  Text(
                    'Under Maintenance',
                    style: GoogleFonts.spaceGrotesk(
                      color: const Color(0xFF000710),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),

                  // Message
                  Text(
                    message.isNotEmpty
                        ? message
                        : 'Our platform is currently undergoing scheduled system maintenance to serve you better. Please check back shortly.',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.black54,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                  SizedBox(height: 24.h),

                  // Status Info Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFF),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Status: ',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.black54,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF59E0B,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                status,
                                style: GoogleFonts.spaceGrotesk(
                                  color: const Color(0xFFF59E0B),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'We apologize for the inconvenience. Our engineering team is actively working to restore complete operations.',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black45,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Exit App Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: SystemNavigator.pop,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF000710),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Exit Application',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
