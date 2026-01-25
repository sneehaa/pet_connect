import '../../domain/entity/pet_entity.dart';

class PetModel extends PetEntity {
  const PetModel({
    super.id,
    required super.name,
    required super.breed,
    required super.age,
    required super.gender,
    required super.amount,
    super.vaccinated = false,
    super.description,
    super.personality,
    super.medicalInfo,
    super.photos,
    required super.businessId,
    super.status = "available",
    super.adoptedBy,
    super.adoptedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id'],
      name: json['name'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      amount: json['amount'] ?? 0,
      vaccinated: json['vaccinated'] ?? false,
      description: json['description'],
      personality: json['personality'],
      medicalInfo: json['medicalInfo'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
      businessId: json['businessId'] ?? '',
      status: json['status'] ?? 'available',
      adoptedBy: json['adoptedBy'],
      adoptedAt: json['adoptedAt'] != null
          ? DateTime.parse(json['adoptedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "breed": breed,
      "age": age,
      "gender": gender,
      "amount": amount,
      "vaccinated": vaccinated,
      "description": description,
      "personality": personality,
      "medicalInfo": medicalInfo,
      "photos": photos,
      "businessId": businessId,
      "status": status,
      "adoptedBy": adoptedBy,
      "adoptedAt": adoptedAt?.toIso8601String(),
    };
  }
}
