import '../../domain/entity/adoption_entity.dart';

class AdoptionModel extends AdoptionEntity {
  const AdoptionModel({
    super.id,
    required super.petId,
    required super.userId,
    super.status,
    super.message,
    super.createdAt,
    super.updatedAt,
  });

  factory AdoptionModel.fromJson(Map<String, dynamic> json) {
    return AdoptionModel(
      id: json['_id'],
      petId: json['petId'],
      userId: json['userId'],
      status: json['status'] ?? 'pending',
      message: json['message'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'petId': petId,
      'userId': userId,
      'status': status,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  AdoptionModel copyWith({
    String? id,
    String? petId,
    String? userId,
    String? status,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdoptionModel(
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
