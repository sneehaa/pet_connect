import '../../domain/entity/pet_entity.dart';

class PetModel extends PetEntity {
  const PetModel({
    String? id,
    required String name,
    required String breed,
    required int age,
    required String gender,
    bool vaccinated = false,
    String? description,
    String? personality,
    String? medicalInfo,
    List<String>? photos,
    bool available = true,
  }) : super(
          id: id,
          name: name,
          breed: breed,
          age: age,
          gender: gender,
          vaccinated: vaccinated,
          description: description,
          personality: personality,
          medicalInfo: medicalInfo,
          photos: photos,
          available: available,
        );

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
      "photos": photos,
      "available": available,
    };
  }
}
