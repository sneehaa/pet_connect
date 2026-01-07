import 'package:equatable/equatable.dart';

class AdoptionEntity extends Equatable {
  final String? id;
  final String petId;
  final String userId;
  final String status;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdoptionEntity({
    this.id,
    required this.petId,
    required this.userId,
    this.status = "pending",
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        petId,
        userId,
        status,
        message,
        createdAt,
        updatedAt,
      ];

  AdoptionEntity copyWith({
    String? id,
    String? petId,
    String? userId,
    String? status,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdoptionEntity(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}