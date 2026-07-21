import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/service/network/endpoints/endpoints.dart';
import '../../../core/service/network/service/api_service.dart';
import '../../../core/service/storage/secure/storage.dart';

class OtpVerificationController extends GetxController {
  final otpController = TextEditingController();
  final isLoading = false.obs;
  final _api = ApiService.instance;
  final _storage = SecureStorageService();

  late final String email;
  late final String name;
  late final String role;
  late final bool userBlock;
  late final bool emailVerified;
  late final bool verificationSent;
  late final String initialOtp;
  late final Map<String, dynamic> signupResponse;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    email = args is Map && args['email'] != null
        ? args['email'].toString()
        : '';
    name = args is Map && args['name'] != null ? args['name'].toString() : '';
    role = args is Map && args['role'] != null ? args['role'].toString() : '';
    userBlock = args is Map && args['user_block'] == true;
    emailVerified = args is Map && args['email_verified'] == true;
    verificationSent = args is Map && args['verification_sent'] == true;
    signupResponse = args is Map && args['signup_response'] is Map
        ? Map<String, dynamic>.from(args['signup_response'] as Map)
        : <String, dynamic>{};
    initialOtp = args is Map && args['otp'] != null
        ? args['otp'].toString()
        : (signupResponse['otp']?.toString() ?? '');
    if (initialOtp.isNotEmpty) {
      otpController.text = initialOtp;
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (email.isEmpty || otp.length != 6) {
      Get.snackbar(
        'invalid_input'.tr,
        'enter_valid_otp'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _api.post(Urls.verifyOtp, {
        'email': email,
        'otp': otp,
      });
      log('Verify OTP response: $response');

      if (response is Map) {
        final accessToken = response['access_token']?.toString();
        final responseRole = response['role']?.toString() ?? '';
        final resolvedRole = responseRole.isNotEmpty
            ? responseRole
            : (role.isNotEmpty ? role : 'teacher');
        if (accessToken != null && accessToken.isNotEmpty) {
          await _storage.set(SecureStorageService.token, accessToken);
          await _storage.set(SecureStorageService.role, resolvedRole);
          Get.offAllNamed(
            resolvedRole == 'super_admin'
                ? AppRoute.superAdminScreen
                : AppRoute.navBarScreen,
          );
          Get.snackbar(
            'success'.tr,
            'otp_verified_successfully'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      Get.snackbar(
        'success'.tr,
        'otp_verified_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(
        role == 'super_admin'
            ? AppRoute.superAdminScreen
            : AppRoute.loginScreen,
      );
    } catch (e) {
      Get.snackbar(
        'verification_failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (email.isEmpty) {
      return;
    }

    try {
      isLoading.value = true;
      final response = await _api.post(Urls.requestOtp, {'email': email});
      log('Resend OTP response: $response');

      Get.snackbar(
        'success'.tr,
        'otp_sent_to_email'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> backToLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    otpController.clear();
    await Future<void>.delayed(Duration.zero);
    Get.offAllNamed(AppRoute.loginScreen);
  }
}
