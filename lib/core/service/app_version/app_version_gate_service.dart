import 'dart:async';
import 'dart:developer';

import 'package:package_info_plus/package_info_plus.dart';

import '../network/endpoints/app_status_endpoints.dart';
import '../network/service/api_service.dart';

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
}

class AppVersionGateService {
  AppVersionGateService._();

  static final AppVersionGateService instance = AppVersionGateService._();

  final _api = ApiService.instance;

  Future<AppVersionGateInfo?> evaluate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final response = await _api
          .get(AppStatusUrls.getAll)
          .timeout(const Duration(seconds: 3));
      final latestStatus = _extractLatestStatus(response);
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

      if (!shouldShowMaintenance && !shouldUpdate) {
        return AppVersionGateInfo(
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          updateMessage: '',
          updateLink: preferredUpdateLink,
          updateLinks: updateLinks,
          appStatus: appStatus,
          maintenanceMessage: maintenanceMessage,
          shouldShowMaintenance: false,
          shouldUpdate: false,
        );
      }

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
      log('AppVersionGateService evaluate failed: $e');
      return null;
    }
  }

  Map<String, dynamic>? _extractLatestStatus(dynamic response) {
    if (response is Map) {
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
    final preferredKeys = ['android_aab', 'android_arm64', 'android_x64'];

    for (final key in preferredKeys) {
      final value = updateLinks[key]?.trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }

    for (final value in updateLinks.values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }

    return '';
  }

  DateTime _statusDate(Map<String, dynamic> item) {
    final raw =
        item['app_version_last_update']?.toString() ??
        item['updated_at']?.toString() ??
        item['created_at']?.toString() ??
        '';
    return DateTime.tryParse(raw) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _normalizeVersion(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'\.+'), '.')
        .replaceAll(RegExp(r'^\.|\.$'), '');
  }
}
