import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/localization/localization_extension.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'package:batch_management_app_direct/bloc-version/features/profile/presentation/bloc/profile_cubit.dart';
import '../data/models/home_dashboard_model.dart';
import 'bloc/home_cubit.dart';
import 'bloc/home_state.dart';
import 'widgets/batch_summary_card.dart';
import 'widgets/expandable_section_card.dart';
import 'widgets/feed_item_card.dart';
import 'widgets/hero_card.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/metric_grid.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => sl<HomeCubit>()..fetchDashboard(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.dashboard != null) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage!,
            isSuccess: false,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final dashboard = state.dashboard;

        // Try getting teacher name from ProfileCubit if available
        String teacherName = '';
        try {
          final profileState = context.watch<ProfileCubit>().state;
          if (profileState.user != null && profileState.user!.name.isNotEmpty) {
            teacherName = profileState.user!.name;
          }
        } catch (_) {}

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(68.h),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              titleSpacing: 20.w,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('dashboard'),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000710),
                    ),
                  ),
                  if (teacherName.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      teacherName,
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
                  tooltip: context.tr('refresh'),
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
                if (state.isLoading && dashboard == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  );
                }

                if (dashboard == null) {
                  return RefreshIndicator(
                    color: const Color(0xFF2563EB),
                    onRefresh: () => cubit.refresh(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                      children: [
                        SizedBox(height: 80.h),
                        HomeEmptyState(
                          title: context.tr('no_dashboard_data'),
                          subtitle:
                              state.errorMessage ??
                              context.tr('could_not_load_analytics'),
                          onRetry: () => cubit.refresh(),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFF2563EB),
                  onRefresh: () => cubit.refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
                    children: [
                      HeroCard(state: state),
                      SizedBox(height: 14.h),

                      // 1. Batch Overview
                      ExpandableSectionCard(
                        title: context.tr('batch_overview'),
                        child: MetricGrid(
                          items: [
                            DashboardMetric(
                              label: context.tr('total_batches'),
                              value: HomeDashboardModel.intValue(
                                dashboard.batchOverview,
                                const ['total_batches', 'total'],
                              ),
                              icon: Icons.dashboard_rounded,
                              color: const Color(0xFF2F80ED),
                            ),
                            DashboardMetric(
                              label: context.tr('current_batches'),
                              value: HomeDashboardModel.intValue(
                                dashboard.batchOverview,
                                const ['current_batches', 'current'],
                              ),
                              icon: Icons.play_circle_outline_rounded,
                              color: const Color(0xFF11A36A),
                            ),
                            DashboardMetric(
                              label: context.tr('upcoming_batches'),
                              value: HomeDashboardModel.intValue(
                                dashboard.batchOverview,
                                const ['upcoming_batches', 'upcoming'],
                              ),
                              icon: Icons.schedule_rounded,
                              color: const Color(0xFFF28C28),
                            ),
                            DashboardMetric(
                              label: context.tr('ended_batches'),
                              value: HomeDashboardModel.intValue(
                                dashboard.batchOverview,
                                const ['ended_batches', 'ended'],
                              ),
                              icon: Icons.flag_rounded,
                              color: const Color(0xFFEB5757),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // 2. Student Overview
                      ExpandableSectionCard(
                        title: context.tr('student_overview'),
                        child: MetricGrid(
                          items: [
                            DashboardMetric(
                              label: context.tr('total_students'),
                              value: HomeDashboardModel.intValue(
                                dashboard.studentOverview,
                                const ['total_students', 'total'],
                              ),
                              icon: Icons.groups_rounded,
                              color: const Color(0xFF2F80ED),
                            ),
                            DashboardMetric(
                              label: context.tr('active_students'),
                              value: HomeDashboardModel.intValue(
                                dashboard.studentOverview,
                                const ['active_students', 'active'],
                              ),
                              icon: Icons.verified_rounded,
                              color: const Color(0xFF11A36A),
                            ),
                            DashboardMetric(
                              label: context.tr('pending_students'),
                              value: HomeDashboardModel.intValue(
                                dashboard.studentOverview,
                                const ['pending_students', 'pending'],
                              ),
                              icon: Icons.pending_actions_rounded,
                              color: const Color(0xFFF28C28),
                            ),
                            DashboardMetric(
                              label: context.tr('new_this_month'),
                              value: HomeDashboardModel.intValue(
                                dashboard.studentOverview,
                                const ['new_this_month', 'new_students'],
                              ),
                              icon: Icons.fiber_new_rounded,
                              color: const Color(0xFF7C3AED),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // 3. Capacity Overview
                      ExpandableSectionCard(
                        title: context.tr('capacity_overview'),
                        child: MetricGrid(
                          items: [
                            DashboardMetric(
                              label: context.tr('total_seats'),
                              value: HomeDashboardModel.intValue(
                                dashboard.capacityOverview,
                                const ['total_seats', 'seats', 'capacity'],
                              ),
                              icon: Icons.event_seat_rounded,
                              color: const Color(0xFF2F80ED),
                            ),
                            DashboardMetric(
                              label: context.tr('filled_seats'),
                              value: HomeDashboardModel.intValue(
                                dashboard.capacityOverview,
                                const ['filled_seats', 'used_seats'],
                              ),
                              icon: Icons.check_circle_outline_rounded,
                              color: const Color(0xFF11A36A),
                            ),
                            DashboardMetric(
                              label: context.tr('empty_seats'),
                              value: HomeDashboardModel.intValue(
                                dashboard.capacityOverview,
                                const ['empty_seats', 'remaining_seats'],
                              ),
                              icon: Icons.airline_seat_recline_normal_rounded,
                              color: const Color(0xFFF28C28),
                            ),
                            DashboardMetric(
                              label: context.tr('fill_rate'),
                              value: HomeDashboardModel.formatPercent(
                                HomeDashboardModel.doubleValue(
                                  dashboard.capacityOverview,
                                  const ['fill_rate', 'occupancy_rate'],
                                ),
                              ),
                              icon: Icons.insights_rounded,
                              color: const Color(0xFFEB5757),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // 4. Finance Overview
                      ExpandableSectionCard(
                        title: context.tr('finance_overview'),
                        child: MetricGrid(
                          items: [
                            DashboardMetric(
                              label: context.tr('expected_amount'),
                              value: HomeDashboardModel.formatNumber(
                                HomeDashboardModel.doubleValue(
                                  dashboard.financeOverview,
                                  const [
                                    'expected_amount',
                                    'total_expected_amount',
                                  ],
                                ),
                              ),
                              icon: Icons.payments_outlined,
                              color: const Color(0xFF2F80ED),
                            ),
                            DashboardMetric(
                              label: context.tr('collected_amount'),
                              value: HomeDashboardModel.formatNumber(
                                HomeDashboardModel.doubleValue(
                                  dashboard.financeOverview,
                                  const [
                                    'collected_amount',
                                    'total_paid_amount',
                                  ],
                                ),
                              ),
                              icon: Icons.receipt_long_outlined,
                              color: const Color(0xFF11A36A),
                            ),
                            DashboardMetric(
                              label: context.tr('due_amount'),
                              value: HomeDashboardModel.formatNumber(
                                HomeDashboardModel.doubleValue(
                                  dashboard.financeOverview,
                                  const ['due_amount', 'remaining_amount'],
                                ),
                              ),
                              icon: Icons.account_balance_wallet_outlined,
                              color: const Color(0xFFEB5757),
                            ),
                            DashboardMetric(
                              label: context.tr('collection_rate'),
                              value: HomeDashboardModel.formatPercent(
                                HomeDashboardModel.doubleValue(
                                  dashboard.financeOverview,
                                  const ['collection_rate'],
                                ),
                              ),
                              icon: Icons.trending_up_rounded,
                              color: const Color(0xFF7C3AED),
                            ),
                          ],
                        ),
                      ),

                      // 5. Batch Summaries Carousel (if available)
                      if (dashboard.batchSummaries.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        ExpandableSectionCard(
                          title: context.tr('batch_summaries'),
                          child: SizedBox(
                            height: 195.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: dashboard.batchSummaries.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) {
                                final item = dashboard.batchSummaries[index];
                                return BatchSummaryCard(
                                  title: HomeDashboardModel.textValue(
                                    item,
                                    const ['batch_name', 'name'],
                                    fallback: 'Batch ${index + 1}',
                                  ),
                                  subtitle: HomeDashboardModel.textValue(
                                    item,
                                    const ['subject', 'fee_month'],
                                    fallback: '-',
                                  ),
                                  detail: HomeDashboardModel.textValue(
                                    item,
                                    const ['fee_month', 'month'],
                                    fallback: state.selectedMonth,
                                  ),
                                  progressLabel:
                                      HomeDashboardModel.batchProgressLabel(
                                        item,
                                      ),
                                  progress: HomeDashboardModel.paymentProgress(
                                    item,
                                  ),
                                  totalStudents: HomeDashboardModel.intValue(
                                    item,
                                    const ['total_students', 'students'],
                                  ),
                                  paidStudents: HomeDashboardModel.intValue(
                                    item,
                                    const ['paid_students'],
                                  ),
                                  dueAmount: HomeDashboardModel.formatNumber(
                                    HomeDashboardModel.doubleValue(item, const [
                                      'due_amount',
                                      'remaining_amount',
                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],

                      // 6. Recent Activities Feed (if available)
                      if (dashboard.recentActivities.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        ExpandableSectionCard(
                          title: context.tr('recent_activities'),
                          child: Column(
                            children: dashboard.recentActivities.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: FeedItemCard(
                                  title: HomeDashboardModel.textValue(
                                    item,
                                    const ['title', 'action', 'event'],
                                  ),
                                  subtitle: HomeDashboardModel.textValue(
                                    item,
                                    const ['description', 'message', 'details'],
                                  ),
                                  trailing: HomeDashboardModel.textValue(
                                    item,
                                    const ['created_at', 'time', 'date'],
                                    fallback: '',
                                  ),
                                  icon: Icons.history_rounded,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],

                      // 7. Alerts Feed (if available)
                      if (dashboard.alerts.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        ExpandableSectionCard(
                          title: context.tr('alerts'),
                          child: Column(
                            children: dashboard.alerts.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: FeedItemCard(
                                  title: HomeDashboardModel.textValue(
                                    item,
                                    const ['title', 'message', 'alert'],
                                  ),
                                  subtitle: HomeDashboardModel.textValue(
                                    item,
                                    const ['description', 'details', 'reason'],
                                  ),
                                  trailing: HomeDashboardModel.textValue(
                                    item,
                                    const ['type', 'severity'],
                                    fallback: '',
                                  ),
                                  icon: Icons.warning_amber_rounded,
                                  accentColor: const Color(0xFFEB5757),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
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
