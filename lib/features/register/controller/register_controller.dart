import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/service/network/endpoints/endpoints.dart';
import '../../../core/service/network/service/api_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final _api = ApiService.instance;

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'registration_missing_fields'.tr,
        'please_fill_registration_fields'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'invalid_input'.tr,
        'password_mismatch'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _api.post(Urls.signup, {
        'name': name,
        'email': email,
        'password': password,
      });
      log('Signup response: $response');

      if (response != null) {
        final responseMap = response is Map
            ? Map<String, dynamic>.from(response)
            : <String, dynamic>{};
        final otp = responseMap['otp']?.toString();
        Get.snackbar(
          'success'.tr,
          'otp_sent_to_email'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(
          AppRoute.otpVerificationScreen,
          arguments: {
            'email': email,
            'name': name,
            'role': responseMap['role']?.toString() ?? 'teacher',
            'user_block': responseMap['user_block'] == true,
            'email_verified': responseMap['email_verified'] == true,
            'verification_sent': responseMap['verification_sent'] == true,
            if (otp != null && otp.isNotEmpty) 'otp': otp,
            'signup_response': responseMap,
          },
        );
      }
    } catch (e) {
      Get.snackbar(
        'registration_failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
