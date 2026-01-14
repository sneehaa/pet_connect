// lib/features/business/profile/domain/entity/business_profile_entity.dart

import 'package:equatable/equatable.dart';

class BusinessProfileEntity extends Equatable {
  final String? businessId;
  final String businessName;
  final String? username;
  final String? email;
  final String phoneNumber;
  final String? address;
  final String? adoptionPolicy;
  final LocationEntity? location;
  final String? role;
  final List<String>? documents;
  final String businessStatus;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessProfileEntity({
    this.businessId,
    required this.businessName,
    this.username,
    this.email,
    required this.phoneNumber,
    this.address,
    this.adoptionPolicy,
    this.location,
    this.role,
    this.documents,
    required this.businessStatus,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    businessId,
    businessName,
    username,
    email,
    phoneNumber,
    address,
    adoptionPolicy,
    location,
    role,
    documents,
    businessStatus,
    rejectionReason,
    createdAt,
    updatedAt,
  ];

  BusinessProfileEntity copyWith({
    String? businessId,
    String? businessName,
    String? username,
    String? email,
    String? phoneNumber,
    String? address,
    String? adoptionPolicy,
    LocationEntity? location,
    String? role,
    List<String>? documents,
    String? businessStatus,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessProfileEntity(
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      adoptionPolicy: adoptionPolicy ?? this.adoptionPolicy,
      location: location ?? this.location,
      role: role ?? this.role,
      documents: documents ?? this.documents,
      businessStatus: businessStatus ?? this.businessStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LocationEntity extends Equatable {
  final String type;
  final List<double> coordinates;

  const LocationEntity({this.type = 'Point', required this.coordinates});

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;

  @override
  List<Object> get props => [type, coordinates];

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(
        (json['coordinates'] as List).map((e) => e.toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}
