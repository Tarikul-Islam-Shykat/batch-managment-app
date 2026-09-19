import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show({
    required String message,
    required bool isSuccess,
    Duration? duration,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: _buildSnackbarContent(message, isSuccess),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.zero,
      borderRadius: 16.r,
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 600),
      overlayBlur: 0,
      snackStyle: SnackStyle.FLOATING,
      maxWidth: 500.w,
    );
  }

  static void success(String message, {Duration? duration}) {
    show(message: message, isSuccess: true, duration: duration);
  }

  static void error(String message, {Duration? duration}) {
    show(message: message, isSuccess: false, duration: duration);
  }

  static Widget _buildSnackbarContent(String message, bool isSuccess) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSuccess ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSuccess
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSuccess
                  ? Colors.black.withOpacity(0.15)
                  : Colors.white.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: isSuccess
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 4),
              spreadRadius: -5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isSuccess
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSuccess
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: _AnimatedIcon(
                  icon: isSuccess
                      ? Icons.check_circle_rounded
                      : Icons.error_rounded,
                  color: isSuccess
                      ? Colors.green.shade600
                      : Colors.red.shade400,
                  size: 24.sp,
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        isSuccess ? 'Success' : 'Error',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isSuccess ? Colors.black : Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? Colors.green.shade600
                              : Colors.red.shade400,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isSuccess
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.red.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSuccess
                          ? Colors.black.withOpacity(0.7)
                          : Colors.white.withOpacity(0.8),
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Dismiss Button
            GestureDetector(
              onTap: () => Get.closeCurrentSnackbar(),
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? Colors.black.withOpacity(0.05)
                      : Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSuccess
                        ? Colors.black.withOpacity(0.08)
                        : Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: isSuccess
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Alternative compact version
  static void showCompact({
    required String message,
    required bool isSuccess,
    Duration? duration,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: _buildCompactContent(message, isSuccess),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      padding: EdgeInsets.zero,
      borderRadius: 50.r,
      duration: duration ?? const Duration(seconds: 2),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static Widget _buildCompactContent(String message, bool isSuccess) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: isSuccess
              ? Colors.white.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSuccess
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: isSuccess ? Colors.green.shade400 : Colors.red.shade400,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSuccess ? Colors.white : Colors.black,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Premium version with progress indicator
  static void showPremium({
    required String message,
    required bool isSuccess,
    Duration? duration,
  }) {
    final durationMs = (duration ?? const Duration(seconds: 3)).inMilliseconds;

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: _PremiumSnackbarContent(
        message: message,
        isSuccess: isSuccess,
        duration: durationMs,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.zero,
      borderRadius: 16.r,
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 500),
      snackStyle: SnackStyle.FLOATING,
    );
  }
}

class _AnimatedIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _AnimatedIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value * 0.5,
            child: Icon(widget.icon, color: widget.color, size: widget.size),
          ),
        );
      },
    );
  }
}

class _PremiumSnackbarContent extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final int duration;

  const _PremiumSnackbarContent({
    required this.message,
    required this.isSuccess,
    required this.duration,
  });

  @override
  State<_PremiumSnackbarContent> createState() =>
      _PremiumSnackbarContentState();
}

class _PremiumSnackbarContentState extends State<_PremiumSnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isSuccess ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: widget.isSuccess
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isSuccess
                ? Colors.black.withOpacity(0.15)
                : Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: widget.isSuccess
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _AnimatedIcon(
                      icon: widget.isSuccess
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
                      color: widget.isSuccess
                          ? Colors.green.shade600
                          : Colors.red.shade400,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isSuccess ? 'Success' : 'Error',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: widget.isSuccess ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.message,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: widget.isSuccess
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.closeCurrentSnackbar(),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20.sp,
                    color: widget.isSuccess
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Progress Bar
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: 1 - _progressController.value,
                backgroundColor: widget.isSuccess
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(
                  widget.isSuccess
                      ? Colors.green.shade600
                      : Colors.red.shade400,
                ),
                minHeight: 3.h,
              );
            },
          ),
        ],
      ),
    );
  }
}
