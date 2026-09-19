import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BatchCard extends StatelessWidget {
  final BatchListItemModel batch;
  final String statusLabel;
  final VoidCallback onEdit;
  final VoidCallback? onAddStudent;
  final VoidCallback? onViewDetails;

  const BatchCard({
    super.key,
    required this.batch,
    required this.statusLabel,
    required this.onEdit,
    this.onAddStudent,
    this.onViewDetails,
  });

  Widget _labelValueRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.spaceGrotesk(fontSize: 13.sp),
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Color(0xFF000710),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xFF000710).withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066FF).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        statusLabel,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12.sp,
                          color: const Color(0xFF0066FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      batch.batchName,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20.sp,
                        color: const Color(0xFF000710),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _labelValueRow('Subject', batch.subject),
                    SizedBox(height: 6.h),
                    _labelValueRow(
                      'Fees',
                      '৳ ${batch.fees.toStringAsFixed(0)}',
                    ),
                    SizedBox(height: 4.h),
                    _labelValueRow('Max Students', '${batch.maxStudents}'),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF000710).withValues(alpha: 0.08),
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 20.r,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Color(0xFF000710),
                  ),
                  onPressed: onEdit,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAddStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size.fromHeight(46.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Add Student',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size.fromHeight(46.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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
