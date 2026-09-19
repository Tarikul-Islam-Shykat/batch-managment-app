import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/batch_students_model.dart';

class BatchStudentCard extends StatelessWidget {
  final BatchStudentModel student;
  final bool isSelected;
  final bool isPaid;
  final VoidCallback onSelectionChanged;
  final VoidCallback onViewProfile;

  const BatchStudentCard({
    super.key,
    required this.student,
    required this.isSelected,
    required this.isPaid,
    required this.onSelectionChanged,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF0066FF)
              : Colors.black.withValues(alpha: 0.06),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF0066FF).withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        student.firstName,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16.sp,
                          color: const Color(0xFF000710),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? const Color(0xFF16A34A).withValues(alpha: 0.12)
                            : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        isPaid ? 'Paid' : 'Unpaid',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isPaid
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                activeColor: const Color(0xFF0066FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (_) => onSelectionChanged(),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(
                'Roll: ',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                student.rollNumber,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.sp,
                  color: const Color(0xFF000710),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'Fee: ',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '৳${student.payableMonthlyAmount.toStringAsFixed(0)}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.sp,
                  color: const Color(0xFF0066FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: const Color(0xFF0066FF).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
                child: InkWell(
                  onTap: onViewProfile,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    child: Text(
                      'View Profile',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12.sp,
                        color: const Color(0xFF0066FF),
                        fontWeight: FontWeight.w700,
                      ),
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
