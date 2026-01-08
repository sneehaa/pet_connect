import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/use_cases/pets_use_case.dart';

import '../state/pet_state.dart';

final petUseCasesProvider = Provider.autoDispose<PetUseCases>((ref) {
  return PetUseCases(
    getPets: ref.read(getPetsUseCaseProvider),
    addPet: ref.read(addPetUseCaseProvider),
    updatePet: ref.read(updatePetUseCaseProvider),
    deletePet: ref.read(deletePetUseCaseProvider),
    changePetStatus: ref.read(changePetStatusUseCaseProvider),
  );
});

class PetUseCases {
  final GetPetsUseCase getPets;
  final AddPetUseCase addPet;
  final UpdatePetUseCase updatePet;
  final DeletePetUseCase deletePet;
  final ChangePetStatusUseCase changePetStatus;

  PetUseCases({
    required this.getPets,
    required this.addPet,
    required this.updatePet,
    required this.deletePet,
    required this.changePetStatus,
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

  Future<void> loadPets(String businessId) async {
    state = state.copyWith(status: PetStatus.loading, message: null);
    final result = await _useCases.getPets.execute(businessId);

    result.fold(
      (failure) {
        print('Failed to load pets: ${failure.error}');
        state = state.copyWith(status: PetStatus.error, message: failure.error);
      },
      (pets) {
        print('Successfully loaded ${pets.length} pets');
        state = state.copyWith(
          status: PetStatus.loaded,
          pets: pets,
          message: null,
        );
      },
    );
  }

  Future<void> addPet(PetEntity pet, List<String>? photoPaths) async {
    state = state.copyWith(status: PetStatus.loading, message: null);
    final result = await _useCases.addPet.execute(pet, photoPaths);
    result.fold(
      (failure) => state = state.copyWith(
        status: PetStatus.error,
        message: failure.error,
      ),
      (newPet) {
        final updated = List<PetEntity>.from(state.pets)..add(newPet);
        state = state.copyWith(
          status: PetStatus.loaded,
          pets: updated,
          message: 'Pet added successfully!',
        );
      },
    );
  }

  /// Update existing pet
  Future<void> updatePet(
    PetEntity pet,
    List<String>? photoPaths,
    String petId,
  ) async {
    state = state.copyWith(status: PetStatus.loading, message: null);
    final result = await _useCases.updatePet.execute(pet, photoPaths, petId);
    result.fold(
      (failure) => state = state.copyWith(
        status: PetStatus.error,
        message: failure.error,
      ),
      (updatedPet) {
        final updated = state.pets
            .map((p) => p.id == updatedPet.id ? updatedPet : p)
            .toList();
        state = state.copyWith(
          status: PetStatus.loaded,
          pets: updated,
          message: 'Pet updated successfully!',
        );
      },
    );
  }

  /// Delete pet
  Future<void> deletePet(String petId) async {
    state = state.copyWith(status: PetStatus.loading, message: null);
    final result = await _useCases.deletePet.execute(petId);
    result.fold(
      (failure) => state = state.copyWith(
        status: PetStatus.error,
        message: failure.error,
      ),
      (success) {
        if (success) {
          final updated = state.pets.where((p) => p.id != petId).toList();
          state = state.copyWith(status: PetStatus.loaded, pets: updated);
        } else {
          state = state.copyWith(
            status: PetStatus.error,
            message: 'Failed to delete pet',
          );
        }
      },
    );
  }

  /// Change availability status
  Future<void> changeStatus(String petId, bool available) async {
    state = state.copyWith(status: PetStatus.loading, message: null);
    final result = await _useCases.changePetStatus.execute(petId, available);
    result.fold(
      (failure) => state = state.copyWith(
        status: PetStatus.error,
        message: failure.error,
      ),
      (success) {
        if (success) {
          final updated = state.pets
              .map((p) => p.id == petId ? p.copyWith(available: available) : p)
              .toList();
          state = state.copyWith(status: PetStatus.loaded, pets: updated);
        } else {
          state = state.copyWith(
            status: PetStatus.error,
            message: 'Failed to update pet status',
          );
        }
      },
    );
  }

  /// Reset state
  void reset() {
    state = const PetState();
  }
}
