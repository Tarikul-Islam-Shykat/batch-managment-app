import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/batch_students_model.dart';

class BatchStudentProfileSheet extends StatelessWidget {
  final BatchStudentModel student;
  final String batchName;
  final VoidCallback onEdit;

  const BatchStudentProfileSheet({
    super.key,
    required this.student,
    required this.batchName,
    required this.onEdit,
  });

  Color get _statusColor {
    switch (student.status.toLowerCase()) {
      case 'active':
        return const Color(0xFF16A34A);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'inactive':
      case 'blocked':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF0066FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
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
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF).withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        student.firstName.isNotEmpty
                            ? student.firstName[0].toUpperCase()
                            : 'S',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0066FF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.firstName,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000710),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Roll: ${student.rollNumber}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      student.status.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: _feeCard(
                      label: 'Base Fee',
                      amount: '৳${student.monthlyFee.toStringAsFixed(0)}',
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _feeCard(
                      label: 'Discount',
                      amount: '${student.discount.toStringAsFixed(0)}%',
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _feeCard(
                      label: 'Payable',
                      amount:
                          '৳${student.payableMonthlyAmount.toStringAsFixed(0)}',
                      color: const Color(0xFF0066FF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _detailTile(
                icon: Icons.school_outlined,
                label: 'Batch',
                value: batchName,
              ),
              SizedBox(height: 8.h),
              _detailTile(
                icon: Icons.phone_outlined,
                label: 'Guardian Phone',
                value: student.guardianPhone.isNotEmpty
                    ? student.guardianPhone
                    : 'N/A',
              ),
              SizedBox(height: 8.h),
              _detailTile(
                icon: Icons.calendar_today_outlined,
                label: 'Enrolled At',
                value: student.batchStartedAt.isNotEmpty
                    ? student.batchStartedAt
                    : 'N/A',
              ),
              if (student.notes.isNotEmpty) ...[
                SizedBox(height: 8.h),
                _detailTile(
                  icon: Icons.notes_outlined,
                  label: 'Notes',
                  value: student.notes,
                ),
              ],
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0066FF)),
                        minimumSize: Size.fromHeight(48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.sp,
                          color: const Color(0xFF0066FF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: Text(
                        'Edit Student',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: Size.fromHeight(48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feeCard({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            amount,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15.sp,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          SizedBox(width: 10.w),
          Text(
            '$label: ',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.sp,
                color: const Color(0xFF000710),
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
