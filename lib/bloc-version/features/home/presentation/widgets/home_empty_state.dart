import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRetry;

  const HomeEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Color(0xFF2563EB),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              color: const Color(0xFF000710),
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.black54,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: 150.w,
            child: OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                side: const BorderSide(color: Color(0xFF2563EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
