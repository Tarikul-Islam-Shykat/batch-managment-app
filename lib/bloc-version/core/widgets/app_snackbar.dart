import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackbarType { success, error, warning, info }

/// Pure Flutter Native AppSnackbar (0 GetX dependency!)
class AppSnackbar {
  /// General show method
  static void show({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: isSuccess ? SnackbarType.success : SnackbarType.error,
    );
  }

  /// Specific helpers
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.success,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.error,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.warning,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.info,
    );
  }

  /// Internal SnackBar Builder using ScaffoldMessenger
  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required SnackbarType type,
  }) {
    final config = _getSnackbarConfig(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        padding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: config.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: config.shadowColor.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                config.icon,
                color: Colors.white,
                size: 26.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static _SnackbarConfig _getSnackbarConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(
          title: 'Success',
          gradientColors: [const Color(0xFF00F260), const Color(0xFF0575E6)],
          shadowColor: const Color(0xFF00F260),
          icon: Icons.check_circle_rounded,
        );
      case SnackbarType.error:
        return _SnackbarConfig(
          title: 'Error',
          gradientColors: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
          shadowColor: const Color(0xFFFF416C),
          icon: Icons.error_rounded,
        );
      case SnackbarType.warning:
        return _SnackbarConfig(
          title: 'Warning',
          gradientColors: [const Color(0xFFFFB75E), const Color(0xFFED8F03)],
          shadowColor: const Color(0xFFFFB75E),
          icon: Icons.warning_rounded,
        );
      case SnackbarType.info:
        return _SnackbarConfig(
          title: 'Info',
          gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
          shadowColor: const Color(0xFF667eea),
          icon: Icons.info_rounded,
        );
    }
  }
}

class _SnackbarConfig {
  final String title;
  final List<Color> gradientColors;
  final Color shadowColor;
  final IconData icon;

  _SnackbarConfig({
    required this.title,
    required this.gradientColors,
    required this.shadowColor,
    required this.icon,
  });
}
