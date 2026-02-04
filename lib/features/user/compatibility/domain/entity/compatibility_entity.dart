import 'package:equatable/equatable.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart'
    as pet_entity;

class CompatibilityEntity extends Equatable {
  final String? id;
  final String userId;
  final String livingSpace;
  final String activityLevel;
  final String workSchedule;
  final String petExperience;
  final String household;
  final String preferredEnergy;
  final String timeForPet;
  final String noiseTolerance;
  final bool hasYard;
  final bool hasAllergies;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CompatibilityEntity({
    this.id,
    required this.userId,
    required this.livingSpace,
    required this.activityLevel,
    required this.workSchedule,
    required this.petExperience,
    required this.household,
    required this.preferredEnergy,
    required this.timeForPet,
    required this.noiseTolerance,
    required this.hasYard,
    required this.hasAllergies,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    livingSpace,
    activityLevel,
    workSchedule,
    petExperience,
    household,
    preferredEnergy,
    timeForPet,
    noiseTolerance,
    hasYard,
    hasAllergies,
    createdAt,
    updatedAt,
  ];
}

class CompatibilityScoreEntity extends Equatable {
  final String petId;
  final int compatibilityScore;
  final String explanation;
  final Map<String, dynamic> breakdown;
  final Map<String, dynamic>? pet;

  const CompatibilityScoreEntity({
    required this.petId,
    required this.compatibilityScore,
    required this.explanation,
    required this.breakdown,
    this.pet,
  });

  @override
  List<Object?> get props => [
    petId,
    compatibilityScore,
    explanation,
    breakdown,
    pet,
  ];
}

class CompatibilityResultEntity extends Equatable {
  final CompatibilityScoreEntity score;
  final UserPetEntity? pet;

  const CompatibilityResultEntity({required this.score, this.pet});

  @override
  List<Object?> get props => [score, pet];
}

// Type alias for clarity
typedef UserPetEntity = pet_entity.UserPetEntity;
