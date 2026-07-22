import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../controller/batch_students_controller.dart';

class BatchStudentsHeaderCard extends StatefulWidget {
  final BatchListItemModel batch;
  final BatchStudentsController controller;

  const BatchStudentsHeaderCard({
    super.key,
    required this.batch,
    required this.controller,
  });

  @override
  State<BatchStudentsHeaderCard> createState() =>
      _BatchStudentsHeaderCardState();
}

class _BatchStudentsHeaderCardState extends State<BatchStudentsHeaderCard> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
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
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: smallText(
                  text: 'current_batches'.tr,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _ActionIconButton(
                icon: Icons.delete_outline_rounded,
                onTap: () => Get.snackbar(
                  'info'.tr,
                  '${widget.batch.batchName}\n${'delete'.tr}',
                  snackPosition: SnackPosition.BOTTOM,
                ),
              ),
              SizedBox(width: 8.w),
              _ActionIconButton(
                icon: Icons.edit_outlined,
                onTap: () => Get.snackbar(
                  'info'.tr,
                  '${widget.batch.batchName}\n${'edit'.tr}',
                  snackPosition: SnackPosition.BOTTOM,
                ),
              ),
            ],
          ),
          verticalSpace(12),
          brandText(
            text: widget.batch.batchName,
            color: AppColors.blackColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
          verticalSpace(8),
          _InfoLine(
            label: '${'subject'.tr} : ',
            value: widget.batch.subject,
            labelColor: Colors.black54,
            valueColor: Colors.black87,
          ),
          verticalSpace(4),
          _InfoLine(
            label: '${'fees'.tr} : ',
            value: widget.batch.fees.toStringAsFixed(0),
            labelColor: Colors.black54,
            valueColor: Colors.black87,
          ),
          verticalSpace(8),
          InkWell(
            onTap: () => setState(() => _showDetails = !_showDetails),
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  smallText(
                    text: _showDetails ? 'Hide details' : 'Show details',
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    _showDetails
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(6),
                _InfoLine(
                  label: '${'start_date'.tr} : ',
                  value: widget.controller.formatDate(widget.batch.startDate),
                  labelColor: Colors.black54,
                  valueColor: Colors.black87,
                ),
                verticalSpace(4),
                _InfoLine(
                  label: '${'end_date'.tr} : ',
                  value: widget.controller.formatDate(widget.batch.endDate),
                  labelColor: Colors.black54,
                  valueColor: Colors.black87,
                ),
                verticalSpace(4),
                _InfoLine(
                  label: '${'class_days'.tr} : ',
                  value: widget.controller.scheduleText(),
                  labelColor: Colors.black54,
                  valueColor: Colors.black87,
                  maxLines: 1,
                  trailing: _ScheduleList(items: widget.batch.schedule),
                ),
              ],
            ),
            crossFadeState: _showDetails
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
          verticalSpace(14),
          _PrimaryButton(
            text: 'add_student'.tr,
            backgroundColor: AppColors.primaryColor,
            onTap: () => Get.toNamed(
              AppRoute.studentEnrollScreen,
              arguments: widget.batch,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.blackColor),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final int maxLines;
  final Widget? trailing;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.maxLines = 1,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    if (trailing != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelValueText(
            label: label,
            value: '',
            labelColor: labelColor,
            valueColor: valueColor,
            maxLines: maxLines,
          ),
          verticalSpace(8),
          trailing!,
        ],
      );
    }

    return labelValueText(
      label: label,
      value: value,
      labelColor: labelColor,
      valueColor: valueColor,
      maxLines: maxLines,
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<BatchScheduleItemModel> items;

  const _ScheduleList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return smallText(
        text: '-',
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.blackColor.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: normalText(
                        text: item.day,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: smallText(
                          text:
                              '${_formatTimeLabel(item.startTime)} - ${_formatTimeLabel(item.endTime)}',
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _formatTimeLabel(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '-';
    }

    try {
      final parsed = TimeOfDay(
        hour: int.parse(trimmed.split(':').first),
        minute: int.parse(trimmed.split(':').last),
      );
      final hour = parsed.hourOfPeriod == 0 ? 12 : parsed.hourOfPeriod;
      final minute = parsed.minute.toString().padLeft(2, '0');
      final period = parsed.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    } catch (_) {
      return trimmed;
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 46.h,
          alignment: Alignment.center,
          child: brandText(
            text: text,
            color: AppColors.whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
