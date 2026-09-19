import 'package:equatable/equatable.dart';

/// Response model for SignUp endpoint
class RegisterResponseModel extends Equatable {
  final String? otp;
  final String? role;
  final String? email;
  final String? name;
  final bool userBlock;
  final bool emailVerified;
  final bool verificationSent;
  final Map<String, dynamic> rawResponse;

  const RegisterResponseModel({
    this.otp,
    this.role,
    this.email,
    this.name,
    this.userBlock = false,
    this.emailVerified = false,
    this.verificationSent = false,
    this.rawResponse = const {},
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      otp: json['otp']?.toString(),
      role: json['role']?.toString() ?? 'teacher',
      email: json['email']?.toString(),
      name: json['name']?.toString(),
      userBlock: json['user_block'] == true,
      emailVerified: json['email_verified'] == true,
      verificationSent: json['verification_sent'] == true,
      rawResponse: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'role': role,
      'email': email,
      'name': name,
      'user_block': userBlock,
      'email_verified': emailVerified,
      'verification_sent': verificationSent,
    };
  }

  @override
  List<Object?> get props => [
    otp,
    role,
    email,
    name,
    userBlock,
    emailVerified,
    verificationSent,
  ];
}
