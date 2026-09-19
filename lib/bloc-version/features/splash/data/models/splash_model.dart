import 'package:equatable/equatable.dart';

/// Session Model representing authenticated user details in BLoC
class SessionModel extends Equatable {
  final String? token;
  final String? role;
  final String? name;
  final String? email;

  const SessionModel({this.token, this.role, this.name, this.email});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      token: json['access_token'] ?? json['token'],
      role: json['role']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'role': role, 'name': name, 'email': email};
  }

  @override
  List<Object?> get props => [token, role, name, email];
}
