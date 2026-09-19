import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/batch_list_repository.dart';
import 'batch_list_state.dart';

class BatchListCubit extends Cubit<BatchListState> {
  final BatchListRepository _batchListRepository;

  static const List<String> statusOptions = ['current', 'upcoming', 'ended'];
  static const int limit = 10;

  BatchListCubit(this._batchListRepository) : super(const BatchListState());

  Future<void> fetchBatches() async {
    if (state.page > state.totalPages) {
      return;
    }

    if (state.page == 1) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    } else {
      emit(state.copyWith(isLoadingMore: true, errorMessage: null));
    }

    final result = await _batchListRepository.getBatches(
      status: state.selectedStatus,
      page: state.page,
      limit: limit,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: failure.message,
        ),
      ),
      (response) {
        final newBatches = state.page == 1
            ? response.items
            : [...state.batches, ...response.items];

        emit(
          state.copyWith(
            batches: newBatches,
            totalPages: response.totalPages,
            isLoading: false,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore) {
      return;
    }

    if (state.page >= state.totalPages) {
      return;
    }

    emit(state.copyWith(page: state.page + 1));
    await fetchBatches();
  }

  Future<void> refreshBatches() async {
    emit(state.copyWith(page: 1, totalPages: 1, batches: []));
    await fetchBatches();
  }

  Future<void> setStatus(String status) async {
    if (state.selectedStatus == status) {
      return;
    }

    emit(
      state.copyWith(
        selectedStatus: status,
        page: 1,
        totalPages: 1,
        batches: [],
      ),
    );
    await fetchBatches();
  }

  String statusLabel(String status) {
    switch (status) {
      case 'current':
        return 'Current Batches';
      case 'upcoming':
        return 'Upcoming Batches';
      case 'ended':
        return 'Ended Batches';
      default:
        return status;
    }
  }

  String statusShortLabel(String status) {
    switch (status) {
      case 'current':
        return 'Current';
      case 'upcoming':
        return 'Upcoming';
      case 'ended':
        return 'Ended';
      default:
        return status;
    }
  }
}
