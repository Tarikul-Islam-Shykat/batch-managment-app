import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';
import '../datasources/app_status_gate_remote_data_source.dart';
import '../models/app_version_gate_info.dart';

class AppStatusGateRepository {
  final AppStatusGateRemoteDataSource _remoteDataSource;

  AppStatusGateRepository({
    required AppStatusGateRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  Future<AppVersionGateInfo?> evaluateVersionGate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Try admin app status first, or fall back to public
      var response = await _remoteDataSource.getAppStatus();
      if (!response.isSuccess || response.data == null) {
        response = await _remoteDataSource.getPublicAppStatus();
      }

      if (!response.isSuccess || response.data == null) {
        return null;
      }

      final latestStatus = _extractLatestStatus(response.data);
      if (latestStatus == null) {
        return null;
      }

      final latestVersion = latestStatus['app_version']?.toString() ?? '';
      if (latestVersion.isEmpty) {
        return null;
      }

      final normalizedCurrent = _normalizeVersion(currentVersion);
      final normalizedLatest = _normalizeVersion(latestVersion);
      final appStatus = latestStatus['app_status']?.toString() ?? '';
      final maintenanceMessage =
          latestStatus['app_maintenance_message']?.toString() ?? '';
      final updateLinks = _extractUpdateLinks(latestStatus);
      final preferredUpdateLink = _preferredUpdateLink(updateLinks);
      final shouldShowMaintenance =
          appStatus.trim().toLowerCase() == 'maintenance';
      final shouldUpdate =
          !shouldShowMaintenance && normalizedCurrent != normalizedLatest;

      return AppVersionGateInfo(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        updateMessage: maintenanceMessage,
        updateLink: preferredUpdateLink,
        updateLinks: updateLinks,
        appStatus: appStatus,
        maintenanceMessage: maintenanceMessage,
        shouldShowMaintenance: shouldShowMaintenance,
        shouldUpdate: shouldUpdate,
      );
    } catch (e) {
      log('AppStatusGateRepository evaluate failed: $e');
      return null;
    }
  }

  Map<String, dynamic>? _extractLatestStatus(dynamic response) {
    if (response is Map) {
      if (response['data'] is List) {
        return _extractLatestStatus(response['data']);
      }
      return Map<String, dynamic>.from(response);
    }

    if (response is List) {
      final items = response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      if (items.isEmpty) {
        return null;
      }

      items.sort((left, right) {
        final leftDate = _statusDate(left);
        final rightDate = _statusDate(right);
        return rightDate.compareTo(leftDate);
      });
      return items.first;
    }

    return null;
  }

  DateTime _statusDate(Map<String, dynamic> item) {
    final raw = (item['updated_at'] ?? item['created_at'])?.toString() ?? '';
    if (raw.trim().isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.tryParse(raw) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  Map<String, String> _extractUpdateLinks(Map<String, dynamic> latestStatus) {
    final raw = latestStatus['app_update_links'];
    if (raw is Map) {
      return raw.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }

    final fallback = latestStatus['app_update_link']?.toString() ?? '';
    if (fallback.isEmpty) {
      return <String, String>{};
    }

    return {'android_aab': fallback};
  }

  String _preferredUpdateLink(Map<String, String> updateLinks) {
    for (final key in const ['android_aab', 'android_arm64', 'android_x64']) {
      final value = updateLinks[key]?.trim() ?? '';
      if (value.isNotEmpty) return value;
    }

    for (final value in updateLinks.values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }

    return '';
  }

  String _normalizeVersion(String version) {
    return version
        .trim()
        .toLowerCase()
        .replaceFirst(RegExp(r'^v'), '')
        .split('+')
        .first
        .trim();
  }
}
