import 'package:equatable/equatable.dart';

class UserPetEntity extends Equatable {
  final String id;
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
  final int amount;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserPetEntity({
    required this.id,
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
    required this.amount,
    this.status = 'available',
    this.createdAt,
    this.updatedAt,
  });

  bool get available => status == 'available';
  bool get booked => status == 'booked';
  bool get adopted => status == 'adopted';

  bool get isAvailable => status == 'available';

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
    status,
    amount,
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
    int? amount,
    List<String>? photos,
    String? businessId,
    String? status, // Add status
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
      amount: amount ?? this.amount,
      description: description ?? this.description,
      personality: personality ?? this.personality,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      photos: photos ?? this.photos,
      businessId: businessId ?? this.businessId,
      status: status ?? this.status, // Copy status
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
      amount: json['amount'],
      photos: List<String>.from(json['photos'] ?? []),
      businessId: json['businessId'],
      status: json['status'] ?? 'available',
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
      'amount': amount,
      'personality': personality,
      'medicalInfo': medicalInfo,
      'photos': photos,
      'businessId': businessId,
      'status': status,
    };
  }
}
