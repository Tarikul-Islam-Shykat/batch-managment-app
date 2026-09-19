import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';

import '../../../core/global/app_snackbar.dart';
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
      AppSnackbar.show(
        message: 'please_fill_registration_fields'.tr,
        isSuccess: false,
      );
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.show(message: 'password_mismatch'.tr, isSuccess: false);
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
        AppSnackbar.show(message: 'otp_sent_to_email'.tr, isSuccess: true);
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
      AppSnackbar.show(message: e.toString(), isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }
}
