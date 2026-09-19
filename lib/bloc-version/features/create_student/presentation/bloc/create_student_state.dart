import 'package:equatable/equatable.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';

class CreateStudentState extends Equatable {
  final bool isLoading;
  final bool isBatchesLoading;
  final BatchListItemModel? selectedBatch;
  final List<BatchListItemModel> availableBatches;
  final DateTime selectedDate;
  final DateTime? batchStartDate;
  final DateTime? batchEndDate;
  final double baseMonthlyFee;
  final double discount;
  final double payableFee;
  final bool isSuccess;
  final String? successMessage;
  final String? errorMessage;

  const CreateStudentState({
    this.isLoading = false,
    this.isBatchesLoading = false,
    this.selectedBatch,
    this.availableBatches = const [],
    required this.selectedDate,
    this.batchStartDate,
    this.batchEndDate,
    this.baseMonthlyFee = 0.0,
    this.discount = 0.0,
    this.payableFee = 0.0,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
  });

  factory CreateStudentState.initial() {
    return CreateStudentState(selectedDate: DateTime.now());
  }

  CreateStudentState copyWith({
    bool? isLoading,
    bool? isBatchesLoading,
    BatchListItemModel? selectedBatch,
    List<BatchListItemModel>? availableBatches,
    DateTime? selectedDate,
    DateTime? batchStartDate,
    DateTime? batchEndDate,
    double? baseMonthlyFee,
    double? discount,
    double? payableFee,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
  }) {
    return CreateStudentState(
      isLoading: isLoading ?? this.isLoading,
      isBatchesLoading: isBatchesLoading ?? this.isBatchesLoading,
      selectedBatch: selectedBatch ?? this.selectedBatch,
      availableBatches: availableBatches ?? this.availableBatches,
      selectedDate: selectedDate ?? this.selectedDate,
      batchStartDate: batchStartDate ?? this.batchStartDate,
      batchEndDate: batchEndDate ?? this.batchEndDate,
      baseMonthlyFee: baseMonthlyFee ?? this.baseMonthlyFee,
      discount: discount ?? this.discount,
      payableFee: payableFee ?? this.payableFee,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isBatchesLoading,
    selectedBatch,
    availableBatches,
    selectedDate,
    batchStartDate,
    batchEndDate,
    baseMonthlyFee,
    discount,
    payableFee,
    isSuccess,
    successMessage,
    errorMessage,
  ];
}
