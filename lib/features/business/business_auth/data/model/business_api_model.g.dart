// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessApiModel _$BusinessApiModelFromJson(Map<String, dynamic> json) =>
    BusinessApiModel(
      businessId: json['_id'] as String?,
      businessName: json['businessName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      address: json['address'] as String?,
      adoptionPolicy: json['adoptionPolicy'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$BusinessApiModelToJson(BusinessApiModel instance) =>
    <String, dynamic>{
      '_id': instance.businessId,
      'businessName': instance.businessName,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'address': instance.address,
      'adoptionPolicy': instance.adoptionPolicy,
      'role': instance.role,
    };
