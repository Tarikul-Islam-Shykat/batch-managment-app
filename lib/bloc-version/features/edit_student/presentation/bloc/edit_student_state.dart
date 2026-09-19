import 'package:equatable/equatable.dart';
import 'package:batch_management_app_direct/bloc-version/features/batch_students/data/models/batch_students_model.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';

class EditStudentState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final BatchStudentModel? student;
  final BatchListItemModel? batch;
  final double baseMonthlyFee;
  final double discount;
  final double payableFee;
  final String? errorMessage;

  const EditStudentState({
    this.isLoading = false,
    this.isSuccess = false,
    this.student,
    this.batch,
    this.baseMonthlyFee = 0.0,
    this.discount = 0.0,
    this.payableFee = 0.0,
    this.errorMessage,
  });

  factory EditStudentState.initial() {
    return const EditStudentState();
  }

  EditStudentState copyWith({
    bool? isLoading,
    bool? isSuccess,
    BatchStudentModel? student,
    BatchListItemModel? batch,
    double? baseMonthlyFee,
    double? discount,
    double? payableFee,
    String? errorMessage,
  }) {
    return EditStudentState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      student: student ?? this.student,
      batch: batch ?? this.batch,
      baseMonthlyFee: baseMonthlyFee ?? this.baseMonthlyFee,
      discount: discount ?? this.discount,
      payableFee: payableFee ?? this.payableFee,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    student,
    batch,
    baseMonthlyFee,
    discount,
    payableFee,
    errorMessage,
  ];
}
