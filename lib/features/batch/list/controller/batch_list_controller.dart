import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/service/network/endpoints/endpoints.dart';
import '../../../../core/service/network/service/api_service.dart';
import '../model/batch_list_response_model.dart';

class BatchListController extends GetxController {
  final _api = ApiService.instance;

  final scrollController = ScrollController();
  final batches = <BatchListItemModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final selectedStatus = 'current'.obs;

  final int limit = 10;
  int _page = 1;
  int _totalPages = 1;

  final statusOptions = const ['current', 'upcoming', 'ended'];

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchBatches();
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        isLoading.value ||
        isLoadingMore.value) {
      return;
    }

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      loadMore();
    }
  }

  Future<void> setStatus(String status) async {
    if (selectedStatus.value == status) {
      return;
    }

    selectedStatus.value = status;
    await refreshBatches();
  }

  Future<void> refreshBatches() async {
    _page = 1;
    _totalPages = 1;
    batches.clear();
    await fetchBatches();
  }

  Future<void> fetchBatches() async {
    if (_page > _totalPages) {
      return;
    }

    if (_page == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _api.get(
        '${Urls.batches}?batch_status=${selectedStatus.value}&page=$_page&limit=$limit',
      );

      if (response is Map) {
        final parsed = BatchListResponseModel.fromJson(
          Map<String, dynamic>.from(response),
        );
        _totalPages = parsed.totalPages;
        if (_page == 1) {
          batches.assignAll(parsed.items);
        } else {
          batches.addAll(parsed.items);
        }
      }
    } catch (e) {
      log('BatchListController fetch error: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value) {
      return;
    }

    if (_page >= _totalPages) {
      return;
    }

    _page += 1;
    await fetchBatches();
  }

  String dayLabel(String day) {
    switch (day) {
      case 'Saturday':
        return 'day_saturday'.tr;
      case 'Sunday':
        return 'day_sunday'.tr;
      case 'Monday':
        return 'day_monday'.tr;
      case 'Tuesday':
        return 'day_tuesday'.tr;
      case 'Wednesday':
        return 'day_wednesday'.tr;
      case 'Thursday':
        return 'day_thursday'.tr;
      case 'Friday':
        return 'day_friday'.tr;
      default:
        return day;
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case 'current':
        return 'current_batches'.tr;
      case 'upcoming':
        return 'upcoming_batches'.tr;
      case 'ended':
        return 'ended_batches'.tr;
      default:
        return status;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
