import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/user/pets/domain/usecase/pet_usecase.dart';

import '../state/pet_state.dart';

final petUseCasesProvider = Provider.autoDispose<PetUseCases>((ref) {
  return PetUseCases(
    getAllPets: ref.read(getAllPetsUseCaseProvider),
    getPetById: ref.read(getPetByIdUseCaseProvider),
    getPetsByBusiness: ref.read(getPetsByBusinessUseCaseProvider),
  );
});

class PetUseCases {
  final GetAllPetsUseCase getAllPets;
  final GetPetByIdUseCase getPetById;
  final GetPetsByBusinessUseCase getPetsByBusiness;

  PetUseCases({
    required this.getAllPets,
    required this.getPetById,
    required this.getPetsByBusiness,
  });
}

final petViewModelProvider = StateNotifierProvider<PetViewModel, PetState>((
  ref,
) {
  return PetViewModel(ref.read(petUseCasesProvider));
});

class PetViewModel extends StateNotifier<PetState> {
  final PetUseCases _useCases;

  PetViewModel(this._useCases) : super(const PetState());

  // Load all pets
  Future<void> loadAllPets() async {
    try {
      state = state.copyWith(status: PetStatus.loading, message: null);
      final result = await _useCases.getAllPets.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            status: PetStatus.error,
            message: 'Failed to load pets: ${failure.error}',
          );
        },
        (pets) {
          // Extract unique breeds for filter options
          final breeds = pets.map((pet) => pet.breed).toSet().toList();

          state = state.copyWith(
            status: PetStatus.loaded,
            pets: pets,
            availableBreeds: breeds,
            message: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(status: PetStatus.error, message: 'Error: $e');
    }
  }

  // Get pet by ID
  Future<void> getPetById(String petId) async {
    try {
      state = state.copyWith(isLoading: true, message: null);
      final result = await _useCases.getPetById.execute(petId);

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            message: 'Failed to load pet: ${failure.error}',
          );
        },
        (pet) {
          state = state.copyWith(
            isLoading: false,
            selectedPet: pet,
            message: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, message: 'Error: $e');
    }
  }

  // Load pets by business
  Future<void> loadPetsByBusiness(String businessId) async {
    try {
      state = state.copyWith(status: PetStatus.loading, message: null);
      final result = await _useCases.getPetsByBusiness.execute(businessId);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: PetStatus.error,
            message: 'Failed to load business pets: ${failure.error}',
          );
        },
        (pets) {
          state = state.copyWith(
            status: PetStatus.loaded,
            pets: pets,
            message: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(status: PetStatus.error, message: 'Error: $e');
    }
  }

  // Clear selected pet
  void clearSelectedPet() {
    state = state.copyWith(selectedPet: null);
  }

  // Clear message
  void clearMessage() {
    state = state.copyWith(message: null);
  }
}
