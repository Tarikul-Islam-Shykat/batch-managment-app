class StudentEnrollRequestModel {
  final String firstName;
  final String rollNumber;
  final String guardianPhone;
  final String enrolledBatchId;
  final String batchStartedAt;
  final double monthlyFee;
  final double discount;
  final String notes;

  const StudentEnrollRequestModel({
    required this.firstName,
    required this.rollNumber,
    required this.guardianPhone,
    required this.enrolledBatchId,
    required this.batchStartedAt,
    required this.monthlyFee,
    required this.discount,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'roll_number': rollNumber,
      'guardian_phone': guardianPhone,
      'enrolled_batch_id': enrolledBatchId,
      'batch_started_at': batchStartedAt,
      'monthly_fee': monthlyFee,
      'discount': discount,
      'notes': notes,
    };
  }
}
