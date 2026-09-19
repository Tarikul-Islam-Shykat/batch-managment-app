import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BatchSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String detail;
  final String progressLabel;
  final double progress;
  final int totalStudents;
  final int paidStudents;
  final String dueAmount;

  const BatchSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.progressLabel,
    required this.progress,
    required this.totalStudents,
    required this.paidStudents,
    required this.dueAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              color: const Color(0xFF000710),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.black54,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            detail,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.black54,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              minHeight: 7.h,
              value: progress,
              backgroundColor: Colors.black.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  progressLabel,
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF2563EB),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                dueAmount,
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFF000710),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            '$paidStudents Paid • $totalStudents Total',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.black54,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
