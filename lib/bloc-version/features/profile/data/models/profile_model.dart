import 'package:equatable/equatable.dart';

/// User Profile Model
class UserProfileModel extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String institutionName;
  final String teachingLevel;
  final String institutionLocation;
  final String bio;
  final Map<String, dynamic> rawJson;

  const UserProfileModel({
    this.id,
    this.name = '',
    this.email = '',
    this.role = 'teacher',
    this.phone = '',
    this.institutionName = '',
    this.teachingLevel = '',
    this.institutionLocation = '',
    this.bio = '',
    this.rawJson = const {},
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    String firstNonEmpty(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final val = json[key];
        if (val != null) {
          final s = val.toString().trim();
          if (s.isNotEmpty && s != 'null') return s;
        }
      }
      return fallback;
    }

    return UserProfileModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: firstNonEmpty([
        'full_name',
        'name',
        'username',
        'first_name',
        'email',
      ], fallback: 'Teacher'),
      email: firstNonEmpty(['email', 'mail']),
      role: firstNonEmpty([
        'role',
        'designation',
        'user_type',
        'account_type',
      ], fallback: 'Teacher'),
      phone: firstNonEmpty(['phone', 'mobile', 'phone_number']),
      institutionName: firstNonEmpty(['institution_name', 'institution']),
      teachingLevel: firstNonEmpty(['teaching_level', 'level']),
      institutionLocation: firstNonEmpty(['institution_location', 'location']),
      bio: firstNonEmpty(['bio', 'about_me', 'about']),
      rawJson: json,
    );
  }

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? institutionName,
    String? teachingLevel,
    String? institutionLocation,
    String? bio,
    Map<String, dynamic>? rawJson,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      institutionName: institutionName ?? this.institutionName,
      teachingLevel: teachingLevel ?? this.teachingLevel,
      institutionLocation: institutionLocation ?? this.institutionLocation,
      bio: bio ?? this.bio,
      rawJson: rawJson ?? this.rawJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'institution_name': institutionName,
      'teaching_level': teachingLevel,
      'institution_location': institutionLocation,
      'bio': bio,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    phone,
    institutionName,
    teachingLevel,
    institutionLocation,
    bio,
  ];
}
