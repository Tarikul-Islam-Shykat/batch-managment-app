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
}
