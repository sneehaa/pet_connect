import 'package:json_annotation/json_annotation.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

part 'business_api_model.g.dart';

@JsonSerializable()
class BusinessApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String businessName;
  final String username;
  final String email;
  final String phoneNumber;
  final String? adoptionPolicy;
  final String? address;
  final Map<String, dynamic>? location;
  final String role;
  final double? distance;

  BusinessApiModel({
    this.id,
    required this.businessName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.adoptionPolicy,
    this.address,
    this.location,
    required this.role,
    this.distance,
  });

  /// From Entity
  factory BusinessApiModel.fromEntity(BusinessEntity businessEntity) {
    return BusinessApiModel(
      id: businessEntity.id,
      businessName: businessEntity.businessName,
      username: businessEntity.username,
      email: businessEntity.email,
      phoneNumber: businessEntity.phoneNumber,
      adoptionPolicy: businessEntity.adoptionPolicy,
      address: businessEntity.address,
      location: businessEntity.location != null
          ? {
              'type': businessEntity.location!.type,
              'coordinates': businessEntity.location!.coordinates,
            }
          : null,
      role: businessEntity.role,
      distance: businessEntity.distance,
    );
  }

  /// To Entity
  BusinessEntity toEntity() {
    return BusinessEntity(
      id: id,
      businessName: businessName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      adoptionPolicy: adoptionPolicy,
      address: address,
      location: location != null
          ? Location(
              type: location!['type'] ?? 'Point',
              coordinates: List<double>.from(
                location!['coordinates'] ?? [0, 0],
              ),
            )
          : null,
      role: role,
      distance: distance,
    );
  }

  /// From JSON
  factory BusinessApiModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$BusinessApiModelToJson(this);
}
