import 'package:equatable/equatable.dart';

class PetEntity extends Equatable {
  final String? id;
  final String name;
  final String breed;
  final int age;
  final String gender;
  final int amount; 
  final bool vaccinated;
  final String? description;
  final String? personality;
  final String? medicalInfo;
  final List<String>? photos;
  final String businessId; 
  final String status; 
  final String? adoptedBy; 
  final DateTime? adoptedAt;

  const PetEntity({
    this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.amount,
    this.vaccinated = false,
    this.description,
    this.personality,
    this.medicalInfo,
    this.photos,
    required this.businessId,
    this.status = "available",
    this.adoptedBy,
    this.adoptedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    breed,
    age,
    gender,
    amount,
    vaccinated,
    description,
    personality,
    medicalInfo,
    photos,
    businessId,
    status,
    adoptedBy,
    adoptedAt,
  ];

  PetEntity copyWith({
    String? id,
    String? name,
    String? breed,
    int? age,
    String? gender,
    int? amount,
    bool? vaccinated,
    String? description,
    String? personality,
    String? medicalInfo,
    List<String>? photos,
    String? businessId,
    String? status,
    String? adoptedBy,
    DateTime? adoptedAt,
  }) {
    return PetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      amount: amount ?? this.amount,
      vaccinated: vaccinated ?? this.vaccinated,
      description: description ?? this.description,
      personality: personality ?? this.personality,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      photos: photos ?? this.photos,
      businessId: businessId ?? this.businessId,
      status: status ?? this.status,
      adoptedBy: adoptedBy ?? this.adoptedBy,
      adoptedAt: adoptedAt ?? this.adoptedAt,
    );
  }
}
