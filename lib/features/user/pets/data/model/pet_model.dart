import '../../domain/entity/pet_entity.dart';

class UserPetModel extends UserPetEntity {
  const UserPetModel({
    required super.id,
    required super.name,
    required super.breed,
    required super.age,
    required super.gender,
    super.vaccinated,
    super.description,
    super.personality,
    super.medicalInfo,
    super.photos,
    required super.businessId,
    super.available,
    super.createdAt,
    super.updatedAt,
  });

  factory UserPetModel.fromJson(Map<String, dynamic> json) {
    return UserPetModel(
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

  @override
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
