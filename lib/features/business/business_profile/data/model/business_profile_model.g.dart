// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessProfileApiModel _$BusinessProfileApiModelFromJson(
  Map<String, dynamic> json,
) => BusinessProfileApiModel(
  businessId: json['_id'] as String?,
  businessName: json['businessName'] as String,
  username: json['username'] as String?,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String,
  address: json['address'] as String?,
  adoptionPolicy: json['adoptionPolicy'] as String?,
  location: json['location'] as Map<String, dynamic>?,
  role: json['role'] as String?,
  documents: (json['documents'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  businessStatus: json['businessStatus'] as String,
  rejectionReason: json['rejectionReason'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$BusinessProfileApiModelToJson(
  BusinessProfileApiModel instance,
) => <String, dynamic>{
  '_id': instance.businessId,
  'businessName': instance.businessName,
  'username': instance.username,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'address': instance.address,
  'adoptionPolicy': instance.adoptionPolicy,
  'location': instance.location,
  'role': instance.role,
  'documents': instance.documents,
  'businessStatus': instance.businessStatus,
  'rejectionReason': instance.rejectionReason,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
