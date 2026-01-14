import 'package:pet_connect/features/user/profile/domain/entity/profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    super.id,
    required super.fullName,
    required super.username,
    required super.email,
    required super.phoneNumber,
    super.location,
    super.role,
    super.createdAt,
    super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      role: json['role'] ?? 'User',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'role': role,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
    };
  }
}
