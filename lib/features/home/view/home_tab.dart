import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/app_header_bar.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/loading.dart';
import '../../../core/global/spacing.dart';
import '../../../core/routes/app_routes.dart';
import '../../profile/controller/profile_tab_controller.dart';
import '../controller/home_dashboard_controller.dart';

class HomeTab extends GetView<HomeDashboardController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileTabController>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppHeaderBar(
        title: 'dashboard'.tr,
        subtitle: '',
        subtitleBuilder: () => profileController.displayName,
        actions: [
          IconButton(
            onPressed: controller.refreshDashboard,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Obx(() {
        final dashboard = controller.dashboard.value;

        if (controller.isLoading.value && dashboard == null) {
          return Center(child: loading());
        }

        if (dashboard == null) {
          return RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                SizedBox(height: 100.h),
                _DashboardEmptyState(
                  title: 'no_dashboard_data'.tr,
                  subtitle: controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'dashboard_subtitle'.tr,
                  onRetry: controller.refreshDashboard,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            children: [
              _HeroCard(controller: controller),
              verticalSpace(14),
              _ExpandableSectionCard(
                title: 'batch_overview'.tr,
                child: _MetricGrid(
                  items: [
                    _DashboardMetric(
                      label: 'total_batches'.tr,
                      value: controller.intValue(
                        controller.batchOverview,
                        const ['total_batches', 'total'],
                      ),
                      icon: Icons.dashboard_rounded,
                      color: const Color(0xFF2F80ED),
                    ),
                    _DashboardMetric(
                      label: 'current_batches'.tr,
                      value: controller.intValue(
                        controller.batchOverview,
                        const ['current_batches', 'current'],
                      ),
                      icon: Icons.play_circle_outline_rounded,
                      color: const Color(0xFF11A36A),
                    ),
                    _DashboardMetric(
                      label: 'upcoming_batches'.tr,
                      value: controller.intValue(
                        controller.batchOverview,
                        const ['upcoming_batches', 'upcoming'],
                      ),
                      icon: Icons.schedule_rounded,
                      color: const Color(0xFFF28C28),
                    ),
                    _DashboardMetric(
                      label: 'ended_batches'.tr,
                      value: controller.intValue(
                        controller.batchOverview,
                        const ['ended_batches', 'ended'],
                      ),
                      icon: Icons.flag_rounded,
                      color: const Color(0xFFEB5757),
                    ),
                  ],
                ),
              ),
              verticalSpace(14),
              _ExpandableSectionCard(
                title: 'student_overview'.tr,
                child: _MetricGrid(
                  items: [
                    _DashboardMetric(
                      label: 'total_students'.tr,
                      value: controller.intValue(
                        controller.studentOverview,
                        const ['total_students', 'total'],
                      ),
                      icon: Icons.groups_rounded,
                      color: const Color(0xFF2F80ED),
                    ),
                    _DashboardMetric(
                      label: 'active_students'.tr,
                      value: controller.intValue(
                        controller.studentOverview,
                        const ['active_students', 'active'],
                      ),
                      icon: Icons.verified_rounded,
                      color: const Color(0xFF11A36A),
                    ),
                    _DashboardMetric(
                      label: 'pending_students'.tr,
                      value: controller.intValue(
                        controller.studentOverview,
                        const ['pending_students', 'pending'],
                      ),
                      icon: Icons.pending_actions_rounded,
                      color: const Color(0xFFF28C28),
                    ),
                    _DashboardMetric(
                      label: 'new_this_month'.tr,
                      value: controller.intValue(
                        controller.studentOverview,
                        const ['new_this_month', 'new_students'],
                      ),
                      icon: Icons.fiber_new_rounded,
                      color: const Color(0xFF7C3AED),
                    ),
                  ],
                ),
              ),
              verticalSpace(14),
              _ExpandableSectionCard(
                title: 'capacity_overview'.tr,
                child: _MetricGrid(
                  items: [
                    _DashboardMetric(
                      label: 'total_seats'.tr,
                      value: controller.intValue(
                        controller.capacityOverview,
                        const ['total_seats', 'seats', 'capacity'],
                      ),
                      icon: Icons.event_seat_rounded,
                      color: const Color(0xFF2F80ED),
                    ),
                    _DashboardMetric(
                      label: 'filled_seats'.tr,
                      value: controller.intValue(
                        controller.capacityOverview,
                        const ['filled_seats', 'used_seats'],
                      ),
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFF11A36A),
                    ),
                    _DashboardMetric(
                      label: 'empty_seats'.tr,
                      value: controller.intValue(
                        controller.capacityOverview,
                        const ['empty_seats', 'remaining_seats'],
                      ),
                      icon: Icons.airline_seat_recline_normal_rounded,
                      color: const Color(0xFFF28C28),
                    ),
                    _DashboardMetric(
                      label: 'fill_rate'.tr,
                      value: controller.formatPercent(
                        controller.doubleValue(
                          controller.capacityOverview,
                          const ['fill_rate', 'occupancy_rate'],
                        ),
                      ),
                      icon: Icons.insights_rounded,
                      color: const Color(0xFFEB5757),
                    ),
                  ],
                ),
              ),
              verticalSpace(14),
              _ExpandableSectionCard(
                title: 'finance_overview'.tr,
                child: _MetricGrid(
                  items: [
                    _DashboardMetric(
                      label: 'expected_amount'.tr,
                      value: controller.formatNumber(
                        controller.doubleValue(
                          controller.financeOverview,
                          const ['expected_amount', 'total_expected_amount'],
                        ),
                      ),
                      icon: Icons.payments_outlined,
                      color: const Color(0xFF2F80ED),
                    ),
                    _DashboardMetric(
                      label: 'collected_amount'.tr,
                      value: controller.formatNumber(
                        controller.doubleValue(
                          controller.financeOverview,
                          const ['collected_amount', 'total_paid_amount'],
                        ),
                      ),
                      icon: Icons.receipt_long_outlined,
                      color: const Color(0xFF11A36A),
                    ),
                    _DashboardMetric(
                      label: 'due_amount'.tr,
                      value: controller.formatNumber(
                        controller.doubleValue(
                          controller.financeOverview,
                          const ['due_amount', 'remaining_amount'],
                        ),
                      ),
                      icon: Icons.account_balance_wallet_outlined,
                      color: const Color(0xFFEB5757),
                    ),
                    _DashboardMetric(
                      label: 'collection_rate'.tr,
                      value: controller.formatPercent(
                        controller.doubleValue(
                          controller.financeOverview,
                          const ['collection_rate'],
                        ),
                      ),
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFF7C3AED),
                    ),
                  ],
                ),
              ),
              if (controller.batchSummaries.isNotEmpty) ...[
                verticalSpace(14),
                _ExpandableSectionCard(
                  title: 'batch_summaries'.tr,
                  child: SizedBox(
                    height: 192.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.batchSummaries.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final item = controller.batchSummaries[index];
                        return _BatchSummaryCard(
                          title: controller.textValue(item, const [
                            'batch_name',
                            'name',
                          ], fallback: 'Batch ${index + 1}'),
                          subtitle: controller.textValue(item, const [
                            'subject',
                            'fee_month',
                          ], fallback: '-'),
                          detail: controller.textValue(item, const [
                            'fee_month',
                            'month',
                          ], fallback: controller.activeMonthLabel),
                          progressLabel: controller.batchProgressLabel(item),
                          progress: controller.paymentProgress(item),
                          totalStudents: controller.intValue(item, const [
                            'total_students',
                            'students',
                          ]),
                          paidStudents: controller.intValue(item, const [
                            'paid_students',
                          ]),
                          dueAmount: controller.formatNumber(
                            controller.doubleValue(item, const [
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
              if (controller.recentActivities.isNotEmpty) ...[
                verticalSpace(14),
                _ExpandableSectionCard(
                  title: 'recent_activities'.tr,
                  child: Column(
                    children: controller.recentActivities
                        .map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _FeedItemCard(
                              title: controller.textValue(item, const [
                                'title',
                                'action',
                                'event',
                              ]),
                              subtitle: controller.textValue(item, const [
                                'description',
                                'message',
                                'details',
                              ]),
                              trailing: controller.textValue(item, const [
                                'created_at',
                                'time',
                                'date',
                              ], fallback: ''),
                              icon: Icons.history_rounded,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              if (controller.alerts.isNotEmpty) ...[
                verticalSpace(14),
                _ExpandableSectionCard(
                  title: 'alerts'.tr,
                  child: Column(
                    children: controller.alerts
                        .map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _FeedItemCard(
                              title: controller.textValue(item, const [
                                'title',
                                'message',
                                'alert',
                              ]),
                              subtitle: controller.textValue(item, const [
                                'description',
                                'details',
                                'reason',
                              ]),
                              trailing: controller.textValue(item, const [
                                'type',
                                'severity',
                              ], fallback: ''),
                              icon: Icons.warning_amber_rounded,
                              accentColor: const Color(0xFFEB5757),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final HomeDashboardController controller;

  const _HeroCard({required this.controller});

  void _openMonthSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Obx(
              () => Column(
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
                  brandText(
                    text: 'dashboard_month'.tr,
                    color: AppColors.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                  SizedBox(height: 12.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 320.h),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.monthOptions.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final month = controller.monthOptions[index];
                        final selected = month == controller.activeMonthLabel;
                        return InkWell(
                          onTap: () async {
                            await controller.changeMonth(month);
                            if (Get.isBottomSheetOpen == true) {
                              Get.back();
                            }
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primaryColor.withValues(
                                      alpha: 0.10,
                                    )
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primaryColor
                                    : Colors.black.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: smallText(
                                    text: month,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (selected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primaryColor,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A66FF), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
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
                      smallText(
                        text: 'dashboard'.tr,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 4.h),
                      brandText(
                        text: 'dashboard_subtitle'.tr,
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.space_dashboard_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            InkWell(
              onTap: () => _openMonthSheet(context),
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.primaryColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          smallText(
                            text: 'dashboard_month'.tr,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 2.h),
                          brandText(
                            text: controller.activeMonthLabel,
                            color: AppColors.blackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _MiniStatChip(
                    label: 'total_batches'.tr,
                    value: controller.intValue(controller.batchOverview, const [
                      'total_batches',
                      'total',
                    ]).toString(),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _MiniStatChip(
                    label: 'total_students'.tr,
                    value: controller.intValue(
                      controller.studentOverview,
                      const ['total_students', 'total'],
                    ).toString(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(AppRoute.batchListScreen),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text('view_batches'.tr),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoute.createBatchScreen),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whiteColor,
                      foregroundColor: AppColors.primaryColor,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text('new_batch'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableSectionCard extends StatefulWidget {
  final String title;
  final Widget child;

  const _ExpandableSectionCard({required this.title, required this.child});

  @override
  State<_ExpandableSectionCard> createState() => _ExpandableSectionCardState();
}

class _ExpandableSectionCardState extends State<_ExpandableSectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: brandText(
                      text: widget.title,
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  smallText(
                    text: _expanded ? 'hide_details'.tr : 'show_details'.tr,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: widget.child,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final List<_DashboardMetric> items;

  const _MetricGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        return _DashboardMetricCard(metric: items[index]);
      },
    );
  }
}

class _DashboardMetric {
  final String label;
  final Object value;
  final IconData icon;
  final Color color;

  const _DashboardMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _DashboardMetricCard extends StatelessWidget {
  final _DashboardMetric metric;

  const _DashboardMetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: metric.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: metric.color.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(metric.icon, color: metric.color, size: 18.sp),
          ),
          const Spacer(),
          smallText(
            text: metric.label,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            maxLines: 2,
          ),
          SizedBox(height: 4.h),
          brandText(
            text: metric.value.toString(),
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          smallText(
            text: label,
            color: Colors.white.withValues(alpha: 0.78),
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          brandText(
            text: value,
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _BatchSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String detail;
  final String progressLabel;
  final double progress;
  final int totalStudents;
  final int paidStudents;
  final String dueAmount;

  const _BatchSummaryCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.progressLabel,
    required this.progress,
    required this.totalStudents,
    required this.paidStudents,
    required this.dueAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          brandText(
            text: title,
            color: AppColors.blackColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 4.h),
          smallText(
            text: subtitle,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            maxLines: 1,
          ),
          SizedBox(height: 4.h),
          smallText(
            text: detail,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            maxLines: 1,
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              minHeight: 8.h,
              value: progress,
              backgroundColor: Colors.black.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryColor),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: smallText(
                  text: progressLabel,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              smallText(
                text: dueAmount,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          smallText(
            text:
                '$paidStudents ${'paid_students'.tr} • $totalStudents ${'total_students'.tr}',
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _FeedItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;
  final Color accentColor;

  const _FeedItemCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    this.accentColor = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: accentColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                brandText(
                  text: title.isEmpty ? '-' : title,
                  color: AppColors.blackColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
                if (subtitle.trim().isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  smallText(
                    text: subtitle,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
          if (trailing.trim().isNotEmpty)
            Container(
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: smallText(
                text: trailing,
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _DashboardEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRetry;

  const _DashboardEmptyState({
    required this.title,
    required this.subtitle,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 14.h),
          brandText(
            text: title,
            color: AppColors.blackColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            maxLines: 2,
          ),
          SizedBox(height: 6.h),
          smallText(
            text: subtitle,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: 160.w,
            child: OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: const BorderSide(color: AppColors.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text('update'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
