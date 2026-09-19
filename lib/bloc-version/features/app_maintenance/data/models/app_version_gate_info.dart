class AppVersionGateInfo {
  final String currentVersion;
  final String latestVersion;
  final String updateMessage;
  final String updateLink;
  final Map<String, String> updateLinks;
  final String appStatus;
  final String maintenanceMessage;
  final bool shouldShowMaintenance;
  final bool shouldUpdate;

  const AppVersionGateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.updateMessage,
    required this.updateLink,
    required this.updateLinks,
    required this.appStatus,
    required this.maintenanceMessage,
    required this.shouldShowMaintenance,
    required this.shouldUpdate,
  });

  Map<String, dynamic> toArguments() {
    return {
      'current_version': currentVersion,
      'latest_version': latestVersion,
      'update_message': updateMessage,
      'update_link': updateLink,
      'update_links': updateLinks,
      'app_status': appStatus,
      'maintenance_message': maintenanceMessage,
    };
  }

  factory AppVersionGateInfo.fromArguments(Map<String, dynamic>? args) {
    final map = args ?? <String, dynamic>{};
    final rawLinks = map['update_links'];
    final updateLinks = <String, String>{};
    if (rawLinks is Map) {
      rawLinks.forEach((key, value) {
        if (value != null) updateLinks[key.toString()] = value.toString();
      });
    }

    final appStatus = map['app_status']?.toString() ?? '';
    final isMaintenance = appStatus.trim().toLowerCase() == 'maintenance';

    return AppVersionGateInfo(
      currentVersion: map['current_version']?.toString() ?? '',
      latestVersion: map['latest_version']?.toString() ?? '',
      updateMessage: map['update_message']?.toString() ?? '',
      updateLink: map['update_link']?.toString() ?? '',
      updateLinks: updateLinks,
      appStatus: appStatus,
      maintenanceMessage: map['maintenance_message']?.toString() ?? '',
      shouldShowMaintenance: isMaintenance,
      shouldUpdate:
          !isMaintenance && (map['current_version'] != map['latest_version']),
    );
  }
}
