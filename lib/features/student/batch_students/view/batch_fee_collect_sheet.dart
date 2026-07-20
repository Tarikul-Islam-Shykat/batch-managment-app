import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/global/app_btn.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/spacing.dart';
import '../../../../core/global/text_form_field.dart';
import '../controller/batch_students_controller.dart';

class BatchFeeCollectSheet extends StatefulWidget {
  final BatchStudentsController controller;

  const BatchFeeCollectSheet({super.key, required this.controller});

  @override
  State<BatchFeeCollectSheet> createState() => _BatchFeeCollectSheetState();
}

class _BatchFeeCollectSheetState extends State<BatchFeeCollectSheet> {
  late final TextEditingController _originalAmountController;
  late final TextEditingController _amountPaidController;
  late final TextEditingController _notesController;
  String _paymentMethod = 'Cash';
  bool _customAmount = false;

  BatchStudentsController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    final amount = controller.selectedOriginalAmount;
    _originalAmountController = TextEditingController(
      text: amount.toStringAsFixed(0),
    );
    _amountPaidController = TextEditingController(
      text: amount.toStringAsFixed(0),
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

  void _syncAmount() {
    _originalAmountController.text = controller.selectedOriginalAmount
        .toStringAsFixed(0);
    if (!_customAmount) {
      _amountPaidController.text = controller.selectedOriginalAmount
          .toStringAsFixed(0);
    }
  }

  Future<void> _openMonthPicker() async {
    final availableMonths = controller.availableFeeMonthOptions;
    if (availableMonths.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'no_more_months'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
            itemCount: availableMonths.length + 1,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  children: [
                    Expanded(
                      child: brandText(
                        text: 'select_month'.tr,
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                );
              }

              final month = availableMonths[index - 1];
              return Material(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(14.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.r),
                  onTap: () {
                    setState(() {
                      controller.addFeeMonth(month);
                    });
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(14.w),
                    child: normalText(
                      text: month,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _submit() async {
    final selectedStudents = controller.selectedStudents;
    if (selectedStudents.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'select_at_least_one_student'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (controller.selectedFeeMonths.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'select_month'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final amountText = _amountPaidController.text.trim();
    final originalText = _originalAmountController.text.trim();
    final amountPaid = double.tryParse(amountText);
    final originalAmount = double.tryParse(originalText);

    if (amountPaid == null || amountPaid <= 0) {
      Get.snackbar(
        'failed'.tr,
        'enter_number'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await controller.collectSelectedFees(
      amountPaid: amountPaid,
      originalAmount: originalAmount ?? controller.selectedOriginalAmount,
      paymentMethod: _paymentMethod,
      notes: _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.92.sh),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
          child: Obx(() {
            _syncAmount();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 46.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                verticalSpace(12),
                brandText(
                  text: 'collect_fee'.tr,
                  color: AppColors.blackColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  textAlign: TextAlign.start,
                ),
                verticalSpace(6),
                normalText(
                  text:
                      '${'selected_students'.tr}: ${controller.selectedStudentCount}',
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                verticalSpace(16),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: controller.selectedStudents
                      .map(
                        (student) => Chip(
                          label: smallText(
                            text: student.firstName,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: AppColors.whiteColor,
                        ),
                      )
                      .toList(),
                ),
                verticalSpace(16),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallText(
                        text: 'selected_months'.tr,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                      verticalSpace(8),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: controller.selectedFeeMonths.map((month) {
                          return InputChip(
                            label: Text(month),
                            selected: true,
                            selectedColor: AppColors.primaryColor.withValues(
                              alpha: 0.12,
                            ),
                            onDeleted: () => setState(() {
                              controller.removeFeeMonth(month);
                            }),
                          );
                        }).toList(),
                      ),
                      verticalSpace(12),
                      InkWell(
                        onTap: _openMonthPicker,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: normalText(
                                  text: 'add_month'.tr,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.black54,
                                size: 22.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (controller.availableFeeMonthOptions.isEmpty) ...[
                        verticalSpace(8),
                        smallText(
                          text: 'no_more_months'.tr,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                      verticalSpace(12),
                      GlobalTextField(
                        controller: _originalAmountController,
                        hintText: 'original_amount'.tr,
                        labelText: 'original_amount'.tr,
                        readOnly: true,
                        isDigitOnly: true,
                      ),
                      verticalSpace(12),
                      Row(
                        children: [
                          Checkbox(
                            value: _customAmount,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _customAmount = value ?? false;
                                _syncAmount();
                              });
                            },
                          ),
                          Expanded(
                            child: normalText(
                              text: 'custom_amount'.tr,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GlobalTextField(
                        controller: _amountPaidController,
                        hintText: 'amount_paid'.tr,
                        labelText: 'amount_paid'.tr,
                        readOnly: !_customAmount,
                        isDigitOnly: true,
                      ),
                      verticalSpace(12),
                      DropdownButtonFormField<String>(
                        initialValue: _paymentMethod,
                        decoration: InputDecoration(
                          labelText: 'payment_method'.tr,
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: Colors.black.withValues(alpha: 0.12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: Colors.black.withValues(alpha: 0.12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        items:
                            ['Cash', 'Card', 'Bank Transfer', 'Mobile Banking']
                                .map(
                                  (method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(method),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _paymentMethod = value);
                          }
                        },
                      ),
                      verticalSpace(12),
                      GlobalTextField(
                        controller: _notesController,
                        hintText: 'notes'.tr,
                        labelText: 'notes'.tr,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                verticalSpace(16),
                Row(
                  children: [
                    Expanded(
                      child: GlobalAppButton(
                        text: 'cancel'.tr,
                        onTap: () => Get.back(),
                        backgroundColor: Colors.white,
                        textColor: AppColors.blackColor,
                        borderRadius: 14,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Obx(
                        () => GlobalAppButton(
                          text: 'confirm_collection'.tr,
                          onTap: _submit,
                          isLoading: controller.isCollectingFee.value,
                          backgroundColor: AppColors.blackColor,
                          borderRadius: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
