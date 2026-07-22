import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../../batch_students/controller/batch_students_controller.dart';
import '../../batch_students/model/batch_student_model.dart';

class StudentEditController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final rollNumberController = TextEditingController();
  final guardianPhoneController = TextEditingController();
  final batchNameController = TextEditingController();
  final batchStartedAtController = TextEditingController();
  final monthlyFeeController = TextEditingController();
  final discountController = TextEditingController();
  final payableFeeController = TextEditingController();
  final notesController = TextEditingController();

  final isLoading = false.obs;

  final _api = ApiService.instance;

  late final BatchStudentModel student;
  BatchListItemModel? selectedBatch;
  DateTime? batchStartDate;
  DateTime? batchEndDate;
  late DateTime _selectedDate;
  late double _baseMonthlyFee;
  late double _baseDiscount;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _fillControllers();
    discountController.addListener(_syncPayableFee);
    _syncPayableFee();
  }

  void _loadArguments() {
    final args = Get.arguments;
    if (args is Map) {
      final rawStudent = args['student'];
      if (rawStudent is BatchStudentModel) {
        student = rawStudent;
      } else {
        throw ArgumentError('StudentEditController requires a student');
      }

      final rawBatch = args['batch'];
      if (rawBatch is BatchListItemModel) {
        selectedBatch = rawBatch;
        batchStartDate = _parseDate(rawBatch.startDate);
        batchEndDate = _parseDate(rawBatch.endDate);
      } else {
        batchStartDate = _parseDate(args['batch_start_date']?.toString() ?? '');
        batchEndDate = _parseDate(args['batch_end_date']?.toString() ?? '');
      }
    } else if (args is BatchStudentModel) {
      student = args;
    } else {
      throw ArgumentError('StudentEditController requires student arguments');
    }

    _baseMonthlyFee = student.monthlyFee;
    _baseDiscount = student.discount;
    _selectedDate = _parseDate(student.batchStartedAt) ?? DateTime.now();
    _selectedDate = _clampDate(
      _selectedDate,
      batchStartDate ?? DateTime(2000),
      batchEndDate ?? DateTime(2100),
    );
  }

  void _fillControllers() {
    firstNameController.text = student.firstName;
    rollNumberController.text = student.rollNumber;
    guardianPhoneController.text = student.guardianPhone;
    batchNameController.text = selectedBatch?.batchName ?? '';
    batchStartedAtController.text = _formatDisplayDate(_selectedDate);
    monthlyFeeController.text = _formatAmount(_baseMonthlyFee);
    discountController.text = _formatAmount(_baseDiscount);
    notesController.text = student.notes;
  }

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value);
    } catch (_) {
      try {
        return DateFormat('d MMMM yyyy').parse(value);
      } catch (_) {
        return null;
      }
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

  String _formatDisplayDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  String _formatSubmitDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatAmount(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

  double get discountValue =>
      double.tryParse(discountController.text.trim()) ?? 0;

  double get monthlyFeeValue =>
      double.tryParse(monthlyFeeController.text.trim()) ?? _baseMonthlyFee;

  double get payableFee {
    final discount = discountValue.clamp(0, 100);
    final amount = monthlyFeeValue - (monthlyFeeValue * discount / 100);
    return amount < 0 ? 0 : amount;
  }

  void _syncPayableFee() {
    payableFeeController.text = _formatAmount(payableFee);
  }

  Future<void> pickBatchStartedDate(BuildContext context) async {
    final firstDate = batchStartDate ?? DateTime(2000);
    final lastDate = batchEndDate ?? DateTime(2100);
    final initialDate = _clampDate(_selectedDate, firstDate, lastDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      _selectedDate = picked;
      batchStartedAtController.text = _formatDisplayDate(picked);
    }
  }

  Map<String, dynamic> _buildPayload() {
    final payload = <String, dynamic>{};

    void addIfChanged(String key, String current, String original) {
      if (current.trim() != original.trim()) {
        payload[key] = current.trim();
      }
    }

    addIfChanged('first_name', firstNameController.text, student.firstName);
    addIfChanged('roll_number', rollNumberController.text, student.rollNumber);
    addIfChanged(
      'guardian_phone',
      guardianPhoneController.text,
      student.guardianPhone,
    );

    final currentBatchStartedAt = _formatSubmitDate(_selectedDate);
    if (currentBatchStartedAt != student.batchStartedAt) {
      payload['batch_started_at'] = currentBatchStartedAt;
    }

    final currentMonthlyFee = monthlyFeeValue;
    if (currentMonthlyFee != _baseMonthlyFee) {
      payload['monthly_fee'] = currentMonthlyFee;
    }

    final currentDiscount = discountValue;
    if (currentDiscount != _baseDiscount) {
      payload['discount'] = currentDiscount;
    }

    addIfChanged('notes', notesController.text, student.notes);

    return payload;
  }

  Future<void> submit() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      Get.snackbar(
        'missing_fields'.tr,
        'fill_required_fields'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final payload = _buildPayload();
    if (payload.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'no_changes_to_update'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      log('Student edit payload: ${jsonEncode(payload)}');
      final response = await _api.patch(Urls.studentById(student.id), payload);
      log('Student edit response: $response');

      if (response != null) {
        Get.snackbar(
          'success'.tr,
          'student_updated_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        try {
          await Get.find<BatchStudentsController>().refreshStudents();
        } catch (_) {}
        Get.back();
      } else {
        Get.snackbar(
          'failed'.tr,
          'student_update_failed'.tr,
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
    firstNameController.dispose();
    rollNumberController.dispose();
    guardianPhoneController.dispose();
    batchNameController.dispose();
    batchStartedAtController.dispose();
    monthlyFeeController.dispose();
    discountController.removeListener(_syncPayableFee);
    discountController.dispose();
    payableFeeController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
