import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/localization/localization_extension.dart';
import '../bloc/create_batch_state.dart';

class ScheduleCard extends StatelessWidget {
  final int index;
  final DayScheduleItemData item;
  final VoidCallback onResetDefault;
  final Future<void> Function() onPickStartTime;
  final Future<void> Function() onPickEndTime;

  const ScheduleCard({
    super.key,
    required this.index,
    required this.item,
    required this.onResetDefault,
    required this.onPickStartTime,
    required this.onPickEndTime,
  });

  String _formatTime12h(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _getLocalizedDay(BuildContext context, String day) {
    switch (day.toLowerCase()) {
      case 'saturday':
        return context.tr('day_saturday');
      case 'sunday':
        return context.tr('day_sunday');
      case 'monday':
        return context.tr('day_monday');
      case 'tuesday':
        return context.tr('day_tuesday');
      case 'wednesday':
        return context.tr('day_wednesday');
      case 'thursday':
        return context.tr('day_thursday');
      case 'friday':
        return context.tr('day_friday');
      default:
        return day;
    }
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000710),
          ),
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14.sp,
                    color: const Color(0xFF000710),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.access_time_rounded,
                  size: 20.sp,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF000710).withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getLocalizedDay(context, item.day),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000710),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onResetDefault,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  context.tr('reset_to_default'),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12.sp,
                    color: const Color(0xFF0066FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _buildTimeField(
                  label: context.tr('start_time'),
                  value: _formatTime12h(item.startTime),
                  onTap: onPickStartTime,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTimeField(
                  label: context.tr('end_time'),
                  value: _formatTime12h(item.endTime),
                  onTap: onPickEndTime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
