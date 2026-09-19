import 'package:equatable/equatable.dart';

class CreateStudentRequestModel extends Equatable {
  final String firstName;
  final String rollNumber;
  final String guardianPhone;
  final String enrolledBatchId;
  final String batchStartedAt;
  final double monthlyFee;
  final double discount;
  final String notes;

  const CreateStudentRequestModel({
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

  @override
  List<Object?> get props => [
    firstName,
    rollNumber,
    guardianPhone,
    enrolledBatchId,
    batchStartedAt,
    monthlyFee,
    discount,
    notes,
  ];
}

class CreateStudentResponseModel extends Equatable {
  final String? id;
  final String? message;
  final Map<String, dynamic> rawJson;

  const CreateStudentResponseModel({
    this.id,
    this.message,
    this.rawJson = const {},
  });

  factory CreateStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentResponseModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      message: json['message']?.toString(),
      rawJson: json,
    );
  }

  @override
  List<Object?> get props => [id, message, rawJson];
}
