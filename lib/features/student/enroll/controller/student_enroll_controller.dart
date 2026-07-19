import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../model/student_enroll_request_model.dart';

class StudentEnrollController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final studentNameController = TextEditingController();
  final rollNumberController = TextEditingController();
  final guardianPhoneController = TextEditingController();
  final batchNameController = TextEditingController();
  final monthlyFeeController = TextEditingController();
  final discountController = TextEditingController(text: '0');
  final payableFeeController = TextEditingController();
  final batchStartedAtController = TextEditingController();
  final notesController = TextEditingController();

  final isLoading = false.obs;
  final selectedBatch = Rxn<BatchListItemModel>();

  final _api = ApiService.instance;
  DateTime _selectedDate = DateTime.now();
  DateTime? _batchStartDate;
  DateTime? _batchEndDate;
  double _baseMonthlyFee = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is BatchListItemModel) {
      selectedBatch.value = args;
      _baseMonthlyFee = args.fees;
      batchNameController.text = args.batchName;
      monthlyFeeController.text = _formatAmount(_baseMonthlyFee);
      _batchStartDate = _parseDate(args.startDate);
      _batchEndDate = _parseDate(args.endDate);
      final fallbackStart = _batchStartDate ?? DateTime.now();
      final fallbackEnd = _batchEndDate ?? fallbackStart;
      _selectedDate = _clampDate(fallbackStart, fallbackStart, fallbackEnd);
      batchStartedAtController.text = _formatDate(_selectedDate);
    } else {
      batchNameController.text = '';
      monthlyFeeController.text = '0';
      batchStartedAtController.text = _formatDate(_selectedDate);
    }

    discountController.addListener(_syncPayableFee);
    _syncPayableFee();
  }

  DateTime? _parseDate(String value) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  DateTime _clampDate(DateTime value, DateTime firstDate, DateTime lastDate) {
    if (value.isBefore(firstDate)) {
      return firstDate;
    }
    if (value.isAfter(lastDate)) {
      return lastDate;
    }
    return value;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatAmount(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

  double get discountValue =>
      double.tryParse(discountController.text.trim()) ?? 0;

  double get payableFee {
    final discount = discountValue.clamp(0, 100);
    final amount = _baseMonthlyFee - (_baseMonthlyFee * discount / 100);
    return amount < 0 ? 0 : amount;
  }

  void _syncPayableFee() {
    payableFeeController.text = _formatAmount(payableFee);
  }

  Future<void> pickBatchStartedDate(BuildContext context) async {
    final firstDate = _batchStartDate ?? DateTime(2000);
    final lastDate = _batchEndDate ?? DateTime(2100);
    final initialDate = _clampDate(_selectedDate, firstDate, lastDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      _selectedDate = picked;
      batchStartedAtController.text = _formatDate(picked);
    }
  }

  Future<void> submit() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid || selectedBatch.value == null) {
      Get.snackbar(
        'missing_fields'.tr,
        'fill_required_fields'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final discount = discountValue;
    if (discount < 0 || discount > 100) {
      Get.snackbar(
        'invalid_input'.tr,
        'discount_between_0_100'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final payload = StudentEnrollRequestModel(
      firstName: studentNameController.text.trim(),
      rollNumber: rollNumberController.text.trim(),
      guardianPhone: guardianPhoneController.text.trim(),
      enrolledBatchId: selectedBatch.value!.id,
      batchStartedAt: batchStartedAtController.text.trim(),
      monthlyFee: _baseMonthlyFee,
      discount: discount,
      notes: notesController.text.trim(),
    );

    try {
      isLoading.value = true;
      log('Student enroll payload: ${jsonEncode(payload.toJson())}');
      final response = await _api.post(Urls.students, payload.toJson());
      if (response != null) {
        Get.snackbar(
          'success'.tr,
          'student_saved_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      } else {
        Get.snackbar(
          'failed'.tr,
          'student_save_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    studentNameController.dispose();
    rollNumberController.dispose();
    guardianPhoneController.dispose();
    batchNameController.dispose();
    monthlyFeeController.dispose();
    discountController.removeListener(_syncPayableFee);
    discountController.dispose();
    payableFeeController.dispose();
    batchStartedAtController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
