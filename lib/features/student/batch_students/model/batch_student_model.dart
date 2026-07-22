class BatchStudentModel {
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
      id: json['id']?.toString() ?? '',
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
      monthlyFee: (json['monthly_fee'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      notes: json['notes']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      approvedAt: json['approved_at']?.toString() ?? '',
    );
  }
}
