import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:batch_management_app_direct/bloc-version/features/batch_students/data/models/batch_students_model.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import '../../data/models/edit_student_model.dart';
import '../../data/repositories/edit_student_repository.dart';
import 'edit_student_state.dart';

class EditStudentCubit extends Cubit<EditStudentState> {
  final EditStudentRepository _repository;

  EditStudentCubit(this._repository) : super(EditStudentState.initial());

  void init(BatchStudentModel student, BatchListItemModel? batch) {
    final baseFee = student.monthlyFee;
    final discount = student.discount;
    final payable = _calcPayableFee(baseFee, discount);

    emit(
      state.copyWith(
        student: student,
        batch: batch,
        baseMonthlyFee: baseFee,
        discount: discount,
        payableFee: payable,
      ),
    );
  }

  void updateFee(double fee) {
    final payable = _calcPayableFee(fee, state.discount);
    emit(state.copyWith(baseMonthlyFee: fee, payableFee: payable));
  }

  void updateDiscount(double discount) {
    final clamped = discount.clamp(0.0, 100.0);
    final payable = _calcPayableFee(state.baseMonthlyFee, clamped);
    emit(state.copyWith(discount: clamped, payableFee: payable));
  }

  double _calcPayableFee(double baseFee, double discount) {
    final payable = baseFee - (baseFee * discount / 100);
    return payable < 0 ? 0.0 : payable;
  }

  Future<void> submitUpdate({
    required String firstName,
    required String rollNumber,
    required String guardianPhone,
    required String notes,
  }) async {
    final currentStudent = state.student;
    if (currentStudent == null) return;

    final trimmedFirst = firstName.trim();
    final trimmedRoll = rollNumber.trim();
    final trimmedPhone = guardianPhone.trim();
    final trimmedNotes = notes.trim();

    String? changedFirst = trimmedFirst != currentStudent.firstName
        ? trimmedFirst
        : null;
    String? changedRoll = trimmedRoll != currentStudent.rollNumber
        ? trimmedRoll
        : null;
    String? changedPhone = trimmedPhone != currentStudent.guardianPhone
        ? trimmedPhone
        : null;
    double? changedFee = state.baseMonthlyFee != currentStudent.monthlyFee
        ? state.baseMonthlyFee
        : null;
    double? changedDiscount = state.discount != currentStudent.discount
        ? state.discount
        : null;
    String? changedNotes = trimmedNotes != currentStudent.notes
        ? trimmedNotes
        : null;

    final payload = EditStudentRequestModel(
      firstName: changedFirst,
      rollNumber: changedRoll,
      guardianPhone: changedPhone,
      monthlyFee: changedFee,
      discount: changedDiscount,
      notes: changedNotes,
    );

    if (payload.isEmpty) {
      emit(state.copyWith(errorMessage: 'No changes to update.'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.updateStudent(currentStudent.id, payload);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }
}
