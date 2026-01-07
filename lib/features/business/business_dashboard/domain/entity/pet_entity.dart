import 'package:equatable/equatable.dart';

class PetEntity extends Equatable {
  final String? id;
  final String name;
  final String breed;
  final int age;
  final String gender;
  final bool vaccinated;
  final String? description;
  final String? personality;
  final String? medicalInfo;
  final List<String>? photos;
  final bool available;

  const PetEntity({
    this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    this.vaccinated = false,
    this.description,
    this.personality,
    this.medicalInfo,
    this.photos,
    this.available = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    breed,
    age,
    gender,
    vaccinated,
    description,
    personality,
    medicalInfo,
    photos,
    available,
  ];

  // Add copyWith method
  PetEntity copyWith({
    String? id,
    String? name,
    String? breed,
    int? age,
    String? gender,
    bool? vaccinated,
    String? description,
    String? personality,
    String? medicalInfo,
    List<String>? photos,
    bool? available,
  }) {
    return PetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      vaccinated: vaccinated ?? this.vaccinated,
      description: description ?? this.description,
      personality: personality ?? this.personality,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      photos: photos ?? this.photos,
      available: available ?? this.available,
    );
  }
}
