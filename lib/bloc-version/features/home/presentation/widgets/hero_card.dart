import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/services/router/app_router.dart';
import 'package:batch_management_app_direct/bloc-version/features/navbar/presentation/bloc/navbar_cubit.dart';
import '../../data/models/home_dashboard_model.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

class HeroCard extends StatelessWidget {
  final HomeState state;

  const HeroCard({super.key, required this.state});

  void _openMonthSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Select Month',
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF000710),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 320.h),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.monthOptions.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final month = state.monthOptions[index];
                      final selected = month == state.selectedMonth;
                      return InkWell(
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          context.read<HomeCubit>().changeMonth(month);
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(
                                    0xFF2563EB,
                                  ).withValues(alpha: 0.10)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF2563EB)
                                  : Colors.black.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  month,
                                  style: GoogleFonts.spaceGrotesk(
                                    color: const Color(0xFF000710),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF2563EB),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final batchOverview =
        state.dashboard?.batchOverview ?? const <String, dynamic>{};
    final studentOverview =
        state.dashboard?.studentOverview ?? const <String, dynamic>{};

    final totalBatches = HomeDashboardModel.intValue(batchOverview, const [
      'total_batches',
      'total',
    ]);
    final totalStudents = HomeDashboardModel.intValue(studentOverview, const [
      'total_students',
      'total',
    ]);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A66FF), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A66FF).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Teaching Analytics',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.space_dashboard_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Month Selection Card
          InkWell(
            onTap: () => _openMonthSheet(context),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: const Color(0xFF2563EB),
                    size: 18.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Month',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black54,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          state.selectedMonth.isNotEmpty
                              ? state.selectedMonth
                              : 'Current Month',
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF000710),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),

          // Mini Stats Row
          Row(
            children: [
              Expanded(
                child: _MiniStatChip(
                  label: 'Total Batches',
                  value: totalBatches.toString(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _MiniStatChip(
                  label: 'Total Students',
                  value: totalStudents.toString(),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    try {
                      context.read<NavbarCubit>().selectTab(1);
                    } catch (_) {
                      context.push(AppRouter.batches);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'View Batches',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.push(AppRouter.createBatch);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'New Batch',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
