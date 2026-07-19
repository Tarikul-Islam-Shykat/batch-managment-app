import 'package:batch_management_app_direct/core/service/network/endpoints/endpoints.dart';
import 'package:batch_management_app_direct/core/service/network/service/api_service.dart';
import 'package:batch_management_app_direct/core/service/storage/secure/storage.dart';
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
        'Missing fields',
        'Please enter email and password.',
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
      if (accessToken == null || accessToken.isEmpty) {
        Get.snackbar(
          'Login failed',
          'Token was not returned by the server.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _storage.set(SecureStorageService.token, accessToken);
      Get.snackbar(
        'Success',
        'Login successful.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Login failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
