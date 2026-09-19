import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'bloc/create_batch_cubit.dart';
import 'bloc/create_batch_state.dart';
import 'widgets/schedule_card.dart';

class CreateBatchView extends StatelessWidget {
  final bool showBackButton;

  const CreateBatchView({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateBatchCubit>(
      create: (context) => sl<CreateBatchCubit>(),
      child: _CreateBatchBody(showBackButton: showBackButton),
    );
  }
}

class _CreateBatchBody extends StatefulWidget {
  final bool showBackButton;

  const _CreateBatchBody({required this.showBackButton});

  @override
  State<_CreateBatchBody> createState() => _CreateBatchBodyState();
}

class _CreateBatchBodyState extends State<_CreateBatchBody> {
  final _batchNameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _feesController = TextEditingController();
  final _maxStudentsController = TextEditingController();

  static const List<String> _daysOfWeek = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void dispose() {
    _batchNameController.dispose();
    _subjectController.dispose();
    _feesController.dispose();
    _maxStudentsController.dispose();
    super.dispose();
  }

  void _clearLocalControllers() {
    _batchNameController.clear();
    _subjectController.clear();
    _feesController.clear();
    _maxStudentsController.clear();
  }

  String _formatTime12h(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<DateTime?> _pickDate(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066FF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF000710),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> _pickTime(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066FF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF000710),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool isMandatory = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    Widget? labelTrailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000710),
              ),
            ),
            if (isMandatory) ...[
              SizedBox(width: 2.w),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
            if (labelTrailing != null) ...[const Spacer(), labelTrailing],
          ],
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14.sp,
            color: const Color(0xFF000710),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.spaceGrotesk(
              fontSize: 14.sp,
              color: const Color(0xFF898989),
            ),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 14.w,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyPickerField({
    required String labelText,
    required String hintText,
    required String valueText,
    required VoidCallback onTap,
    IconData icon = Icons.calendar_month_outlined,
    bool isMandatory = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000710),
              ),
            ),
            if (isMandatory) ...[
              SizedBox(width: 2.w),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  valueText.isNotEmpty ? valueText : hintText,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14.sp,
                    color: valueText.isNotEmpty
                        ? const Color(0xFF000710)
                        : const Color(0xFF898989),
                  ),
                ),
                Icon(icon, size: 20.sp, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateBatchCubit, CreateBatchState>(
      listener: (context, state) {
        if (state is CreateBatchValidationError) {
          AppSnackbar.show(
            context: context,
            message: state.message,
            isSuccess: false,
          );
        } else if (state is CreateBatchFailure) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage,
            isSuccess: false,
          );
        } else if (state is CreateBatchSuccess) {
          AppSnackbar.show(
            context: context,
            message: 'Batch created successfully!',
            isSuccess: true,
          );
          _clearLocalControllers();
          context.read<CreateBatchCubit>().resetForm();
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateBatchLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72.h),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: widget.showBackButton,
              titleSpacing: 16.w,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create Batch',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      color: const Color(0xFF000710),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Set up your batch & schedules',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField(
                          controller: _batchNameController,
                          labelText: 'Batch Name',
                          hintText: 'Enter batch name',
                          isMandatory: true,
                        ),
                        SizedBox(height: 14.h),

                        _buildField(
                          controller: _subjectController,
                          labelText: 'Subject Name',
                          hintText: 'Enter subject name',
                          isMandatory: true,
                          labelTrailing: Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFF000710,
                                ).withValues(alpha: 0.5),
                              ),
                            ),
                            child: const Icon(Icons.add, size: 18),
                          ),
                        ),
                        SizedBox(height: 14.h),

                        _buildField(
                          controller: _feesController,
                          labelText: 'Fees Per Student',
                          hintText: 'Enter fees amount',
                          isMandatory: true,
                          keyboardType: TextInputType.number,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Center(
                              widthFactor: 0,
                              child: Text(
                                '/ student',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.black87,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),

                        // Date Pickers Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildReadOnlyPickerField(
                                labelText: 'Start Date',
                                hintText: 'Start Date',
                                valueText: state.startDate != null
                                    ? _formatDate(state.startDate!)
                                    : '',
                                isMandatory: true,
                                onTap: () async {
                                  final cubit = context
                                      .read<CreateBatchCubit>();
                                  final picked = await _pickDate(
                                    context,
                                    initialDate:
                                        state.startDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                  );
                                  if (picked != null) {
                                    cubit.setStartDate(picked);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildReadOnlyPickerField(
                                labelText: 'End Date',
                                hintText: 'End Date',
                                valueText: state.endDate != null
                                    ? _formatDate(state.endDate!)
                                    : '',
                                isMandatory: true,
                                icon: Icons.calendar_month_outlined,
                                onTap: () async {
                                  final cubit = context
                                      .read<CreateBatchCubit>();
                                  final picked = await _pickDate(
                                    context,
                                    initialDate:
                                        state.endDate ??
                                        state.startDate ??
                                        DateTime.now(),
                                    firstDate:
                                        state.startDate ?? DateTime(2000),
                                  );
                                  if (picked != null) {
                                    cubit.setEndDate(picked);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        _buildField(
                          controller: _maxStudentsController,
                          labelText: 'Max Students',
                          hintText: 'Enter maximum student capacity',
                          isMandatory: true,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),

                        // Default Class Time Header
                        Row(
                          children: [
                            Text(
                              'Default Class Time',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000710),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<CreateBatchCubit>()
                                    .applyDefaultTimeToAll();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Apply to all days',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF0066FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        // Default Time Pickers Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildReadOnlyPickerField(
                                labelText: 'Start Time',
                                hintText: 'Start Time',
                                valueText: _formatTime12h(
                                  state.defaultStartTime,
                                ),
                                icon: Icons.access_time_rounded,
                                onTap: () async {
                                  final cubit = context
                                      .read<CreateBatchCubit>();
                                  final picked = await _pickTime(
                                    context,
                                    initialTime: state.defaultStartTime,
                                  );
                                  if (picked != null) {
                                    cubit.setDefaultStartTime(picked);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildReadOnlyPickerField(
                                labelText: 'End Time',
                                hintText: 'End Time',
                                valueText: _formatTime12h(state.defaultEndTime),
                                icon: Icons.access_time_rounded,
                                onTap: () async {
                                  final cubit = context
                                      .read<CreateBatchCubit>();
                                  final picked = await _pickTime(
                                    context,
                                    initialTime: state.defaultEndTime,
                                  );
                                  if (picked != null) {
                                    cubit.setDefaultEndTime(picked);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          'Class Days',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF000710),
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Days Selection Chips
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _daysOfWeek.map((day) {
                            final selected = state.selectedDays.contains(day);
                            return ChoiceChip(
                              showCheckmark: true,
                              checkmarkColor: Colors.white,
                              label: Text(
                                day,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 13.sp,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF000710),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: selected,
                              selectedColor: const Color(0xFF000710),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                side: BorderSide(
                                  color: selected
                                      ? const Color(0xFF000710)
                                      : const Color(
                                          0xFF000710,
                                        ).withValues(alpha: 0.15),
                                ),
                              ),
                              onSelected: (_) {
                                context.read<CreateBatchCubit>().toggleDay(day);
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 14.h),

                        // List of schedule cards
                        if (state.scheduleItems.isNotEmpty)
                          Column(
                            children: [
                              for (
                                int i = 0;
                                i < state.scheduleItems.length;
                                i++
                              )
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: ScheduleCard(
                                    index: i,
                                    item: state.scheduleItems[i],
                                    onResetDefault: () {
                                      context
                                          .read<CreateBatchCubit>()
                                          .applyDefaultTimeToItem(i);
                                    },
                                    onPickStartTime: () async {
                                      final cubit = context
                                          .read<CreateBatchCubit>();
                                      final picked = await _pickTime(
                                        context,
                                        initialTime:
                                            state.scheduleItems[i].startTime,
                                      );
                                      if (picked != null) {
                                        cubit.updateScheduleTime(
                                          i,
                                          startTime: picked,
                                        );
                                      }
                                    },
                                    onPickEndTime: () async {
                                      final cubit = context
                                          .read<CreateBatchCubit>();
                                      final picked = await _pickTime(
                                        context,
                                        initialTime:
                                            state.scheduleItems[i].endTime,
                                      );
                                      if (picked != null) {
                                        cubit.updateScheduleTime(
                                          i,
                                          endTime: picked,
                                        );
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                // Bottom Actions
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _clearLocalControllers();
                            context.read<CreateBatchCubit>().resetForm();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0066FF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            minimumSize: Size.fromHeight(52.h),
                          ),
                          child: Text(
                            'Reset',
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color(0xFF0066FF),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            minimumSize: Size.fromHeight(52.h),
                            elevation: 0,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  context.read<CreateBatchCubit>().createBatch(
                                    batchName: _batchNameController.text,
                                    subject: _subjectController.text,
                                    fees: _feesController.text,
                                    maxStudents: _maxStudentsController.text,
                                  );
                                },
                          child: isLoading
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Create Batch',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
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
