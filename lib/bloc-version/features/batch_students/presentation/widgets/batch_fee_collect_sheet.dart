import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/batch_students_cubit.dart';
import '../bloc/batch_students_state.dart';

class BatchFeeCollectSheet extends StatefulWidget {
  final BatchStudentsCubit cubit;

  const BatchFeeCollectSheet({super.key, required this.cubit});

  @override
  State<BatchFeeCollectSheet> createState() => _BatchFeeCollectSheetState();
}

class _BatchFeeCollectSheetState extends State<BatchFeeCollectSheet> {
  late final TextEditingController _originalAmountController;
  late final TextEditingController _amountPaidController;
  late final TextEditingController _notesController;
  String _paymentMethod = 'Cash';
  bool _customAmount = false;

  static const List<String> _paymentMethods = [
    'Cash',
    'bKash',
    'Nagad',
    'Rocket',
    'Bank',
  ];

  @override
  void initState() {
    super.initState();
    final state = widget.cubit.state;
    final total = state.selectedOriginalAmount;
    _originalAmountController = TextEditingController(
      text: total.toStringAsFixed(0),
    );
    _amountPaidController = TextEditingController(
      text: total.toStringAsFixed(0),
    );
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _originalAmountController.dispose();
    _amountPaidController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _syncAmount(BatchStudentsState state) {
    final total = state.selectedOriginalAmount;
    _originalAmountController.text = total.toStringAsFixed(0);
    if (!_customAmount) {
      _amountPaidController.text = total.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BatchStudentsCubit, BatchStudentsState>(
      bloc: widget.cubit,
      listener: (context, state) {
        _syncAmount(state);
      },
      builder: (context, state) {
        final count = state.selectedStudentCount;

        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SingleChildScrollView(
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
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collect Fees',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000710),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0066FF,
                          ).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          '$count Student${count > 1 ? 's' : ''}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0066FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Months Chips
                  Text(
                    'Collecting For Month(s)',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000710),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: state.availableFinanceMonths.map((month) {
                      final isSelected = state.selectedFeeMonths.contains(
                        month,
                      );
                      return FilterChip(
                        label: Text(month),
                        selected: isSelected,
                        selectedColor: const Color(
                          0xFF0066FF,
                        ).withValues(alpha: 0.15),
                        checkmarkColor: const Color(0xFF0066FF),
                        labelStyle: GoogleFonts.spaceGrotesk(
                          fontSize: 12.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF0066FF)
                              : const Color(0xFF000710),
                        ),
                        backgroundColor: const Color(0xFFF8FAFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF0066FF)
                                : Colors.transparent,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            widget.cubit.addFeeMonth(month);
                          } else {
                            if (state.selectedFeeMonths.length > 1) {
                              widget.cubit.removeFeeMonth(month);
                            }
                          }
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),

                  // Amounts Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Original Amount',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000710),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            TextField(
                              controller: _originalAmountController,
                              readOnly: true,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                prefixText: '৳ ',
                                filled: true,
                                fillColor: const Color(0xFFF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount Paid',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000710),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            TextField(
                              controller: _amountPaidController,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                _customAmount = true;
                              },
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0066FF),
                              ),
                              decoration: InputDecoration(
                                prefixText: '৳ ',
                                filled: true,
                                fillColor: const Color(0xFFF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Payment Method
                  Text(
                    'Payment Method',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000710),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: _paymentMethods.map((method) {
                      final isSelected = _paymentMethod == method;
                      return ChoiceChip(
                        label: Text(method),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0066FF),
                        labelStyle: GoogleFonts.spaceGrotesk(
                          fontSize: 13.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF000710),
                        ),
                        backgroundColor: const Color(0xFFF8FAFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        onSelected: (_) =>
                            setState(() => _paymentMethod = method),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),

                  // Notes
                  Text(
                    'Notes (Optional)',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000710),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: _notesController,
                    maxLines: 2,
                    style: GoogleFonts.spaceGrotesk(fontSize: 13.sp),
                    decoration: InputDecoration(
                      hintText: 'Enter receipt or transaction info...',
                      filled: true,
                      fillColor: const Color(0xFFF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0066FF)),
                            minimumSize: Size.fromHeight(50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
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
                          onPressed: state.isCollectingFee
                              ? null
                              : () async {
                                  final amountPaid =
                                      double.tryParse(
                                        _amountPaidController.text.trim(),
                                      ) ??
                                      0.0;
                                  final originalAmount =
                                      double.tryParse(
                                        _originalAmountController.text.trim(),
                                      ) ??
                                      0.0;

                                  final success = await widget.cubit
                                      .collectFees(
                                        amountPaid: amountPaid,
                                        originalAmount: originalAmount,
                                        paymentMethod: _paymentMethod,
                                        notes: _notesController.text.trim(),
                                      );

                                  if (success && context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: Size.fromHeight(50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: state.isCollectingFee
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
                                  'Confirm Collection',
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
        );
      },
    );
  }
}
