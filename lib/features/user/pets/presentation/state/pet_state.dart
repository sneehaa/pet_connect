import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

enum PetStatus { initial, loading, loaded, error }

class PetState {
  final PetStatus status;
  final List<UserPetEntity> pets;
  final UserPetEntity? selectedPet;
  final String? message;
  final bool isLoading;
  final List<String> availableBreeds;
  final List<String> availableGenders;
  final Map<String, dynamic> filters;

  const PetState({
    this.status = PetStatus.initial,
    this.pets = const [],
    this.selectedPet,
    this.message,
    this.isLoading = false,
    this.availableBreeds = const [],
    this.availableGenders = const ['Male', 'Female'],
    this.filters = const {
      'query': '',
      'breed': '',
      'gender': '',
      'minAge': null,
      'maxAge': null,
      'vaccinated': null,
      'status': 'available',
    },
  });

  PetState copyWith({
    PetStatus? status,
    List<UserPetEntity>? pets,
    UserPetEntity? selectedPet,
    String? message,
    bool? isLoading,
    List<String>? availableBreeds,
    List<String>? availableGenders,
    Map<String, dynamic>? filters,
  }) {
    return PetState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      selectedPet: selectedPet ?? this.selectedPet,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      availableBreeds: availableBreeds ?? this.availableBreeds,
      availableGenders: availableGenders ?? this.availableGenders,
      filters: filters ?? this.filters,
    );
  }
}
