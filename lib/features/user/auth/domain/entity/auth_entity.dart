import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String? location;
  final String role;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.location,
    required this.role,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    username,
    email,
    phoneNumber,
    password,
    location,
    role,
  ];
}
