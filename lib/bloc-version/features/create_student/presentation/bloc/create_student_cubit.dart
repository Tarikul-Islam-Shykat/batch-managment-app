import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import '../../data/models/create_student_model.dart';
import '../../data/repositories/create_student_repository.dart';
import 'create_student_state.dart';

class CreateStudentCubit extends Cubit<CreateStudentState> {
  final CreateStudentRepository _repository;

  CreateStudentCubit(this._repository) : super(CreateStudentState.initial());

  void init(BatchListItemModel? initialBatch) {
    if (initialBatch != null) {
      _selectBatchInternal(initialBatch);
    } else {
      loadBatches();
    }
  }

  Future<void> loadBatches() async {
    emit(state.copyWith(isBatchesLoading: true));
    final result = await _repository.getAvailableBatches();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isBatchesLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (batches) {
        emit(
          state.copyWith(isBatchesLoading: false, availableBatches: batches),
        );
        if (batches.isNotEmpty && state.selectedBatch == null) {
          _selectBatchInternal(batches.first);
        }
      },
    );
  }

  void selectBatch(BatchListItemModel batch) {
    _selectBatchInternal(batch);
  }

  void _selectBatchInternal(BatchListItemModel batch) {
    final startDate = _parseDate(batch.startDate);
    final endDate = _parseDate(batch.endDate);
    final fallbackStart = startDate ?? DateTime.now();
    final fallbackEnd = endDate ?? fallbackStart;
    final clampedDate = _clampDate(fallbackStart, fallbackStart, fallbackEnd);

    final baseFee = batch.fees;
    final payable = _calcPayableFee(baseFee, state.discount);

    emit(
      state.copyWith(
        selectedBatch: batch,
        batchStartDate: startDate,
        batchEndDate: endDate,
        selectedDate: clampedDate,
        baseMonthlyFee: baseFee,
        payableFee: payable,
      ),
    );
  }

  void updateDiscount(double discount) {
    final clamped = discount.clamp(0.0, 100.0);
    final payable = _calcPayableFee(state.baseMonthlyFee, clamped);
    emit(state.copyWith(discount: clamped, payableFee: payable));
  }

  void updateSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  double _calcPayableFee(double baseFee, double discount) {
    final payable = baseFee - (baseFee * discount / 100);
    return payable < 0 ? 0.0 : payable;
  }

  DateTime? _parseDate(String value) {
    try {
      if (value.trim().isEmpty) return null;
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  DateTime _clampDate(DateTime value, DateTime firstDate, DateTime lastDate) {
    if (value.isBefore(firstDate)) return firstDate;
    if (value.isAfter(lastDate)) return lastDate;
    return value;
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String formatAmount(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

  Future<void> submitStudent({
    required String firstName,
    required String rollNumber,
    required String guardianPhone,
    required String notes,
  }) async {
    if (state.selectedBatch == null) {
      emit(state.copyWith(errorMessage: 'Please select a batch.'));
      return;
    }

    if (firstName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter student name.'));
      return;
    }

    if (rollNumber.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter roll number.'));
      return;
    }

    if (guardianPhone.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter guardian phone.'));
      return;
    }

    final payload = CreateStudentRequestModel(
      firstName: firstName.trim(),
      rollNumber: rollNumber.trim(),
      guardianPhone: guardianPhone.trim(),
      enrolledBatchId: state.selectedBatch!.id,
      batchStartedAt: formatDate(state.selectedDate),
      monthlyFee: state.baseMonthlyFee,
      discount: state.discount,
      notes: notes.trim(),
    );

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.enrollStudent(payload);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (response) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            successMessage:
                response.message ?? 'Student enrolled successfully!',
          ),
        );
      },
    );
  }
}
