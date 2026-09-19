import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/app_status_model.dart';
import '../../data/repositories/super_admin_repository.dart';
import 'super_admin_state.dart';

class SuperAdminCubit extends Cubit<SuperAdminState> {
  final SuperAdminRepository _repository;

  SuperAdminCubit(this._repository) : super(SuperAdminState.initial());

  void switchTab(int index) {
    emit(state.copyWith(currentTabIndex: index));
    if (index == 1 && state.appStatuses.isEmpty) {
      fetchStatuses();
    }
  }

  void setStatusType(String type) {
    emit(state.copyWith(selectedStatusType: type));
  }

  void selectStatus(AppStatusModel status) {
    emit(
      state.copyWith(
        selectedStatus: status,
        selectedStatusType: status.appStatus,
      ),
    );
  }

  void clearForm() {
    emit(
      state.copyWith(clearSelectedStatus: true, selectedStatusType: 'active'),
    );
  }

  Future<void> fetchStatuses() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getAppStatuses();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (statuses) {
        emit(
          state.copyWith(
            isLoading: false,
            appStatuses: statuses,
            selectedStatus: statuses.isNotEmpty ? statuses.first : null,
            selectedStatusType: statuses.isNotEmpty
                ? statuses.first.appStatus
                : 'active',
          ),
        );
      },
    );
  }

  Future<void> saveStatus({
    required String appVersion,
    required String maintenanceMessage,
    required String arm64Link,
    required String x64Link,
    required String aabLink,
    required String lastUpdate,
    required String fixesText,
  }) async {
    if (appVersion.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter app version.'));
      return;
    }

    final fixes = fixesText
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final updateLinks = <String, String>{};
    if (arm64Link.trim().isNotEmpty) {
      updateLinks['android_arm64'] = arm64Link.trim();
    }
    if (x64Link.trim().isNotEmpty) {
      updateLinks['android_x64'] = x64Link.trim();
    }
    if (aabLink.trim().isNotEmpty) {
      updateLinks['android_aab'] = aabLink.trim();
    }

    final model = AppStatusModel(
      id: state.selectedStatus?.id ?? '',
      appVersion: appVersion.trim(),
      appStatus: state.selectedStatusType,
      appMaintenanceMessage: maintenanceMessage.trim().isNotEmpty
          ? maintenanceMessage.trim()
          : null,
      appUpdateLinks: updateLinks,
      appVersionLastUpdate: lastUpdate.trim().isNotEmpty
          ? lastUpdate.trim()
          : null,
      appUpdatedFixes: fixes,
    );

    emit(state.copyWith(isSaving: true, errorMessage: null));

    final isUpdating = state.selectedStatus != null;
    final result = isUpdating
        ? await _repository.updateAppStatus(state.selectedStatus!.id, model)
        : await _repository.createAppStatus(model);

    result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
      },
      (_) {
        emit(
          state.copyWith(
            isSaving: false,
            successMessage: isUpdating
                ? 'App status updated successfully!'
                : 'App status created successfully!',
          ),
        );
        fetchStatuses();
      },
    );
  }
}
