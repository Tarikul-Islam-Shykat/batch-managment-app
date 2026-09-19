import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import 'package:equatable/equatable.dart';

class BatchListState extends Equatable {
  final String selectedStatus;
  final List<BatchListItemModel> batches;
  final bool isLoading;
  final bool isLoadingMore;
  final int page;
  final int totalPages;
  final String? errorMessage;

  const BatchListState({
    this.selectedStatus = 'current',
    this.batches = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  BatchListState copyWith({
    String? selectedStatus,
    List<BatchListItemModel>? batches,
    bool? isLoading,
    bool? isLoadingMore,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return BatchListState(
      selectedStatus: selectedStatus ?? this.selectedStatus,
      batches: batches ?? this.batches,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedStatus,
    batches,
    isLoading,
    isLoadingMore,
    page,
    totalPages,
    errorMessage,
  ];
}
