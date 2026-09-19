import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import '../bloc/batch_students_cubit.dart';

class BatchStudentsHeaderCard extends StatefulWidget {
  final BatchListItemModel batch;
  final BatchStudentsCubit cubit;
  final int totalStudents;

  const BatchStudentsHeaderCard({
    super.key,
    required this.batch,
    required this.cubit,
    required this.totalStudents,
  });

  @override
  State<BatchStudentsHeaderCard> createState() =>
      _BatchStudentsHeaderCardState();
}

class _BatchStudentsHeaderCardState extends State<BatchStudentsHeaderCard> {
  bool _showDetails = false;

  String _formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return '${parsed.day} ${_monthName(parsed.month)} ${parsed.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String _monthName(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return (m >= 1 && m <= 12) ? months[m - 1] : '';
  }

  List<String> _scheduleLines() {
    return widget.batch.schedule
        .map((s) => '${s.day}: ${s.startTime} - ${s.endTime}')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleLines = _scheduleLines();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'Active Batch',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12.sp,
                    color: const Color(0xFF0066FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              _ActionIconButton(
                icon: Icons.edit_outlined,
                onTap: () async {
                  final updated = await context.push(
                    '/edit-batch',
                    extra: widget.batch,
                  );
                  if (updated == true) {
                    widget.cubit.refresh();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            widget.batch.batchName,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22.sp,
              color: const Color(0xFF000710),
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
          ),
          SizedBox(height: 8.h),
          _infoRow('Subject: ', widget.batch.subject),
          SizedBox(height: 4.h),
          _infoRow(
            'Timeline: ',
            '${_formatDate(widget.batch.startDate)} - ${_formatDate(widget.batch.endDate)}',
          ),
          SizedBox(height: 4.h),
          _infoRow(
            'Fees: ',
            '৳${widget.batch.fees.toStringAsFixed(0)} / month',
            valueColor: const Color(0xFF0066FF),
          ),
          SizedBox(height: 4.h),
          _infoRow(
            'Enrolled: ',
            '${widget.totalStudents} / ${widget.batch.maxStudents} Students',
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => setState(() => _showDetails = !_showDetails),
            child: Row(
              children: [
                Text(
                  _showDetails ? 'Hide Schedules' : 'View Schedules',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13.sp,
                    color: const Color(0xFF0066FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  _showDetails
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF0066FF),
                  size: 18.sp,
                ),
              ],
            ),
          ),
          if (_showDetails && scheduleLines.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: scheduleLines.map((line) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          line,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12.sp,
                            color: const Color(0xFF000710),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          SizedBox(height: 14.h),
          ElevatedButton.icon(
            onPressed: () async {
              final enrolled = await context.push(
                '/enroll-student',
                extra: widget.batch,
              );
              if (enrolled == true) {
                widget.cubit.refresh();
              }
            },
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
            label: Text(
              'Add Student',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: Size.fromHeight(46.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13.sp,
              color: valueColor ?? const Color(0xFF000710),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 18.r,
        icon: Icon(icon, size: 18, color: const Color(0xFF000710)),
        onPressed: onTap,
      ),
    );
  }
}
