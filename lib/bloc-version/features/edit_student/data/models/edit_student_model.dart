import 'package:equatable/equatable.dart';

class EditStudentRequestModel extends Equatable {
  final String? firstName;
  final String? rollNumber;
  final String? guardianPhone;
  final double? monthlyFee;
  final double? discount;
  final String? notes;

  const EditStudentRequestModel({
    this.firstName,
    this.rollNumber,
    this.guardianPhone,
    this.monthlyFee,
    this.discount,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstName != null) map['first_name'] = firstName;
    if (rollNumber != null) map['roll_number'] = rollNumber;
    if (guardianPhone != null) map['guardian_phone'] = guardianPhone;
    if (monthlyFee != null) map['monthly_fee'] = monthlyFee;
    if (discount != null) map['discount'] = discount;
    if (notes != null) map['notes'] = notes;
    return map;
  }

  bool get isEmpty => toJson().isEmpty;

  @override
  List<Object?> get props => [
    firstName,
    rollNumber,
    guardianPhone,
    monthlyFee,
    discount,
    notes,
  ];
}
