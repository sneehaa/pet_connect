import 'package:pet_connect/features/user/compatibility/domain/entity/compatibility_entity.dart';

class CompatibilityModel extends CompatibilityEntity {
  const CompatibilityModel({
    super.id,
    required super.userId,
    required super.livingSpace,
    required super.activityLevel,
    required super.workSchedule,
    required super.petExperience,
    required super.household,
    required super.preferredEnergy,
    required super.timeForPet,
    required super.noiseTolerance,
    required super.hasYard,
    required super.hasAllergies,
    super.createdAt,
    super.updatedAt,
  });

  factory CompatibilityModel.fromJson(Map<String, dynamic> json) {
    return CompatibilityModel(
      id: json['_id'],
      userId: json['userId'],
      livingSpace: json['livingSpace'],
      activityLevel: json['activityLevel'],
      workSchedule: json['workSchedule'],
      petExperience: json['petExperience'],
      household: json['household'],
      preferredEnergy: json['preferredEnergy'],
      timeForPet: json['timeForPet'],
      noiseTolerance: json['noiseTolerance'],
      hasYard: json['hasYard'],
      hasAllergies: json['hasAllergies'],
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
      'livingSpace': livingSpace,
      'activityLevel': activityLevel,
      'workSchedule': workSchedule,
      'petExperience': petExperience,
      'household': household,
      'preferredEnergy': preferredEnergy,
      'timeForPet': timeForPet,
      'noiseTolerance': noiseTolerance,
      'hasYard': hasYard,
      'hasAllergies': hasAllergies,
    };
  }
}

class CompatibilityScoreModel extends CompatibilityScoreEntity {
  const CompatibilityScoreModel({
    required super.petId,
    required super.compatibilityScore,
    required super.explanation,
    required super.breakdown,
    super.pet,
  });

  factory CompatibilityScoreModel.fromJson(Map<String, dynamic> json) {
    return CompatibilityScoreModel(
      petId: json['petId'] ?? json['pet']['_id'],
      compatibilityScore: json['compatibilityScore'],
      explanation: json['explanation'],
      breakdown: Map<String, dynamic>.from(json['breakdown'] ?? {}),
      pet: json['pet'] != null ? Map<String, dynamic>.from(json['pet']) : null,
    );
  }
}

class CompatibilityResultModel extends CompatibilityResultEntity {
  const CompatibilityResultModel({required super.score, super.pet});

  factory CompatibilityResultModel.fromJson(Map<String, dynamic> json) {
    return CompatibilityResultModel(
      score: CompatibilityScoreModel.fromJson(json),
      pet: json['pet'] != null ? UserPetEntity.fromJson(json['pet']) : null,
    );
  }
}
