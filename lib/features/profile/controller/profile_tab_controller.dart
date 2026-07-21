import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/service/network/endpoints/endpoints.dart';
import '../../../core/service/network/service/api_service.dart';
import '../../../core/service/storage/secure/storage.dart';

class ProfileTabController extends GetxController {
  final _api = ApiService.instance;
  final _storage = SecureStorageService();

  final isLoading = false.obs;
  final isLoggingOut = false.obs;
  final profileData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _api.get(Urls.profileMe);
      if (response is Map) {
        profileData.assignAll(Map<String, dynamic>.from(response));
      } else {
        profileData.clear();
      }
    } catch (e) {
      log('ProfileTabController fetchProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _firstNonEmpty(List<String> keys, {String fallback = '-'}) {
    for (final key in keys) {
      final value = profileData[key];
      if (value != null) {
        final text = value.toString().trim();
        if (text.isNotEmpty && text != 'null') {
          return text;
        }
      }
    }
    return fallback;
  }

  String get displayName =>
      _firstNonEmpty(['full_name', 'name', 'username', 'first_name', 'email']);

  String get displayRole =>
      _firstNonEmpty(['role', 'designation', 'user_type', 'account_type']);

  bool get isSuperAdmin => displayRole.trim().toLowerCase() == 'super_admin';

  String get displayEmail => _firstNonEmpty(['email', 'mail']);

  String get displayPhone =>
      _firstNonEmpty(['phone', 'mobile', 'phone_number']);

  String _humanizeKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _stringifyValue(dynamic value) {
    if (value == null) {
      return '-';
    }
    if (value is String || value is num || value is bool) {
      final text = value.toString().trim();
      return text.isEmpty ? '-' : text;
    }
    return const JsonEncoder.withIndent('  ').convert(value);
  }

  List<MapEntry<String, String>> get profileFields {
    const ignoredKeys = {'access_token', 'token_type', 'expires_in'};

    return profileData.entries
        .where((entry) => !ignoredKeys.contains(entry.key))
        .map(
          (entry) =>
              MapEntry(_humanizeKey(entry.key), _stringifyValue(entry.value)),
        )
        .toList();
  }

  Future<void> logout() async {
    try {
      isLoggingOut.value = true;
      await _storage.clearAll();
      Get.offAllNamed(AppRoute.loginScreen);
    } catch (e) {
      log('ProfileTabController logout error: $e');
    } finally {
      isLoggingOut.value = false;
    }
  }
}
