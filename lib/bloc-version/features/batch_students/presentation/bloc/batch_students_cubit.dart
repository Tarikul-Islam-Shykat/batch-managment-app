import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import '../../data/models/batch_students_model.dart';
import '../../data/repositories/batch_students_repository.dart';
import 'batch_students_state.dart';

class BatchStudentsCubit extends Cubit<BatchStudentsState> {
  final BatchStudentsRepository _repository;

  BatchStudentsCubit(this._repository) : super(BatchStudentsState.initial());

  void init(BatchListItemModel batch) {
    final monthOptions = _buildMonthOptions(batch);
    final currentMonth = _currentMonthLabel();
    final defaultMonth = monthOptions.contains(currentMonth)
        ? currentMonth
        : (monthOptions.isNotEmpty ? monthOptions.first : currentMonth);

    emit(
      state.copyWith(
        batch: batch,
        availableFinanceMonths: monthOptions,
        selectedFinanceMonth: defaultMonth,
        selectedFeeMonths: [defaultMonth],
      ),
    );

    fetchStudents();
    fetchFinanceSummary(month: defaultMonth);
  }

  static String _currentMonthLabel() {
    return DateFormat('MMMM yyyy', 'en_US').format(DateTime.now());
  }

  static String _formatMonth(DateTime dt) {
    return DateFormat('MMMM yyyy', 'en_US').format(dt);
  }

  List<String> _buildMonthOptions(BatchListItemModel batch) {
    final now = DateTime.now();
    DateTime start = DateTime(now.year, now.month);
    DateTime end = DateTime(now.year, now.month);

    try {
      final parsedStart = DateTime.parse(batch.startDate);
      final parsedEnd = DateTime.parse(batch.endDate);
      start = DateTime(parsedStart.year, parsedStart.month);
      end = DateTime(parsedEnd.year, parsedEnd.month);
      if (end.isBefore(start)) {
        final temp = start;
        start = end;
        end = temp;
      }
    } catch (_) {
      start = DateTime(now.year, now.month - 2);
      end = DateTime(now.year, now.month + 11);
    }

    final options = <String>[];
    var cursor = start;
    while (!cursor.isAfter(end)) {
      options.add(_formatMonth(cursor));
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    final cur = _currentMonthLabel();
    if (!options.contains(cur)) {
      options.add(cur);
    }

    return options.toSet().toList();
  }

  Future<void> fetchStudents() async {
    final batch = state.batch;
    if (batch == null) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getStudentsByBatch(batch.id);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (students) {
        emit(state.copyWith(isLoading: false, students: students));
      },
    );
  }

  Future<void> fetchFinanceSummary({String? month}) async {
    final batch = state.batch;
    if (batch == null) return;

    final targetMonth = month ?? state.selectedFinanceMonth;
    emit(
      state.copyWith(isFinanceLoading: true, selectedFinanceMonth: targetMonth),
    );

    final result = await _repository.getFinanceSummary(batch.id, targetMonth);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isFinanceLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (summary) {
        emit(state.copyWith(isFinanceLoading: false, financeSummary: summary));
      },
    );
  }

  Future<void> refresh() async {
    await Future.wait([fetchStudents(), fetchFinanceSummary()]);
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setPaymentFilter(String filter) {
    emit(state.copyWith(paymentFilter: filter));
  }

  void changeFinanceMonth(String month) {
    if (month.isEmpty || month == state.selectedFinanceMonth) return;
    fetchFinanceSummary(month: month);
  }

  void toggleStudentSelection(String studentId) {
    final updated = Set<String>.from(state.selectedStudentIds);
    if (updated.contains(studentId)) {
      updated.remove(studentId);
    } else {
      updated.add(studentId);
    }
    emit(state.copyWith(selectedStudentIds: updated));
  }

  void clearSelectedStudents() {
    emit(state.copyWith(selectedStudentIds: const {}));
  }

  void addFeeMonth(String month) {
    if (month.isEmpty || state.selectedFeeMonths.contains(month)) return;
    final updated = List<String>.from(state.selectedFeeMonths)..add(month);
    emit(state.copyWith(selectedFeeMonths: updated));
  }

  void removeFeeMonth(String month) {
    final updated = List<String>.from(state.selectedFeeMonths)..remove(month);
    emit(state.copyWith(selectedFeeMonths: updated));
  }

  Future<bool> collectFees({
    required double amountPaid,
    required double originalAmount,
    required String paymentMethod,
    required String notes,
  }) async {
    final batch = state.batch;
    final selectedStudents = state.selectedStudents;
    if (batch == null || selectedStudents.isEmpty) return false;

    final months = state.selectedFeeMonths.isEmpty
        ? [state.selectedFinanceMonth]
        : state.selectedFeeMonths;

    final payload = BatchFeeCollectRequestModel(
      studentIds: selectedStudents.map((s) => s.id).toList(),
      batchId: batch.id,
      months: months,
      amountPaid: amountPaid,
      originalAmount: originalAmount,
      paymentMethod: paymentMethod,
      notes: notes,
    );

    emit(state.copyWith(isCollectingFee: true, errorMessage: null));

    final result = await _repository.collectFees(payload);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(isCollectingFee: false, errorMessage: failure.message),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            isCollectingFee: false,
            selectedStudentIds: const {},
            successMessage: 'Fees collected successfully!',
          ),
        );
        refresh();
        return true;
      },
    );
  }
}
