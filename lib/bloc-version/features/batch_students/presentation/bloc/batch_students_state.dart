import 'package:equatable/equatable.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import '../../data/models/batch_students_model.dart';

class BatchStudentsState extends Equatable {
  static const String filterAll = 'all';
  static const String filterPaid = 'paid';
  static const String filterUnpaid = 'unpaid';

  final bool isLoading;
  final bool isFinanceLoading;
  final bool isCollectingFee;
  final BatchListItemModel? batch;
  final List<BatchStudentModel> students;
  final String searchQuery;
  final String paymentFilter;
  final BatchFinanceSummaryModel? financeSummary;
  final String selectedFinanceMonth;
  final List<String> availableFinanceMonths;
  final Set<String> selectedStudentIds;
  final List<String> selectedFeeMonths;
  final String? errorMessage;
  final String? successMessage;

  const BatchStudentsState({
    this.isLoading = false,
    this.isFinanceLoading = false,
    this.isCollectingFee = false,
    this.batch,
    this.students = const [],
    this.searchQuery = '',
    this.paymentFilter = filterAll,
    this.financeSummary,
    this.selectedFinanceMonth = '',
    this.availableFinanceMonths = const [],
    this.selectedStudentIds = const {},
    this.selectedFeeMonths = const [],
    this.errorMessage,
    this.successMessage,
  });

  factory BatchStudentsState.initial() {
    return const BatchStudentsState();
  }

  List<BatchStudentModel> get filteredStudents {
    final query = searchQuery.trim().toLowerCase();
    final activeMonth = selectedFinanceMonth.toLowerCase();

    return students.where((student) {
      // 1. Payment filter
      final isPaid = _isStudentPaidForMonth(student, activeMonth);
      if (paymentFilter == filterPaid && !isPaid) return false;
      if (paymentFilter == filterUnpaid && isPaid) return false;

      // 2. Search query
      if (query.isNotEmpty) {
        final matchesQuery =
            student.firstName.toLowerCase().contains(query) ||
            student.rollNumber.toLowerCase().contains(query) ||
            student.guardianPhone.toLowerCase().contains(query) ||
            student.notes.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }

      return true;
    }).toList();
  }

  static bool _isStudentPaidForMonth(
    BatchStudentModel student,
    String activeMonth,
  ) {
    if (activeMonth.isEmpty) return false;
    return student.paidMonths.any((m) => m.trim().toLowerCase() == activeMonth);
  }

  List<BatchStudentModel> get selectedStudents {
    return students.where((s) => selectedStudentIds.contains(s.id)).toList();
  }

  int get selectedStudentCount => selectedStudentIds.length;

  double get selectedMonthlyAmount {
    return selectedStudents.fold(0.0, (sum, s) => sum + s.payableMonthlyAmount);
  }

  double get selectedOriginalAmount {
    final monthMultiplier = selectedFeeMonths.isEmpty
        ? 1
        : selectedFeeMonths.length;
    return selectedMonthlyAmount * monthMultiplier;
  }

  BatchStudentsState copyWith({
    bool? isLoading,
    bool? isFinanceLoading,
    bool? isCollectingFee,
    BatchListItemModel? batch,
    List<BatchStudentModel>? students,
    String? searchQuery,
    String? paymentFilter,
    BatchFinanceSummaryModel? financeSummary,
    String? selectedFinanceMonth,
    List<String>? availableFinanceMonths,
    Set<String>? selectedStudentIds,
    List<String>? selectedFeeMonths,
    String? errorMessage,
    String? successMessage,
  }) {
    return BatchStudentsState(
      isLoading: isLoading ?? this.isLoading,
      isFinanceLoading: isFinanceLoading ?? this.isFinanceLoading,
      isCollectingFee: isCollectingFee ?? this.isCollectingFee,
      batch: batch ?? this.batch,
      students: students ?? this.students,
      searchQuery: searchQuery ?? this.searchQuery,
      paymentFilter: paymentFilter ?? this.paymentFilter,
      financeSummary: financeSummary ?? this.financeSummary,
      selectedFinanceMonth: selectedFinanceMonth ?? this.selectedFinanceMonth,
      availableFinanceMonths:
          availableFinanceMonths ?? this.availableFinanceMonths,
      selectedStudentIds: selectedStudentIds ?? this.selectedStudentIds,
      selectedFeeMonths: selectedFeeMonths ?? this.selectedFeeMonths,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isFinanceLoading,
    isCollectingFee,
    batch,
    students,
    searchQuery,
    paymentFilter,
    financeSummary,
    selectedFinanceMonth,
    availableFinanceMonths,
    selectedStudentIds,
    selectedFeeMonths,
    errorMessage,
    successMessage,
  ];
}
