import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;
  final Color accentColor;

  const FeedItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    this.accentColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: accentColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? '-' : title,
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF000710),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.trim().isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.black54,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing.trim().isNotEmpty)
            Container(
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                trailing,
                style: GoogleFonts.spaceGrotesk(
                  color: accentColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
