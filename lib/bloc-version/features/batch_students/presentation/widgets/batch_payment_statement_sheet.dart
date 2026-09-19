import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/batch_students_cubit.dart';
import '../bloc/batch_students_state.dart';

class BatchPaymentStatementSheet extends StatelessWidget {
  final BatchStudentsCubit cubit;

  const BatchPaymentStatementSheet({super.key, required this.cubit});

  Widget _statementTile({
    required String label,
    required String value,
    required Color accentColor,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 19.sp,
                    color: const Color(0xFF000710),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BatchStudentsCubit, BatchStudentsState>(
      bloc: cubit,
      builder: (context, state) {
        final summary = state.financeSummary;

        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SingleChildScrollView(
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
                    'Finance Statement',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      color: const Color(0xFF000710),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    state.selectedFinanceMonth,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    initialValue: state.selectedFinanceMonth,
                    decoration: InputDecoration(
                      labelText: 'Finance Month',
                      labelStyle: GoogleFonts.spaceGrotesk(
                        fontSize: 13.sp,
                        color: Colors.black54,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    isExpanded: true,
                    items: state.availableFinanceMonths.map((m) {
                      return DropdownMenuItem<String>(
                        value: m,
                        child: Text(
                          m,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14.sp,
                            color: const Color(0xFF000710),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) cubit.changeFinanceMonth(val);
                    },
                  ),
                  SizedBox(height: 16.h),
                  if (state.isFinanceLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (summary == null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: Text(
                          'No finance data found.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    _statementTile(
                      label: 'Total Students',
                      value: summary.totalStudents.toString(),
                      accentColor: const Color(0xFF2F80ED),
                      icon: Icons.groups_rounded,
                    ),
                    SizedBox(height: 10.h),
                    _statementTile(
                      label: 'Paid Students',
                      value: summary.paidStudents.toString(),
                      accentColor: const Color(0xFF11A36A),
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    SizedBox(height: 10.h),
                    _statementTile(
                      label: 'Expected Amount',
                      value:
                          '৳${summary.totalExpectedAmount.toStringAsFixed(0)}',
                      accentColor: const Color(0xFFF28C28),
                      icon: Icons.payments_outlined,
                    ),
                    SizedBox(height: 10.h),
                    _statementTile(
                      label: 'Paid Amount',
                      value: '৳${summary.totalPaidAmount.toStringAsFixed(0)}',
                      accentColor: const Color(0xFF7C3AED),
                      icon: Icons.receipt_long_outlined,
                    ),
                    SizedBox(height: 10.h),
                    _statementTile(
                      label: 'Remaining Amount',
                      value: '৳${summary.remainingAmount.toStringAsFixed(0)}',
                      accentColor: const Color(0xFFEB5757),
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ],
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
