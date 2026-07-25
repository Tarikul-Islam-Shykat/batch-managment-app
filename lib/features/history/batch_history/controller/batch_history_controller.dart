import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../model/batch_history_entry_model.dart';

class BatchHistoryController extends GetxController {
  final _api = ApiService.instance;

  final isLoading = false.obs;
  final entries = <BatchHistoryEntryModel>[].obs;
  final batchId = ''.obs;
  final batchName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      batchId.value = args['batch_id']?.toString() ?? '';
      batchName.value = args['batch_name']?.toString() ?? '';
    }

    if (batchId.value.isNotEmpty) {
      fetchHistory();
    }
  }

  Future<void> fetchHistory() async {
    if (batchId.value.isEmpty) {
      entries.clear();
      return;
    }

    try {
      isLoading.value = true;
      final response = await _api.get(Urls.batchHistory(batchId.value));
      log(
        'Batch history raw response: ${const JsonEncoder.withIndent('  ').convert(response)}',
      );

      final items = _extractItems(response);
      entries.assignAll(items);
      log('Batch history parsed count: ${items.length}');
    } catch (e) {
      log('BatchHistoryController fetchHistory error: $e');
      entries.clear();
      Get.snackbar(
        'failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<BatchHistoryEntryModel> _extractItems(dynamic response) {
    final rawItems = <Map<String, dynamic>>[];

    if (response is List) {
      rawItems.addAll(
        response
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } else if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final candidates = [
        map['items'],
        map['entries'],
        map['data'],
        map['history'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) {
          rawItems.addAll(
            candidate
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList(),
          );
          break;
        }
      }

      if (rawItems.isEmpty) {
        rawItems.add(map);
      }
    }

    rawItems.sort((left, right) {
      final leftDate = _parseDate(left['created_at']?.toString() ?? '');
      final rightDate = _parseDate(right['created_at']?.toString() ?? '');
      return rightDate.compareTo(leftDate);
    });

    return rawItems.map(BatchHistoryEntryModel.fromJson).toList();
  }

  DateTime _parseDate(String value) {
    if (value.trim().isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }

    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(value);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  String formatTime(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return DateFormat('d MMM, yyyy • h:mm a').format(parsed);
  }

  Future<void> refreshHistory() async {
    await fetchHistory();
  }
}
