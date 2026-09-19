import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardMetric {
  final String label;
  final Object value;
  final IconData icon;
  final Color color;

  const DashboardMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class MetricGrid extends StatelessWidget {
  final List<DashboardMetric> items;

  const MetricGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final metric = items[index];
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: metric.color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: metric.color.withValues(alpha: 0.14)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: metric.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(metric.icon, color: metric.color, size: 18.sp),
              ),
              const Spacer(),
              Text(
                metric.label,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.black54,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                metric.value.toString(),
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFF000710),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
