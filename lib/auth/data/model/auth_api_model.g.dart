// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
  userId: json['_id'] as String?,
  fullName: json['fullName'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  password: json['password'] as String,
  location: json['location'] as String?,
  role: json['role'] as String,
);

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fullName': instance.fullName,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'location': instance.location,
      'role': instance.role,
    };
