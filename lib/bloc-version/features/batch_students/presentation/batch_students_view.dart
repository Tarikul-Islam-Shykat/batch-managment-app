import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import '../data/models/batch_students_model.dart';
import 'bloc/batch_students_cubit.dart';
import 'bloc/batch_students_state.dart';
import 'widgets/batch_fee_collect_sheet.dart';
import 'widgets/batch_finance_overview_card.dart';
import 'widgets/batch_student_card.dart';
import 'widgets/batch_student_filter_sheet.dart';
import 'widgets/batch_student_profile_sheet.dart';
import 'widgets/batch_students_header_card.dart';

class BatchStudentsView extends StatelessWidget {
  final BatchListItemModel batch;

  const BatchStudentsView({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BatchStudentsCubit>(
      create: (context) => sl<BatchStudentsCubit>()..init(batch),
      child: _BatchStudentsBody(batch: batch),
    );
  }
}

class _BatchStudentsBody extends StatefulWidget {
  final BatchListItemModel batch;

  const _BatchStudentsBody({required this.batch});

  @override
  State<_BatchStudentsBody> createState() => _BatchStudentsBodyState();
}

class _BatchStudentsBodyState extends State<_BatchStudentsBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(
    BuildContext context,
    BatchStudentsCubit cubit,
    String currentFilter,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          BatchStudentFilterSheet(cubit: cubit, currentFilter: currentFilter),
    );
  }

  void _openProfileSheet(
    BuildContext context,
    BatchStudentsCubit cubit,
    BatchStudentModel student,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BatchStudentProfileSheet(
        student: student,
        batchName: widget.batch.batchName,
        onEdit: () async {
          Navigator.of(context).pop();
          final updated = await context.push(
            '/edit-student',
            extra: {'student': student, 'batch': widget.batch},
          );
          if (updated == true) {
            cubit.refresh();
          }
        },
      ),
    );
  }

  void _openCollectFeeSheet(BuildContext context, BatchStudentsCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BatchFeeCollectSheet(cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BatchStudentsCubit, BatchStudentsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage!,
            isSuccess: false,
          );
        }
        if (state.successMessage != null) {
          AppSnackbar.show(
            context: context,
            message: state.successMessage!,
            isSuccess: true,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<BatchStudentsCubit>();
        final visibleStudents = state.filteredStudents;
        final selectedCount = state.selectedStudentCount;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72.h),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Color(0xFF000710),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              titleSpacing: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.batch.batchName,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000710),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${state.students.length} Students Enrolled',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => cubit.refresh(),
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF000710),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 120.h),
                    children: [
                      // Header Card
                      BatchStudentsHeaderCard(
                        batch: widget.batch,
                        cubit: cubit,
                        totalStudents: state.students.length,
                      ),
                      SizedBox(height: 14.h),

                      // Finance Overview Card
                      BatchFinanceOverviewCard(cubit: cubit, state: state),
                      SizedBox(height: 16.h),

                      // Filter & Search Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Students (${visibleStudents.length})',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000710),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _openFilterSheet(
                              context,
                              cubit,
                              state.paymentFilter,
                            ),
                            icon: const Icon(Icons.tune_rounded, size: 16),
                            label: Text(
                              state.paymentFilter ==
                                      BatchStudentsState.filterAll
                                  ? 'Filter'
                                  : state.paymentFilter.toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0066FF),
                              backgroundColor: const Color(
                                0xFF0066FF,
                              ).withValues(alpha: 0.08),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
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

                      // Search TextField
                      TextField(
                        controller: _searchController,
                        onChanged: (val) => cubit.setSearchQuery(val),
                        style: GoogleFonts.spaceGrotesk(fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: 'Search by name, roll, phone...',
                          hintStyle: GoogleFonts.spaceGrotesk(
                            fontSize: 14.sp,
                            color: const Color(0xFF898989),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.black45,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    cubit.setSearchQuery('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 14.w,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: Colors.black.withValues(alpha: 0.06),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: Colors.black.withValues(alpha: 0.06),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF0066FF),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Student List or Empty State
                      if (state.isLoading && state.students.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0066FF),
                              ),
                            ),
                          ),
                        )
                      else if (visibleStudents.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 36.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'No students found.',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      else
                        ...visibleStudents.asMap().entries.map((entry) {
                          final student = entry.value;
                          final isPaid = student.paidMonths.any(
                            (m) =>
                                m.trim().toLowerCase() ==
                                state.selectedFinanceMonth.toLowerCase(),
                          );

                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: BatchStudentCard(
                              student: student,
                              isSelected: state.selectedStudentIds.contains(
                                student.id,
                              ),
                              isPaid: isPaid,
                              onSelectionChanged: () =>
                                  cubit.toggleStudentSelection(student.id),
                              onViewProfile: () =>
                                  _openProfileSheet(context, cubit, student),
                            ),
                          );
                        }),
                    ],
                  ),
                ),

                // Animated Floating Bottom Collect Bar
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  left: 16.w,
                  right: 16.w,
                  bottom: selectedCount > 0 ? 16.h : -100.h,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: selectedCount > 0 ? 1 : 0,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000710),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              '$selectedCount Selected',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _openCollectFeeSheet(context, cubit),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0066FF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: Size.fromHeight(44.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Collect Fee',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          IconButton(
                            onPressed: cubit.clearSelectedStudents,
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
