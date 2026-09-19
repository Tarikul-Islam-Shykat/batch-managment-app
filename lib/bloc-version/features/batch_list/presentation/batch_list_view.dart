import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'bloc/batch_list_cubit.dart';
import 'bloc/batch_list_state.dart';
import 'widgets/batch_card.dart';

class BatchListView extends StatelessWidget {
  const BatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BatchListCubit>(
      create: (context) => sl<BatchListCubit>()..fetchBatches(),
      child: const _BatchListBody(),
    );
  }
}

class _BatchListBody extends StatefulWidget {
  const _BatchListBody();

  @override
  State<_BatchListBody> createState() => _BatchListBodyState();
}

class _BatchListBodyState extends State<_BatchListBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<BatchListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BatchListCubit, BatchListState>(
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
        final cubit = context.read<BatchListCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72.h),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              titleSpacing: 16.w,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Batches',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      color: const Color(0xFF000710),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Manage your batches & schedules',
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
                  onPressed: () => cubit.refreshBatches(),
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF000710),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Center(
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: 34.w,
                      height: 34.w,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Filter Tabs (Current, Upcoming, Ended)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  child: Row(
                    children: BatchListCubit.statusOptions.map((status) {
                      final isSelected = state.selectedStatus == status;
                      final isLast =
                          status == BatchListCubit.statusOptions.last;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: isLast ? 0 : 8.w),
                          child: GestureDetector(
                            onTap: () => cubit.setStatus(status),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0066FF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0066FF)
                                      : const Color(
                                          0xFF000710,
                                        ).withValues(alpha: 0.06),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF0066FF,
                                          ).withValues(alpha: 0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  cubit.statusShortLabel(status),
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13.sp,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF000710),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Batches List
                Expanded(
                  child: state.isLoading && state.batches.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF0066FF),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: cubit.refreshBatches,
                          color: const Color(0xFF0066FF),
                          child: state.batches.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(16.w),
                                  children: [
                                    SizedBox(height: 120.h),
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.inbox_outlined,
                                            size: 48.sp,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            'No batches found',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 15.sp,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    16.w,
                                    4.h,
                                    16.w,
                                    16.h,
                                  ),
                                  itemCount:
                                      state.batches.length +
                                      (state.isLoadingMore ? 1 : 0),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 12.h),
                                  itemBuilder: (context, index) {
                                    if (index == state.batches.length) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF0066FF),
                                                ),
                                          ),
                                        ),
                                      );
                                    }

                                    final batch = state.batches[index];
                                    return BatchCard(
                                      batch: batch,
                                      statusLabel: cubit.statusLabel(
                                        state.selectedStatus,
                                      ),
                                      onEdit: () async {
                                        final updated = await context.push(
                                          '/edit-batch',
                                          extra: batch,
                                        );
                                        if (updated == true) {
                                          cubit.refreshBatches();
                                        }
                                      },
                                      onAddStudent: () async {
                                        final enrolled = await context.push(
                                          '/enroll-student',
                                          extra: batch,
                                        );
                                        if (enrolled == true) {
                                          cubit.refreshBatches();
                                        }
                                      },
                                      onViewDetails: () {
                                        AppSnackbar.show(
                                          context: context,
                                          message:
                                              'Batch details for "${batch.batchName}" coming next!',
                                          isSuccess: true,
                                        );
                                      },
                                    );
                                  },
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
