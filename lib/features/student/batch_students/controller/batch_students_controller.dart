import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../model/batch_student_model.dart';

class BatchStudentsController extends GetxController {
  final _api = ApiService.instance;

  final isLoading = false.obs;
  final students = <BatchStudentModel>[].obs;
  final selectedBatch = Rxn<BatchListItemModel>();
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is BatchListItemModel) {
      selectedBatch.value = args;
      fetchStudents();
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

  Future<void> refreshStudents() => fetchStudents();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
