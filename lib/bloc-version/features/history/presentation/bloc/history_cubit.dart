import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/history_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _repository;

  HistoryCubit({required HistoryRepository repository})
    : _repository = repository,
      super(const HistoryState());

  Future<void> fetchBatchHistory(String batchId, {String? batchName}) async {
    if (batchId.isEmpty) return;

    emit(
      state.copyWith(
        status: HistoryStatus.loading,
        batchId: batchId,
        batchName: batchName ?? state.batchName,
        studentId: null,
        studentName: null,
      ),
    );

    final result = await _repository.getBatchHistory(batchId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (entries) =>
          emit(state.copyWith(status: HistoryStatus.success, entries: entries)),
    );
  }

  Future<void> fetchStudentHistory(
    String studentId, {
    String? studentName,
  }) async {
    if (studentId.isEmpty) return;

    emit(
      state.copyWith(
        status: HistoryStatus.loading,
        studentId: studentId,
        studentName: studentName ?? state.studentName,
      ),
    );

    final result = await _repository.getStudentHistory(studentId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (entries) =>
          emit(state.copyWith(status: HistoryStatus.success, entries: entries)),
    );
  }

  Future<void> refresh() async {
    if (state.studentId != null && state.studentId!.isNotEmpty) {
      await fetchStudentHistory(
        state.studentId!,
        studentName: state.studentName,
      );
    } else if (state.batchId.isNotEmpty) {
      await fetchBatchHistory(state.batchId, batchName: state.batchName);
    }
  }
}
