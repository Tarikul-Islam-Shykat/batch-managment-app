import 'package:equatable/equatable.dart';

/// Response model for OTP Verification endpoint
class OtpVerificationResponseModel extends Equatable {
  final String? accessToken;
  final String? role;
  final String? message;
  final Map<String, dynamic> rawResponse;

  const OtpVerificationResponseModel({
    this.accessToken,
    this.role,
    this.message,
    this.rawResponse = const {},
  });

  factory OtpVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponseModel(
      accessToken:
          json['access_token']?.toString() ?? json['token']?.toString(),
      role: json['role']?.toString(),
      message: json['message']?.toString() ?? json['detail']?.toString(),
      rawResponse: json,
    );
  }

  bool get hasToken => accessToken != null && accessToken!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'role': role, 'message': message};
  }

  @override
  List<Object?> get props => [accessToken, role, message];
}
