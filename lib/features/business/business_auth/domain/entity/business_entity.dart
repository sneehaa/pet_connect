import 'package:equatable/equatable.dart';

class BusinessEntity extends Equatable {
  final String? businessId;
  final String businessName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String? address;
  final String? adoptionPolicy;
  final String role;
  final String? profileImagePath; 

  const BusinessEntity({
    this.businessId,
    required this.businessName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.address,
    this.adoptionPolicy,
    required this.role,
    this.profileImagePath,
  });

  @override
  List<Object?> get props => [
    businessId,
    businessName,
    username,
    email,
    phoneNumber,
    password,
    address,
    adoptionPolicy,
    role,
    profileImagePath,
  ];
}
