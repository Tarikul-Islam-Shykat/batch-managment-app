import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/batch_students_cubit.dart';
import '../bloc/batch_students_state.dart';

class BatchStudentFilterSheet extends StatelessWidget {
  final BatchStudentsCubit cubit;
  final String currentFilter;

  const BatchStudentFilterSheet({
    super.key,
    required this.cubit,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
              'Filter Students',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000710),
              ),
            ),
            SizedBox(height: 14.h),
            _filterTile(
              context,
              label: 'All Students',
              value: BatchStudentsState.filterAll,
              icon: Icons.groups_rounded,
            ),
            _filterTile(
              context,
              label: 'Paid Students',
              value: BatchStudentsState.filterPaid,
              icon: Icons.check_circle_outline_rounded,
              color: const Color(0xFF16A34A),
            ),
            _filterTile(
              context,
              label: 'Unpaid Students',
              value: BatchStudentsState.filterUnpaid,
              icon: Icons.timelapse_rounded,
              color: const Color(0xFFF59E0B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    final isSelected = currentFilter == value;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF0066FF).withValues(alpha: 0.08)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? const Color(0xFF0066FF) : Colors.transparent,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? const Color(0xFF000710)),
        title: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF000710),
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF0066FF))
            : null,
        onTap: () {
          cubit.setPaymentFilter(value);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
