import 'package:equatable/equatable.dart';

class UserPetEntity extends Equatable {
  final String? id;
  final String name;
  final String breed;
  final int age;
  final String gender;
  final bool vaccinated;
  final String? description;
  final String? personality;
  final String? medicalInfo;
  final List<String> photos;
  final String businessId;
  final bool available;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserPetEntity({
    this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    this.vaccinated = false,
    this.description,
    this.personality,
    this.medicalInfo,
    this.photos = const [],
    required this.businessId,
    this.available = true,
    this.createdAt,
    this.updatedAt,
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
    businessId,
    available,
    createdAt,
    updatedAt,
  ];

  UserPetEntity copyWith({
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
    String? businessId,
    bool? available,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPetEntity(
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
      businessId: businessId ?? this.businessId,
      available: available ?? this.available,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserPetEntity.fromJson(Map<String, dynamic> json) {
    return UserPetEntity(
      id: json['_id'],
      name: json['name'],
      breed: json['breed'],
      age: json['age'],
      gender: json['gender'],
      vaccinated: json['vaccinated'] ?? false,
      description: json['description'],
      personality: json['personality'],
      medicalInfo: json['medicalInfo'],
      photos: List<String>.from(json['photos'] ?? []),
      businessId: json['businessId'],
      available: json['available'] ?? true,
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
      'name': name,
      'breed': breed,
      'age': age,
      'gender': gender,
      'vaccinated': vaccinated,
      'description': description,
      'personality': personality,
      'medicalInfo': medicalInfo,
      'photos': photos,
      'businessId': businessId,
      'available': available,
    };
  }
}
