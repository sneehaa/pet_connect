import 'package:equatable/equatable.dart';

class BusinessEntity extends Equatable {
  final String? id;
  final String businessName;
  final String username;
  final String email;
  final String phoneNumber;
  final String? adoptionPolicy;
  final String? address;
  final String role;
  final String? profileImageUrl;

  const BusinessEntity({
    this.id,
    required this.businessName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.adoptionPolicy,
    this.address,
    required this.role,
    this.profileImageUrl
  });

  @override
  List<Object?> get props => [
    id,
    businessName,
    username,
    email,
    phoneNumber,
    adoptionPolicy,
    address,
    role,
    profileImageUrl
  ];
}
