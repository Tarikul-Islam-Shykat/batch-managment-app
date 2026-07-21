import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/service/network/endpoints/endpoints.dart';
import '../../../core/service/network/service/api_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/controller/language_controller.dart';
import '../../../core/service/storage/secure/storage.dart';

class SplashController extends GetxController {
  static const String logoHeroTag = 'splash-logo-hero';
  Timer? _timer;
  final _api = ApiService.instance;
  final _storage = SecureStorageService();
  final _languageController = Get.find<LanguageController>();
  final isCheckingSession = false.obs;

  @override
  void onInit() {
    super.onInit();
    log('SplashController initialized');
    _initialize();
  }

  Future<void> _initialize() async {
    final savedLanguage = await _storage.get(SecureStorageService.languageCode);
    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      await _applySavedLanguage(savedLanguage);
    }

    _timer = Timer(const Duration(seconds: 2), _checkSession);
  }

  Future<void> _applySavedLanguage(String languageCode) async {
    if (languageCode == 'bn') {
      await _languageController.setLanguage(const Locale('bn', 'BD'));
      return;
    }

    await _languageController.setLanguage(const Locale('en', 'US'));
  }

  Future<void> _checkSession() async {
    if (isCheckingSession.value) {
      return;
    }

    isCheckingSession.value = true;
    try {
      final token = await _storage.get(SecureStorageService.token);
      if (token == null || token.isEmpty) {
        log('SplashController no token found, navigating to login');
        Get.offAllNamed(AppRoute.loginScreen);
        return;
      }

      final response = await _api.get(Urls.profileMe);
      if (response is Map) {
        final role =
            response['role']?.toString() ??
            await _storage.get(SecureStorageService.role) ??
            '';
        if (role.isNotEmpty) {
          await _storage.set(SecureStorageService.role, role);
        }
        log('SplashController token valid, entering app as $role');
        Get.offAllNamed(
          role == 'super_admin'
              ? AppRoute.superAdminScreen
              : AppRoute.navBarScreen,
        );
        return;
      }

      await _storage.delete(SecureStorageService.token);
      await _storage.delete(SecureStorageService.role);
      log('SplashController token invalid, navigating to login');
      Get.offAllNamed(AppRoute.loginScreen);
    } catch (e) {
      await _storage.delete(SecureStorageService.token);
      await _storage.delete(SecureStorageService.role);
      log('SplashController session check failed: $e');
      Get.offAllNamed(AppRoute.loginScreen);
    } finally {
      isCheckingSession.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
