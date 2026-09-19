class HomeDashboardModel {
  final Map<String, dynamic> batchOverview;
  final Map<String, dynamic> studentOverview;
  final Map<String, dynamic> capacityOverview;
  final Map<String, dynamic> financeOverview;
  final List<Map<String, dynamic>> batchSummaries;
  final List<Map<String, dynamic>> recentActivities;
  final List<Map<String, dynamic>> alerts;
  final Map<String, dynamic> raw;

  const HomeDashboardModel({
    required this.batchOverview,
    required this.studentOverview,
    required this.capacityOverview,
    required this.financeOverview,
    required this.batchSummaries,
    required this.recentActivities,
    required this.alerts,
    required this.raw,
  });

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    return HomeDashboardModel(
      batchOverview: _asMap(json['batch_overview']),
      studentOverview: _asMap(json['student_overview']),
      capacityOverview: _asMap(json['capacity_overview']),
      financeOverview: _asMap(json['finance_overview']),
      batchSummaries: _asMapList(json['batch_summaries']),
      recentActivities: _asMapList(json['recent_activities']),
      alerts: _asMapList(json['alerts']),
      raw: json,
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  // Helper Methods for parsing values from dynamic maps
  static int intValue(
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

  static double doubleValue(
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

  static String textValue(
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

  static String formatNumber(dynamic value) {
    if (value == null) return '-';
    if (value is num) {
      return value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    }
    return value.toString();
  }

  static String formatPercent(dynamic value) {
    final percent = double.tryParse(value?.toString() ?? '');
    if (percent == null) return '-';
    return '${percent.toStringAsFixed(percent % 1 == 0 ? 0 : 1)}%';
  }

  static double paymentProgress(Map<String, dynamic> item) {
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

  static String batchProgressLabel(Map<String, dynamic> item) {
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
}
