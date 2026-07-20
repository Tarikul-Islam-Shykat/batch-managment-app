import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../model/batch_fee_collect_request_model.dart';
import '../model/batch_student_model.dart';
import '../view/batch_fee_collect_sheet.dart';
import '../view/batch_student_profile_sheet.dart';

class BatchStudentsController extends GetxController {
  final _api = ApiService.instance;

  final isLoading = false.obs;
  final isFinanceLoading = false.obs;
  final students = <BatchStudentModel>[].obs;
  final selectedBatch = Rxn<BatchListItemModel>();
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final financeSummary = <String, dynamic>{}.obs;
  final financeMonthLabel = ''.obs;
  final financeMonthOptions = <String>[].obs;
  final selectedFinanceMonth = ''.obs;
  final selectedStudentIds = <String>[].obs;
  final selectedFeeMonths = <String>[].obs;
  final isCollectingFee = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is BatchListItemModel) {
      selectedBatch.value = args;
      initializeFinanceMonths();
      initializeFeeMonths();
      fetchStudents();
      fetchFinanceSummary();
    }
  }

  List<BatchStudentModel> get filteredStudents {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return students;
    }

    return students.where((student) {
      return student.firstName.toLowerCase().contains(query) ||
          student.rollNumber.toLowerCase().contains(query) ||
          student.studentSystemId.toLowerCase().contains(query) ||
          student.guardianPhone.toLowerCase().contains(query) ||
          student.notes.toLowerCase().contains(query) ||
          student.status.toLowerCase().contains(query);
    }).toList();
  }

  double get totalFee =>
      students.fold(0, (sum, student) => sum + student.monthlyFee);

  double get totalDiscount =>
      students.fold(0, (sum, student) => sum + student.discount);

  double get totalPayable => students.fold(
    0,
    (sum, student) =>
        sum + (student.monthlyFee - student.discount).clamp(0, double.infinity),
  );

  String get studentCountLabel {
    final count = filteredStudents.length;
    return '${'student_list'.tr} $count ${'students_unit'.tr}';
  }

  void onSearchChanged(String value) {
    searchQuery.value = value.trim();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  String formatDate(String value) {
    if (value.isEmpty) {
      return '-';
    }

    try {
      final parsed = DateTime.parse(value);
      final localeCode = Get.locale?.toString() ?? 'en_US';
      return DateFormat('dd MMM, yyyy', localeCode).format(parsed);
    } catch (_) {
      return value;
    }
  }

  String scheduleText() {
    final batch = selectedBatch.value;
    if (batch == null || batch.schedule.isEmpty) {
      return '-';
    }

    return batch.schedule
        .map((item) => '${item.day} ${item.startTime} - ${item.endTime}')
        .join(' • ');
  }

  String currentFinanceMonth() =>
      DateFormat('MMMM yyyy', 'en_US').format(DateTime.now());

  String _monthLabel(DateTime value) =>
      DateFormat('MMMM yyyy', 'en_US').format(value);

  List<String> _buildMonthOptions() {
    final batch = selectedBatch.value;
    final now = DateTime.now();
    final options = <String>[];

    DateTime start = DateTime(now.year, now.month);
    DateTime end = DateTime(now.year, now.month);

    if (batch != null) {
      try {
        final parsedStart = DateTime.parse(batch.startDate);
        final parsedEnd = DateTime.parse(batch.endDate);
        start = DateTime(parsedStart.year, parsedStart.month);
        end = DateTime(parsedEnd.year, parsedEnd.month);
        if (end.isBefore(start)) {
          final temp = start;
          start = end;
          end = temp;
        }
      } catch (_) {
        start = DateTime(now.year, now.month);
        end = DateTime(now.year, now.month + 11);
      }
    } else {
      start = DateTime(now.year, now.month - 2);
      end = DateTime(now.year, now.month + 11);
    }

    var cursor = start;
    while (!cursor.isAfter(end)) {
      options.add(_monthLabel(cursor));
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    final current = currentFinanceMonth();
    if (!options.contains(current)) {
      options.add(current);
    }

    return options.toSet().toList();
  }

  void initializeFinanceMonths() {
    final options = _buildMonthOptions();
    financeMonthOptions.assignAll(options);
    selectedFinanceMonth.value = options.contains(currentFinanceMonth())
        ? currentFinanceMonth()
        : (options.isNotEmpty ? options.first : currentFinanceMonth());
  }

  List<String> get availableFinanceMonthOptions {
    return financeMonthOptions.toSet().toList();
  }

  List<String> get availableFeeMonthOptions {
    return financeMonthOptions
        .where((month) => !selectedFeeMonths.contains(month))
        .toSet()
        .toList();
  }

  void initializeFeeMonths() {
    if (selectedFeeMonths.isNotEmpty) {
      return;
    }
    final defaultMonth = selectedFinanceMonth.value.isNotEmpty
        ? selectedFinanceMonth.value
        : currentFinanceMonth();
    selectedFeeMonths.assignAll([defaultMonth]);
  }

  void addFeeMonth(String month) {
    if (month.trim().isEmpty || selectedFeeMonths.contains(month)) {
      return;
    }
    selectedFeeMonths.add(month);
    selectedFeeMonths.refresh();
  }

  void removeFeeMonth(String month) {
    selectedFeeMonths.remove(month);
    selectedFeeMonths.refresh();
  }

  void clearFeeMonths() {
    selectedFeeMonths.clear();
    selectedFeeMonths.refresh();
  }

  void changeFinanceMonth(String month) {
    if (month.trim().isEmpty || selectedFinanceMonth.value == month) {
      return;
    }
    selectedFinanceMonth.value = month;
    fetchFinanceSummary(month: month);
  }

  double get selectedMonthlyAmount {
    return selectedStudents.fold(
      0,
      (sum, student) =>
          sum +
          (student.monthlyFee - student.discount).clamp(0, double.infinity),
    );
  }

  double get selectedOriginalAmount {
    final monthCount = selectedFeeMonths.length;
    return selectedMonthlyAmount * monthCount;
  }

  List<BatchStudentModel> get selectedStudents {
    final ids = selectedStudentIds.toSet();
    return students.where((student) => ids.contains(student.id)).toList();
  }

  int get selectedStudentCount => selectedStudentIds.length;

  bool isStudentSelected(String studentId) =>
      selectedStudentIds.contains(studentId);

  void toggleStudentSelection(String studentId) {
    if (selectedStudentIds.contains(studentId)) {
      selectedStudentIds.remove(studentId);
    } else {
      selectedStudentIds.add(studentId);
    }
    selectedStudentIds.refresh();
  }

  void clearSelectedStudents() {
    selectedStudentIds.clear();
    selectedStudentIds.refresh();
  }

  Future<void> fetchStudents() async {
    final batch = selectedBatch.value;
    if (batch == null) {
      return;
    }

    try {
      isLoading.value = true;
      final response = await _api.get(Urls.studentsByBatch(batch.id));
      if (response is List) {
        students.assignAll(
          response
              .whereType<Map>()
              .map(
                (item) =>
                    BatchStudentModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(),
        );
      } else {
        students.clear();
      }
    } catch (e) {
      log('BatchStudentsController fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFinanceSummary({String? month}) async {
    final batch = selectedBatch.value;
    if (batch == null) {
      return;
    }

    final monthLabel = month ?? selectedFinanceMonth.value;
    if (month != null && month.isNotEmpty) {
      selectedFinanceMonth.value = month;
    }
    final resolvedMonth = monthLabel.isNotEmpty
        ? monthLabel
        : currentFinanceMonth();
    financeMonthLabel.value = resolvedMonth;

    try {
      isFinanceLoading.value = true;
      final response = await _api.get(
        Urls.financeBatchSummary(batch.id, resolvedMonth),
      );

      if (response is Map) {
        financeSummary.assignAll(Map<String, dynamic>.from(response));
        log(
          'Batch finance summary [$resolvedMonth]: ${financeSummary.toString()}',
        );
      } else {
        financeSummary.clear();
        log('Batch finance summary [$resolvedMonth]: $response');
      }
    } catch (e) {
      log('BatchStudentsController finance summary error: $e');
    } finally {
      isFinanceLoading.value = false;
    }
  }

  Future<void> refreshStudents() async {
    await Future.wait([fetchStudents(), fetchFinanceSummary()]);
  }

  Future<void> openCollectFeeSheet() async {
    if (selectedStudents.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'select_at_least_one_student'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    initializeFeeMonths();

    await Get.bottomSheet(
      BatchFeeCollectSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> openStudentProfile(BatchStudentModel student) async {
    await Get.bottomSheet(
      BatchStudentProfileSheet(
        student: student,
        formatDate: formatDate,
        batchName: selectedBatch.value?.batchName ?? '',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<bool> collectSelectedFees({
    required double amountPaid,
    required double originalAmount,
    required String paymentMethod,
    required String notes,
  }) async {
    final batch = selectedBatch.value;
    final selected = selectedStudents;
    if (batch == null || selected.isEmpty) {
      return false;
    }

    final months = selectedFeeMonths.isEmpty
        ? [
            selectedFinanceMonth.value.isNotEmpty
                ? selectedFinanceMonth.value
                : currentFinanceMonth(),
          ]
        : selectedFeeMonths.toList();

    final payload = BatchFeeCollectRequestModel(
      studentIds: selected.map((item) => item.id).toList(),
      batchId: batch.id,
      months: months,
      amountPaid: amountPaid,
      originalAmount: originalAmount,
      paymentMethod: paymentMethod,
      notes: notes,
    );

    log('Batch fee collect payload: ${jsonEncode(payload.toJson())}');

    try {
      isCollectingFee.value = true;
      final response = await _api.post(Urls.financeCollect, payload.toJson());
      if (response != null) {
        Get.back();
        Get.snackbar(
          'success'.tr,
          'fee_collection_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        clearSelectedStudents();
        clearFeeMonths();
        await refreshStudents();
        return true;
      }
      return false;
    } catch (e) {
      log('BatchStudentsController collect fee error: $e');
      Get.snackbar(
        'failed'.tr,
        'fee_collection_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isCollectingFee.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
