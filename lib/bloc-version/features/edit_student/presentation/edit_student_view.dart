import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'package:batch_management_app_direct/bloc-version/features/batch_students/data/models/batch_students_model.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import 'bloc/edit_student_cubit.dart';
import 'bloc/edit_student_state.dart';

class EditStudentView extends StatelessWidget {
  final BatchStudentModel student;
  final BatchListItemModel? batch;

  const EditStudentView({super.key, required this.student, this.batch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditStudentCubit>(
      create: (context) => sl<EditStudentCubit>()..init(student, batch),
      child: _EditStudentBody(student: student, batch: batch),
    );
  }
}

class _EditStudentBody extends StatefulWidget {
  final BatchStudentModel student;
  final BatchListItemModel? batch;

  const _EditStudentBody({required this.student, this.batch});

  @override
  State<_EditStudentBody> createState() => _EditStudentBodyState();
}

class _EditStudentBodyState extends State<_EditStudentBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _rollNumberController;
  late final TextEditingController _guardianPhoneController;
  late final TextEditingController _monthlyFeeController;
  late final TextEditingController _discountController;
  late final TextEditingController _payableFeeController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _firstNameController = TextEditingController(text: s.firstName);
    _rollNumberController = TextEditingController(text: s.rollNumber);
    _guardianPhoneController = TextEditingController(text: s.guardianPhone);
    _monthlyFeeController = TextEditingController(
      text: s.monthlyFee.toStringAsFixed(0),
    );
    _discountController = TextEditingController(
      text: s.discount.toStringAsFixed(0),
    );
    _payableFeeController = TextEditingController(
      text: s.payableMonthlyAmount.toStringAsFixed(0),
    );
    _notesController = TextEditingController(text: s.notes);

    _discountController.addListener(_onDiscountChanged);
    _monthlyFeeController.addListener(_onFeeChanged);
  }

  void _onDiscountChanged() {
    final discount = double.tryParse(_discountController.text.trim()) ?? 0.0;
    context.read<EditStudentCubit>().updateDiscount(discount);
  }

  void _onFeeChanged() {
    final fee = double.tryParse(_monthlyFeeController.text.trim()) ?? 0.0;
    context.read<EditStudentCubit>().updateFee(fee);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _rollNumberController.dispose();
    _guardianPhoneController.dispose();
    _monthlyFeeController.removeListener(_onFeeChanged);
    _monthlyFeeController.dispose();
    _discountController.removeListener(_onDiscountChanged);
    _discountController.dispose();
    _payableFeeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool isMandatory = false,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
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
    return BlocConsumer<EditStudentCubit, EditStudentState>(
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
            message: 'Student updated successfully!',
            isSuccess: true,
          );
          Navigator.of(context).pop(true);
        }

        _payableFeeController.text = state.payableFee.toStringAsFixed(0);
      },
      builder: (context, state) {
        final cubit = context.read<EditStudentCubit>();

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
                    'Edit Student',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      color: const Color(0xFF000710),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Update ${widget.student.firstName}\'s details',
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
                    // Name
                    _buildField(
                      controller: _firstNameController,
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

                    // Batch Name
                    if (widget.batch != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batch',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF000710),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              widget.batch!.batchName,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                color: const Color(0xFF000710),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                    ],

                    // Monthly Fee
                    _buildField(
                      controller: _monthlyFeeController,
                      labelText: 'Monthly Fee',
                      hintText: 'Enter fee amount',
                      isMandatory: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter monthly fee';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),

                    // Discount & Payable Fee
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

                    // Notes
                    _buildField(
                      controller: _notesController,
                      labelText: 'Notes',
                      hintText: 'Enter notes (optional)',
                      maxLines: 4,
                    ),
                    SizedBox(height: 24.h),

                    // Actions
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
                                      cubit.submitUpdate(
                                        firstName: _firstNameController.text,
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
                                    'Update Student',
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
