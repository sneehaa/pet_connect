import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? id;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String? location;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileEntity({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.location,
    this.role = 'User',
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    username,
    email,
    phoneNumber,
    location,
    role,
    createdAt,
    updatedAt,
  ];

  UserProfileEntity copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? phoneNumber,
    String? location,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) {
    return UserProfileEntity(
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

  // Helper getter to check if user is admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  // Helper getter to check if user is regular user
  bool get isUser => role.toLowerCase() == 'user';
}
