import 'package:equatable/equatable.dart';

/// Response model for Login endpoint
class LoginResponseModel extends Equatable {
  final String accessToken;
  final String role;
  final String? tokenType;

  const LoginResponseModel({
    required this.accessToken,
    this.role = 'teacher',
    this.tokenType = 'bearer',
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token']?.toString() ?? '',
      role: json['role']?.toString() ?? 'teacher',
      tokenType: json['token_type']?.toString() ?? 'bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'role': role, 'token_type': tokenType};
  }

  @override
  List<Object?> get props => [accessToken, role, tokenType];
}
