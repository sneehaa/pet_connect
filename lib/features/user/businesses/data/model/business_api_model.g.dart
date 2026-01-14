// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessApiModel _$BusinessApiModelFromJson(Map<String, dynamic> json) =>
    BusinessApiModel(
      id: json['_id'] as String?,
      businessName: json['businessName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      adoptionPolicy: json['adoptionPolicy'] as String?,
      address: json['address'] as String?,
      location: json['location'] as Map<String, dynamic>?,
      role: json['role'] as String,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BusinessApiModelToJson(BusinessApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'businessName': instance.businessName,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'adoptionPolicy': instance.adoptionPolicy,
      'address': instance.address,
      'location': instance.location,
      'role': instance.role,
      'distance': instance.distance,
    };
