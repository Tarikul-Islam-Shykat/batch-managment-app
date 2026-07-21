import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/service/network/endpoints/app_status_endpoints.dart';
import '../../../core/service/network/service/api_service.dart';
import '../model/app_status_model.dart';

class AppStatusController extends GetxController {
  final _api = ApiService.instance;

  final isLoading = false.obs;
  final isSaving = false.obs;
  final appStatuses = <AppStatusModel>[].obs;
  final selectedAppStatusId = RxnString();

  final appVersionController = TextEditingController();
  final appMaintenanceMessageController = TextEditingController();
  final appUpdateLinkController = TextEditingController();
  final appVersionLastUpdateController = TextEditingController();
  final appUpdatedFixesController = TextEditingController();

  final selectedStatus = 'active'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
  }

  AppStatusModel? get selectedStatusModel {
    if (selectedAppStatusId.value == null) {
      return appStatuses.isNotEmpty ? appStatuses.first : null;
    }
    for (final item in appStatuses) {
      if (item.id == selectedAppStatusId.value) {
        return item;
      }
    }
    return null;
  }

  Future<void> fetchStatuses() async {
    try {
      isLoading.value = true;
      final response = await _api.get(AppStatusUrls.getAll);
      if (response is List) {
        appStatuses.assignAll(
          response
              .whereType<Map>()
              .map(
                (item) =>
                    AppStatusModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(),
        );
      } else {
        appStatuses.clear();
      }

      if (appStatuses.isNotEmpty) {
        selectStatus(appStatuses.first);
      } else {
        clearForm();
      }
    } catch (e) {
      log('AppStatusController fetchStatuses error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectStatus(AppStatusModel status) {
    selectedAppStatusId.value = status.id;
    appVersionController.text = status.appVersion;
    appMaintenanceMessageController.text = status.appMaintenanceMessage ?? '';
    appUpdateLinkController.text = status.appUpdateLink ?? '';
    appVersionLastUpdateController.text = status.appVersionLastUpdate ?? '';
    appUpdatedFixesController.text = status.appUpdatedFixes.join('\n');
    selectedStatus.value = status.appStatus.isNotEmpty
        ? status.appStatus
        : 'active';
  }

  void clearForm() {
    selectedAppStatusId.value = null;
    appVersionController.clear();
    appMaintenanceMessageController.clear();
    appUpdateLinkController.clear();
    appVersionLastUpdateController.clear();
    appUpdatedFixesController.clear();
    selectedStatus.value = 'active';
  }

  List<String> _parseFixes() {
    return appUpdatedFixesController.text
        .split(RegExp(r'[\n,]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Future<void> saveStatus() async {
    final payload = AppStatusModel(
      id: selectedAppStatusId.value ?? '',
      appVersion: appVersionController.text.trim(),
      appStatus: selectedStatus.value,
      appMaintenanceMessage: appMaintenanceMessageController.text.trim().isEmpty
          ? null
          : appMaintenanceMessageController.text.trim(),
      appUpdateLink: appUpdateLinkController.text.trim().isEmpty
          ? null
          : appUpdateLinkController.text.trim(),
      appVersionLastUpdate: appVersionLastUpdateController.text.trim().isEmpty
          ? null
          : appVersionLastUpdateController.text.trim(),
      appUpdatedFixes: _parseFixes(),
    );

    if (payload.appVersion.isEmpty) {
      Get.snackbar(
        'invalid_input'.tr,
        'app_version_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSaving.value = true;
      final isEditing =
          selectedAppStatusId.value != null &&
          selectedAppStatusId.value!.isNotEmpty;
      final response = isEditing
          ? await _api.patch(
              AppStatusUrls.update(selectedAppStatusId.value!),
              payload.toUpdateJson(),
            )
          : await _api.post(AppStatusUrls.create, payload.toCreateJson());

      if (response != null) {
        Get.snackbar(
          'success'.tr,
          isEditing ? 'app_status_updated'.tr : 'app_status_created'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchStatuses();
      }
    } catch (e) {
      Get.snackbar(
        'failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    appVersionController.dispose();
    appMaintenanceMessageController.dispose();
    appUpdateLinkController.dispose();
    appVersionLastUpdateController.dispose();
    appUpdatedFixesController.dispose();
    super.onClose();
  }
}
