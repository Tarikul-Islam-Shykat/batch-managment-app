import 'package:equatable/equatable.dart';
import '../../data/models/app_status_model.dart';

class SuperAdminState extends Equatable {
  final int currentTabIndex;
  final bool isLoading;
  final bool isSaving;
  final List<AppStatusModel> appStatuses;
  final AppStatusModel? selectedStatus;
  final String selectedStatusType;
  final String? errorMessage;
  final String? successMessage;

  const SuperAdminState({
    this.currentTabIndex = 0,
    this.isLoading = false,
    this.isSaving = false,
    this.appStatuses = const [],
    this.selectedStatus,
    this.selectedStatusType = 'active',
    this.errorMessage,
    this.successMessage,
  });

  factory SuperAdminState.initial() {
    return const SuperAdminState();
  }

  SuperAdminState copyWith({
    int? currentTabIndex,
    bool? isLoading,
    bool? isSaving,
    List<AppStatusModel>? appStatuses,
    AppStatusModel? selectedStatus,
    bool clearSelectedStatus = false,
    String? selectedStatusType,
    String? errorMessage,
    String? successMessage,
  }) {
    return SuperAdminState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      appStatuses: appStatuses ?? this.appStatuses,
      selectedStatus: clearSelectedStatus
          ? null
          : (selectedStatus ?? this.selectedStatus),
      selectedStatusType: selectedStatusType ?? this.selectedStatusType,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentTabIndex,
        isLoading,
        isSaving,
        appStatuses,
        selectedStatus,
        selectedStatusType,
        errorMessage,
        successMessage,
      ];
}
