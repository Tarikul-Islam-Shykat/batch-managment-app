import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import 'bloc/create_student_cubit.dart';
import 'bloc/create_student_state.dart';

class CreateStudentView extends StatelessWidget {
  final BatchListItemModel? batch;

  const CreateStudentView({super.key, this.batch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateStudentCubit>(
      create: (context) => sl<CreateStudentCubit>()..init(batch),
      child: _CreateStudentBody(passedBatch: batch),
    );
  }
}

class _CreateStudentBody extends StatefulWidget {
  final BatchListItemModel? passedBatch;

  const _CreateStudentBody({this.passedBatch});

  @override
  State<_CreateStudentBody> createState() => _CreateStudentBodyState();
}

class _CreateStudentBodyState extends State<_CreateStudentBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _studentNameController;
  late final TextEditingController _rollNumberController;
  late final TextEditingController _guardianPhoneController;
  late final TextEditingController _batchNameController;
  late final TextEditingController _monthlyFeeController;
  late final TextEditingController _discountController;
  late final TextEditingController _payableFeeController;
  late final TextEditingController _batchStartedAtController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _studentNameController = TextEditingController();
    _rollNumberController = TextEditingController();
    _guardianPhoneController = TextEditingController();
    _batchNameController = TextEditingController();
    _monthlyFeeController = TextEditingController();
    _discountController = TextEditingController(text: '0');
    _payableFeeController = TextEditingController();
    _batchStartedAtController = TextEditingController();
    _notesController = TextEditingController();

    _discountController.addListener(_onDiscountChanged);
  }

  void _onDiscountChanged() {
    final text = _discountController.text.trim();
    final discount = double.tryParse(text) ?? 0.0;
    context.read<CreateStudentCubit>().updateDiscount(discount);
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _rollNumberController.dispose();
    _guardianPhoneController.dispose();
    _batchNameController.dispose();
    _monthlyFeeController.dispose();
    _discountController.removeListener(_onDiscountChanged);
    _discountController.dispose();
    _payableFeeController.dispose();
    _batchStartedAtController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, CreateStudentState state) async {
    final cubit = context.read<CreateStudentCubit>();
    final firstDate = state.batchStartDate ?? DateTime(2000);
    final lastDate = state.batchEndDate ?? DateTime(2100);

    DateTime initialDate = state.selectedDate;
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(lastDate)) initialDate = lastDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
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

    if (picked != null) {
      cubit.updateSelectedDate(picked);
      _batchStartedAtController.text = cubit.formatDate(picked);
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool isMandatory = false,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    VoidCallback? onTap,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onTap: onTap,
          validator: validator,
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
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFF0066FF),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateStudentCubit, CreateStudentState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage!,
            isSuccess: false,
          );
        }

        if (state.isSuccess) {
          AppSnackbar.show(
            context: context,
            message: state.successMessage ?? 'Student enrolled successfully!',
            isSuccess: true,
          );
          Navigator.of(context).pop(true);
        }

        // Sync controllers when state updates
        if (state.selectedBatch != null) {
          _batchNameController.text = state.selectedBatch!.batchName;
          final cubit = context.read<CreateStudentCubit>();
          _monthlyFeeController.text = cubit.formatAmount(state.baseMonthlyFee);
          _payableFeeController.text = cubit.formatAmount(state.payableFee);
          _batchStartedAtController.text = cubit.formatDate(state.selectedDate);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudentCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
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
                    'Enroll Student',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      color: const Color(0xFF000710),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    state.selectedBatch != null
                        ? 'For ${state.selectedBatch!.batchName}'
                        : 'Enroll a new student to your batch',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Name
                    _buildField(
                      controller: _studentNameController,
                      labelText: 'Student Name',
                      hintText: 'Enter student name',
                      isMandatory: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter student name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),

                    // Roll Number
                    _buildField(
                      controller: _rollNumberController,
                      labelText: 'Roll Number',
                      hintText: 'Enter roll number',
                      isMandatory: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter roll number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),

                    // Guardian Phone
                    _buildField(
                      controller: _guardianPhoneController,
                      labelText: 'Guardian Phone',
                      hintText: 'Enter guardian phone number',
                      isMandatory: true,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter guardian phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),

                    // Batch Selector / Readonly Field
                    if (widget.passedBatch == null &&
                        state.availableBatches.isNotEmpty) ...[
                      Text(
                        'Select Batch',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000710),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<BatchListItemModel>(
                            isExpanded: true,
                            value: state.selectedBatch,
                            hint: Text(
                              'Choose Batch',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                color: const Color(0xFF898989),
                              ),
                            ),
                            items: state.availableBatches.map((b) {
                              return DropdownMenuItem<BatchListItemModel>(
                                value: b,
                                child: Text(
                                  b.batchName,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF000710),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (batch) {
                              if (batch != null) {
                                cubit.selectBatch(batch);
                              }
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      _buildField(
                        controller: _batchNameController,
                        labelText: 'Batch Name',
                        hintText: 'Batch name',
                        readOnly: true,
                      ),
                    ],
                    SizedBox(height: 14.h),

                    // Monthly Fee (Read-only with Automatic badge)
                    _buildField(
                      controller: _monthlyFeeController,
                      labelText: 'Monthly Fee',
                      hintText: 'Monthly fee',
                      readOnly: true,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 14.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Automatic',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Discount (%) & Payable Fee
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _discountController,
                            labelText: 'Discount (%)',
                            hintText: '0',
                            isMandatory: true,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final discount = int.tryParse(
                                value?.trim() ?? '',
                              );
                              if (discount == null) {
                                return 'Enter discount';
                              }
                              if (discount < 0 || discount > 100) {
                                return '0-100 only';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildField(
                            controller: _payableFeeController,
                            labelText: 'Payable Fee',
                            hintText: '0',
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // Batch Started At (Date Picker)
                    _buildField(
                      controller: _batchStartedAtController,
                      labelText: 'Batch Started At',
                      hintText: 'Select date',
                      isMandatory: true,
                      readOnly: true,
                      onTap: () => _pickDate(context, state),
                      suffixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        color: Color(0xFF000710),
                        size: 20,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Select start date';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),

                    // Notes
                    _buildField(
                      controller: _notesController,
                      labelText: 'Notes',
                      hintText: 'Enter any additional notes (optional)',
                      maxLines: 4,
                    ),
                    SizedBox(height: 24.h),

                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0066FF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              minimumSize: Size.fromHeight(52.h),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15.sp,
                                color: const Color(0xFF0066FF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      cubit.submitStudent(
                                        firstName: _studentNameController.text,
                                        rollNumber: _rollNumberController.text,
                                        guardianPhone:
                                            _guardianPhoneController.text,
                                        notes: _notesController.text,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: Size.fromHeight(52.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: state.isLoading
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Save Student',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
