import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/service/network/endpoints/endpoints.dart';
import '../../../core/service/network/service/api_service.dart';
import '../model/home_dashboard_model.dart';

class HomeDashboardController extends GetxController {
  final _api = ApiService.instance;

  final isLoading = false.obs;
  final dashboard = Rxn<HomeDashboardModel>();
  final selectedMonth = ''.obs;
  final monthOptions = <String>[].obs;
  final recentLimit = 5.obs;
  final lowSeatThreshold = 3.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMonths();
    fetchDashboard();
  }

  void _initializeMonths() {
    final current = currentMonthLabel();
    final options = <String>[];

    for (int offset = -6; offset <= 6; offset++) {
      final date = DateTime(DateTime.now().year, DateTime.now().month + offset);
      options.add(DateFormat('MMMM yyyy', 'en_US').format(date));
    }

    monthOptions.assignAll(options.toSet().toList());
    selectedMonth.value = monthOptions.contains(current)
        ? current
        : (monthOptions.isNotEmpty ? monthOptions.first : current);
  }

  String currentMonthLabel() =>
      DateFormat('MMMM yyyy', 'en_US').format(DateTime.now());

  String get activeMonthLabel => selectedMonth.value.isNotEmpty
      ? selectedMonth.value
      : currentMonthLabel();

  Future<void> changeMonth(String month) async {
    if (month.trim().isEmpty || selectedMonth.value == month) {
      return;
    }
    selectedMonth.value = month;
    await fetchDashboard();
  }

  Future<void> refreshDashboard() => fetchDashboard();

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _api.get(
        Urls.teacherDashboard(
          month: activeMonthLabel,
          recentLimit: recentLimit.value,
          lowSeatThreshold: lowSeatThreshold.value,
        ),
      );

      if (response is Map) {
        dashboard.value = HomeDashboardModel.fromJson(
          Map<String, dynamic>.from(response),
        );
        log(
          'Teacher dashboard [$activeMonthLabel]: ${dashboard.value?.raw.toString()}',
        );
      } else if (response is List && response.isNotEmpty) {
        final first = response.first;
        if (first is Map) {
          dashboard.value = HomeDashboardModel.fromJson(
            Map<String, dynamic>.from(first),
          );
        } else {
          dashboard.value = null;
        }
      } else {
        dashboard.value = null;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      log('HomeDashboardController fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> get batchOverview =>
      dashboard.value?.batchOverview ?? const <String, dynamic>{};

  Map<String, dynamic> get studentOverview =>
      dashboard.value?.studentOverview ?? const <String, dynamic>{};

  Map<String, dynamic> get capacityOverview =>
      dashboard.value?.capacityOverview ?? const <String, dynamic>{};

  Map<String, dynamic> get financeOverview =>
      dashboard.value?.financeOverview ?? const <String, dynamic>{};

  List<Map<String, dynamic>> get batchSummaries =>
      dashboard.value?.batchSummaries ?? const <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get recentActivities =>
      dashboard.value?.recentActivities ?? const <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get alerts =>
      dashboard.value?.alerts ?? const <Map<String, dynamic>>[];

  int intValue(
    Map<String, dynamic> source,
    List<String> keys, {
    int fallback = 0,
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is num) return value.toInt();
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  double doubleValue(
    Map<String, dynamic> source,
    List<String> keys, {
    double fallback = 0,
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is num) return value.toDouble();
      final parsed = double.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  String textValue(
    Map<String, dynamic> source,
    List<String> keys, {
    String fallback = '-',
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  String formatNumber(dynamic value) {
    if (value == null) return '-';
    if (value is num) {
      return value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    }
    return value.toString();
  }

  String formatPercent(dynamic value) {
    final percent = double.tryParse(value?.toString() ?? '');
    if (percent == null) return '-';
    return '${percent.toStringAsFixed(percent % 1 == 0 ? 0 : 1)}%';
  }

  double paymentProgress(Map<String, dynamic> item) {
    final total = doubleValue(item, const [
      'total_students',
      'students',
      'batch_students',
      'enrolled_students',
    ]);
    final paid = doubleValue(item, const [
      'paid_students',
      'collected_students',
      'paid_count',
    ]);
    if (total <= 0) return 0;
    return (paid / total).clamp(0, 1);
  }

  String batchProgressLabel(Map<String, dynamic> item) {
    final paid = intValue(item, const ['paid_students', 'collected_students']);
    final total = intValue(item, const [
      'total_students',
      'students',
      'batch_students',
      'enrolled_students',
    ]);
    if (total <= 0) return '-';
    return '$paid/$total';
  }

  String scheduleLabel(dynamic value) {
    if (value is List) {
      final items = value
          .whereType<Map>()
          .map((item) {
            final map = Map<String, dynamic>.from(item);
            final day = textValue(map, const ['day'], fallback: '');
            final start = textValue(map, const ['start_time'], fallback: '');
            final end = textValue(map, const ['end_time'], fallback: '');
            return '$day ${start.isEmpty ? '' : start} - ${end.isEmpty ? '' : end}'
                .trim();
          })
          .where((entry) => entry.trim().isNotEmpty)
          .toList();
      return items.isEmpty ? '-' : items.join(' • ');
    }
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }
    return value.toString();
  }
}
