class AppStatusModel {
  final String id;
  final String appVersion;
  final String appStatus;
  final String? appMaintenanceMessage;
  final Map<String, String> appUpdateLinks;
  final String? appVersionLastUpdate;
  final List<String> appUpdatedFixes;

  const AppStatusModel({
    required this.id,
    required this.appVersion,
    required this.appStatus,
    required this.appUpdateLinks,
    required this.appUpdatedFixes,
    this.appMaintenanceMessage,
    this.appVersionLastUpdate,
  });

  factory AppStatusModel.fromJson(Map<String, dynamic> json) {
    final fixes = json['app_updated_fixes'];
    final links = json['app_update_links'];
    return AppStatusModel(
      id: json['id']?.toString() ?? '',
      appVersion: json['app_version']?.toString() ?? '',
      appStatus: json['app_status']?.toString() ?? '',
      appMaintenanceMessage: json['app_maintenance_message']?.toString(),
      appUpdateLinks: links is Map
          ? links.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : <String, String>{},
      appVersionLastUpdate: json['app_version_last_update']?.toString(),
      appUpdatedFixes: fixes is List
          ? fixes.map((item) => item.toString()).toList()
          : <String>[],
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'app_version': appVersion,
      'app_status': appStatus,
      'app_maintenance_message': appMaintenanceMessage,
      'app_update_links': appUpdateLinks,
      'app_version_last_update': appVersionLastUpdate,
      'app_updated_fixes': appUpdatedFixes,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'app_status': appStatus,
      'app_maintenance_message': appMaintenanceMessage,
      'app_update_links': appUpdateLinks,
      'app_updated_fixes': appUpdatedFixes,
    };
  }
}
