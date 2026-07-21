import 'package:batch_management_app_direct/core/service/network/endpoints/endpoints.dart';
import 'package:batch_management_app_direct/core/service/network/service/api_service.dart';
import 'package:batch_management_app_direct/core/service/app_version/app_version_gate_service.dart';
import 'package:batch_management_app_direct/core/service/storage/secure/storage.dart';
import 'package:batch_management_app_direct/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final _api = ApiService.instance;
  final _storage = SecureStorageService();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'login_missing_fields'.tr,
        'please_enter_email_password'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _api.post(Urls.login, {
        'email': email,
        'password': password,
      });

      final accessToken = response is Map
          ? response['access_token'] as String?
          : null;
      final role = response is Map
          ? response['role']?.toString() ?? 'teacher'
          : 'teacher';
      if (accessToken == null || accessToken.isEmpty) {
        Get.snackbar(
          'login_failed'.tr,
          'token_not_returned'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (role == 'super_admin') {
        await _storage.set(SecureStorageService.token, accessToken);
        await _storage.set(SecureStorageService.role, role);
        Get.snackbar(
          'success'.tr,
          'login_successful'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoute.superAdminScreen);
        return;
      }

      final updateGate = await AppVersionGateService.instance.evaluate();
      if (updateGate != null) {
        if (updateGate.shouldShowMaintenance) {
          Get.offAllNamed(
            AppRoute.appMaintenanceScreen,
            arguments: updateGate.toArguments(),
          );
          return;
        }

        if (updateGate.shouldUpdate) {
          Get.offAllNamed(
            AppRoute.appUpdateScreen,
            arguments: updateGate.toArguments(),
          );
          return;
        }
      }

      await _storage.set(SecureStorageService.token, accessToken);
      await _storage.set(SecureStorageService.role, role);
      Get.snackbar(
        'success'.tr,
        'login_successful'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(AppRoute.navBarScreen);
    } catch (e) {
      Get.snackbar(
        'login_failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
