import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/business_profile_entity.dart';

part 'business_profile_model.g.dart';

@JsonSerializable()
class BusinessProfileApiModel {
  @JsonKey(name: '_id')
  final String? businessId;
  final String businessName;
  final String? username;
  final String? email;
  final String phoneNumber;
  final String? address;
  final String? adoptionPolicy;
  final Map<String, dynamic>? location;
  final String? role;
  final List<String>? documents;
  @JsonKey(name: 'businessStatus')
  final String businessStatus;
  final String? rejectionReason;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  BusinessProfileApiModel({
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

  /// From Entity
  factory BusinessProfileApiModel.fromEntity(BusinessProfileEntity entity) {
    return BusinessProfileApiModel(
      businessId: entity.businessId,
      businessName: entity.businessName,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      adoptionPolicy: entity.adoptionPolicy,
      location: entity.location?.toJson(),
      role: entity.role,
      documents: entity.documents,
      businessStatus: entity.businessStatus,
      rejectionReason: entity.rejectionReason,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }

  /// To Entity
  BusinessProfileEntity toEntity() {
    return BusinessProfileEntity(
      businessId: businessId,
      businessName: businessName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      adoptionPolicy: adoptionPolicy,
      location: location != null ? LocationEntity.fromJson(location!) : null,
      role: role,
      documents: documents,
      businessStatus: businessStatus,
      rejectionReason: rejectionReason,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory BusinessProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessProfileApiModelToJson(this);
}
