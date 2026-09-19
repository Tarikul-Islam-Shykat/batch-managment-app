import 'package:equatable/equatable.dart';
import '../../data/models/history_entry_model.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<HistoryEntryModel> entries;
  final String? errorMessage;
  final String batchId;
  final String batchName;
  final String? studentId;
  final String? studentName;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.entries = const [],
    this.errorMessage,
    this.batchId = '',
    this.batchName = '',
    this.studentId,
    this.studentName,
  });

  bool get isLoading => status == HistoryStatus.loading;
  bool get hasError => status == HistoryStatus.failure;
  bool get isEmpty => status == HistoryStatus.success && entries.isEmpty;

  String get screenTitle {
    if (studentName != null && studentName!.isNotEmpty) {
      return 'Student History';
    }
    return 'Batch History';
  }

  String get subtitle {
    if (studentName != null && studentName!.isNotEmpty) {
      return studentName!;
    }
    return batchName;
  }

  HistoryState copyWith({
    HistoryStatus? status,
    List<HistoryEntryModel>? entries,
    String? errorMessage,
    String? batchId,
    String? batchName,
    String? studentId,
    String? studentName,
  }) {
    return HistoryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: errorMessage,
      batchId: batchId ?? this.batchId,
      batchName: batchName ?? this.batchName,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
    );
  }

  @override
  List<Object?> get props => [
    status,
    entries,
    errorMessage,
    batchId,
    batchName,
    studentId,
    studentName,
  ];
}
