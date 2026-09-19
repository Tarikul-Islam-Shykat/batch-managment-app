import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/batch_students_cubit.dart';
import '../bloc/batch_students_state.dart';
import 'batch_payment_statement_sheet.dart';

class BatchFinanceOverviewCard extends StatelessWidget {
  final BatchStudentsCubit cubit;
  final BatchStudentsState state;

  const BatchFinanceOverviewCard({
    super.key,
    required this.cubit,
    required this.state,
  });

  void _openStatementSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BatchPaymentStatementSheet(cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = state.financeSummary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Finance Overview',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000710),
                ),
              ),
              TextButton.icon(
                onPressed: () => _openStatementSheet(context),
                icon: Icon(Icons.receipt_long_rounded, size: 16.sp),
                label: Text(
                  'Statement',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0066FF),
                  backgroundColor: const Color(
                    0xFF0066FF,
                  ).withValues(alpha: 0.08),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                'Month: ',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                state.selectedFinanceMonth,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.sp,
                  color: const Color(0xFF000710),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (summary != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF11A36A).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Collected',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '৳${summary.totalPaidAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF11A36A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEB5757).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '৳${summary.remainingAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFEB5757),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
