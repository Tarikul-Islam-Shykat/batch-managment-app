import 'package:batch_management_app_direct/core/global/app_snackbar.dart';
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
  final isEmailValid = false.obs;

  final _api = ApiService.instance;
  final _storage = SecureStorageService();

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);
    _validateEmail();
  }

  void _validateEmail() {
    final email = emailController.text.trim();
    final validEmail =
        email.isNotEmpty &&
        (GetUtils.isEmail(email) || _emailRegex.hasMatch(email));
    if (isEmailValid.value != validEmail) {
      isEmailValid.value = validEmail;
    }
  }

  @override
  void onClose() {
    emailController.removeListener(_validateEmail);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) {
      AppSnackbar.show(
        message: 'please_enter_email_password'.tr,
        isSuccess: false,
      );
      return;
    }

    if (email.isEmpty) {
      AppSnackbar.show(message: 'please_enter_email'.tr, isSuccess: false);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.show(
        message: 'please_enter_valid_email'.tr,
        isSuccess: false,
      );
      return;
    }

    if (password.isEmpty) {
      AppSnackbar.show(message: 'please_enter_password'.tr, isSuccess: false);
      return;
    }

    if (isLoading.value) return;

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
        AppSnackbar.show(message: 'token_not_returned'.tr, isSuccess: false);
        return;
      }

      if (role == 'super_admin') {
        await _storage.set(SecureStorageService.token, accessToken);
        await _storage.set(SecureStorageService.role, role);
        AppSnackbar.show(message: 'login_successful'.tr, isSuccess: true);
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
      AppSnackbar.show(message: 'login_successful'.tr, isSuccess: true);
      Get.offAllNamed(AppRoute.navBarScreen);
    } catch (e) {
      AppSnackbar.show(message: e.toString(), isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }
}
