import 'dart:developer';

import 'package:get/get.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../../../batch/list/model/batch_list_response_model.dart';
import '../model/batch_student_model.dart';

class BatchStudentsController extends GetxController {
  final _api = ApiService.instance;

  final isLoading = false.obs;
  final students = <BatchStudentModel>[].obs;
  final selectedBatch = Rxn<BatchListItemModel>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is BatchListItemModel) {
      selectedBatch.value = args;
      fetchStudents();
    }
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
}
