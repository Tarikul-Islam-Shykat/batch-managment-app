import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/storage/secure/storage.dart';

class LanguageController extends GetxController {
  final SecureStorageService _storage = SecureStorageService();
  final currentLocale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedCode = await _storage.get(SecureStorageService.languageCode);
    if (savedCode == 'bn') {
      await _applyLocale(const Locale('bn', 'BD'), persist: false);
      return;
    }

    if (savedCode == 'en') {
      await _applyLocale(const Locale('en', 'US'), persist: false);
    }
  }

  Future<void> toggleLanguage() async {
    final nextLocale = currentLocale.value.languageCode == 'bn'
        ? const Locale('en', 'US')
        : const Locale('bn', 'BD');
    await _applyLocale(nextLocale);
  }

  Future<void> setLanguage(Locale locale) async {
    await _applyLocale(locale);
  }

  bool get isBangla => currentLocale.value.languageCode == 'bn';

  Future<void> _applyLocale(Locale locale, {bool persist = true}) async {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    if (persist) {
      await _storage.set(
        SecureStorageService.languageCode,
        locale.languageCode,
      );
    }
  }
}
