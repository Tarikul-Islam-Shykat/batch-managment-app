import 'package:equatable/equatable.dart';

class BatchStudentModel extends Equatable {
  final String id;
  final String studentSystemId;
  final String batchId;
  final String teacherId;
  final String firstName;
  final String rollNumber;
  final String guardianPhone;
  final String batchStartedAt;
  final List<String> paidMonths;
  final double monthlyFee;
  final double discount;
  final String notes;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String approvedAt;

  const BatchStudentModel({
    required this.id,
    required this.studentSystemId,
    required this.batchId,
    required this.teacherId,
    required this.firstName,
    required this.rollNumber,
    required this.guardianPhone,
    required this.batchStartedAt,
    required this.paidMonths,
    required this.monthlyFee,
    required this.discount,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.approvedAt,
  });

  factory BatchStudentModel.fromJson(Map<String, dynamic> json) {
    return BatchStudentModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      studentSystemId: json['student_system_id']?.toString() ?? '',
      batchId: json['batch_id']?.toString() ?? '',
      teacherId: json['teacher_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      rollNumber: json['roll_number']?.toString() ?? '',
      guardianPhone: json['guardian_phone']?.toString() ?? '',
      batchStartedAt: json['batch_started_at']?.toString() ?? '',
      paidMonths: (json['paid_months'] as List<dynamic>? ?? const [])
          .map((month) => month.toString())
          .where((month) => month.trim().isNotEmpty)
          .toList(),
      monthlyFee: (json['monthly_fee'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      approvedAt: json['approved_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_system_id': studentSystemId,
      'batch_id': batchId,
      'teacher_id': teacherId,
      'first_name': firstName,
      'roll_number': rollNumber,
      'guardian_phone': guardianPhone,
      'batch_started_at': batchStartedAt,
      'paid_months': paidMonths,
      'monthly_fee': monthlyFee,
      'discount': discount,
      'notes': notes,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'approved_at': approvedAt,
    };
  }

  double get payableMonthlyAmount =>
      (monthlyFee - discount).clamp(0.0, double.infinity);

  @override
  List<Object?> get props => [
    id,
    studentSystemId,
    batchId,
    teacherId,
    firstName,
    rollNumber,
    guardianPhone,
    batchStartedAt,
    paidMonths,
    monthlyFee,
    discount,
    notes,
    status,
    createdAt,
    updatedAt,
    approvedAt,
  ];
}

class BatchFinanceSummaryModel extends Equatable {
  final int totalStudents;
  final int paidStudents;
  final double totalExpectedAmount;
  final double totalPaidAmount;
  final double remainingAmount;

  const BatchFinanceSummaryModel({
    required this.totalStudents,
    required this.paidStudents,
    required this.totalExpectedAmount,
    required this.totalPaidAmount,
    required this.remainingAmount,
  });

  factory BatchFinanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return BatchFinanceSummaryModel(
      totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
      paidStudents: (json['paid_students'] as num?)?.toInt() ?? 0,
      totalExpectedAmount:
          (json['total_expected_amount'] as num?)?.toDouble() ?? 0.0,
      totalPaidAmount: (json['total_paid_amount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remaining_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'paid_students': paidStudents,
      'total_expected_amount': totalExpectedAmount,
      'total_paid_amount': totalPaidAmount,
      'remaining_amount': remainingAmount,
    };
  }

  @override
  List<Object?> get props => [
    totalStudents,
    paidStudents,
    totalExpectedAmount,
    totalPaidAmount,
    remainingAmount,
  ];
}

class BatchFeeCollectRequestModel extends Equatable {
  final List<String> studentIds;
  final String batchId;
  final List<String> months;
  final double amountPaid;
  final double originalAmount;
  final String paymentMethod;
  final String notes;

  const BatchFeeCollectRequestModel({
    required this.studentIds,
    required this.batchId,
    required this.months,
    required this.amountPaid,
    required this.originalAmount,
    required this.paymentMethod,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_ids': studentIds,
      'batch_id': batchId,
      'months': months,
      'amount_paid': amountPaid,
      'original_amount': originalAmount,
      'payment_method': paymentMethod,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    studentIds,
    batchId,
    months,
    amountPaid,
    originalAmount,
    paymentMethod,
    notes,
  ];
}
