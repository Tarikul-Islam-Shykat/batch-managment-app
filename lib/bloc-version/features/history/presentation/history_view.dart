import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'bloc/history_cubit.dart';
import 'bloc/history_state.dart';
import 'widgets/history_card.dart';

class HistoryView extends StatelessWidget {
  final String? batchId;
  final String? batchName;
  final String? studentId;
  final String? studentName;

  const HistoryView({
    super.key,
    this.batchId,
    this.batchName,
    this.studentId,
    this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (context) {
        final cubit = sl<HistoryCubit>();
        if (studentId != null && studentId!.isNotEmpty) {
          cubit.fetchStudentHistory(studentId!, studentName: studentName);
        } else if (batchId != null && batchId!.isNotEmpty) {
          cubit.fetchBatchHistory(batchId!, batchName: batchName);
        }
        return cubit;
      },
      child: const _HistoryBody(),
    );
  }
}

class _HistoryBody extends StatelessWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage!,
            isSuccess: false,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<HistoryCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(68.h),
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
                    state.screenTitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000710),
                    ),
                  ),
                  if (state.subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      state.subtitle,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
            child: Builder(
              builder: (context) {
                if (state.isLoading && state.entries.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  );
                }

                if (state.hasError && state.entries.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 50.sp,
                            color: const Color(0xFFEF4444),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            state.errorMessage ?? 'Failed to load history',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => cubit.refresh(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000710),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Retry',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFF2563EB),
                  onRefresh: () => cubit.refresh(),
                  child: state.entries.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(24.w),
                          children: [
                            SizedBox(height: 120.h),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.history_toggle_off_rounded,
                                    size: 56.sp,
                                    color: Colors.black26,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'No history found',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Activity and audit logs will appear here.',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12.sp,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                          itemCount: state.entries.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            return HistoryCard(entry: state.entries[index]);
                          },
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
