import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/business_entity.dart';

part 'business_api_model.g.dart';

@JsonSerializable()
class BusinessApiModel {
  @JsonKey(name: '_id')
  final String? businessId;
  final String businessName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String? address;
  final String? adoptionPolicy;
  final String role;

  BusinessApiModel({
    required this.businessId,
    required this.businessName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.address,
    this.adoptionPolicy,
    required this.role,
  });

  /// From Entity
  factory BusinessApiModel.fromEntity(BusinessEntity entity) {
    return BusinessApiModel(
      businessId: entity.businessId,
      businessName: entity.businessName,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      address: entity.address,
      adoptionPolicy: entity.adoptionPolicy,
      role: entity.role,
    );
  }

  /// To Entity
  BusinessEntity toEntity() {
    return BusinessEntity(
      businessId: businessId,
      businessName: businessName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      address: address,
      adoptionPolicy: adoptionPolicy,
      role: role,
    );
  }

  factory BusinessApiModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessApiModelToJson(this);
}
