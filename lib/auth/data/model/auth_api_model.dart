import 'package:json_annotation/json_annotation.dart';
import 'package:pet_connect/auth/domain/entity/auth_entity.dart';


part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel {
  @JsonKey(name: '_id')
  final String? userId;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String? location;
  final String role;

  AuthApiModel({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.location,
    required this.role,
  });

  /// From Entity
  factory AuthApiModel.fromEntity(AuthEntity authEntity) {
    return AuthApiModel(
      userId: authEntity.userId,
      fullName: authEntity.fullName,
      username: authEntity.username,
      email: authEntity.email,
      phoneNumber: authEntity.phoneNumber,
      password: authEntity.password,
      location: authEntity.location,
      role: authEntity.role,
    );
  }

  /// To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullName: fullName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      location: location,
      role: role,
    );
  }

  /// From JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);
}
