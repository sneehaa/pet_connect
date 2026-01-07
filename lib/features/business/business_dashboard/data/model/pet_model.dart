import '../../domain/entity/pet_entity.dart';

class PetModel extends PetEntity {
  // Add localPhotos for new uploads
  final List<String>? localPhotos;

  const PetModel({
    super.id,
    required super.name,
    required super.breed,
    required super.age,
    required super.gender,
    super.vaccinated,
    super.description,
    super.personality,
    super.medicalInfo,
    super.photos, 
    this.localPhotos,
    super.available,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
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
      available: json['available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "breed": breed,
      "age": age,
      "gender": gender,
      "vaccinated": vaccinated,
      "description": description,
      "personality": personality,
      "medicalInfo": medicalInfo,
      "photos":
          localPhotos ??
          photos,
      "available": available,
    };
  }
}
