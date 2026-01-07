import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/use_cases/adoption_usecases.dart';

import '../state/adoption_state.dart';

// Create a unified Adoption UseCases provider
final adoptionUseCasesProvider = Provider.autoDispose<AdoptionUseCases>((ref) {
  return AdoptionUseCases(
    applyAdoption: ref.read(applyAdoptionUseCaseProvider),
    getAdoptionStatus: ref.read(getAdoptionStatusUseCaseProvider),
    getAdoptionHistory: ref.read(getAdoptionHistoryUseCaseProvider),
    getPetAdoptions: ref.read(getPetAdoptionsUseCaseProvider),
    updateAdoptionStatus: ref.read(updateAdoptionStatusUseCaseProvider),
  );
});

class AdoptionUseCases {
  final ApplyAdoptionUseCase applyAdoption;
  final GetAdoptionStatusUseCase getAdoptionStatus;
  final GetAdoptionHistoryUseCase getAdoptionHistory;
  final GetPetAdoptionsUseCase getPetAdoptions;
  final UpdateAdoptionStatusUseCase updateAdoptionStatus;

  AdoptionUseCases({
    required this.applyAdoption,
    required this.getAdoptionStatus,
    required this.getAdoptionHistory,
    required this.getPetAdoptions,
    required this.updateAdoptionStatus,
  });
}

final adoptionViewModelProvider =
    StateNotifierProvider<AdoptionViewModel, AdoptionState>((ref) {
      return AdoptionViewModel(ref.read(adoptionUseCasesProvider));
    });

class AdoptionViewModel extends StateNotifier<AdoptionState> {
  final AdoptionUseCases _useCases;

  AdoptionViewModel(this._useCases) : super(const AdoptionState());

  /// Apply for adoption
  Future<void> applyForAdoption(String petId, String message) async {
    state = state.copyWith(status: AdoptionStatus.loading, message: null);
    final result = await _useCases.applyAdoption.execute(petId, message);
    result.fold(
      (failure) => state = state.copyWith(
        status: AdoptionStatus.error,
        message: failure.error,
      ),
      (adoption) => state = state.copyWith(
        status: AdoptionStatus.loaded,
        currentAdoption: adoption,
        message: 'Adoption application submitted successfully!',
      ),
    );
  }

  /// Get adoption status for a pet
  Future<void> getAdoptionStatus(String petId) async {
    state = state.copyWith(status: AdoptionStatus.loading, message: null);
    final result = await _useCases.getAdoptionStatus.execute(petId);
    result.fold(
      (failure) => state = state.copyWith(
        status: AdoptionStatus.error,
        message: failure.error,
      ),
      (adoption) => state = state.copyWith(
        status: AdoptionStatus.loaded,
        currentAdoption: adoption,
      ),
    );
  }

  /// Get user's adoption history
  Future<void> getAdoptionHistory() async {
    state = state.copyWith(status: AdoptionStatus.loading, message: null);
    final result = await _useCases.getAdoptionHistory.execute();
    result.fold(
      (failure) => state = state.copyWith(
        status: AdoptionStatus.error,
        message: failure.error,
      ),
      (adoptions) => state = state.copyWith(
        status: AdoptionStatus.loaded,
        adoptions: adoptions,
      ),
    );
  }

  /// Get all adoptions for a pet (business view)
  Future<void> getPetAdoptions(String petId) async {
    state = state.copyWith(status: AdoptionStatus.loading, message: null);
    final result = await _useCases.getPetAdoptions.execute(petId);
    result.fold(
      (failure) => state = state.copyWith(
        status: AdoptionStatus.error,
        message: failure.error,
      ),
      (adoptions) => state = state.copyWith(
        status: AdoptionStatus.loaded,
        adoptions: adoptions,
      ),
    );
  }

  /// Update adoption status (business action)
  Future<void> updateAdoptionStatus(String adoptionId, String status) async {
    state = state.copyWith(status: AdoptionStatus.loading, message: null);
    final result = await _useCases.updateAdoptionStatus.execute(
      adoptionId,
      status,
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: AdoptionStatus.error,
        message: failure.error,
      ),
      (updatedAdoption) {
        final updated = state.adoptions
            .map((a) => a.id == updatedAdoption.id ? updatedAdoption : a)
            .toList();
        state = state.copyWith(
          status: AdoptionStatus.loaded,
          adoptions: updated,
          message: 'Adoption status updated to $status',
        );
      },
    );
  }

  /// Clear current adoption
  void clearCurrentAdoption() {
    state = state.copyWith(currentAdoption: null);
  }

  /// Reset state
  void reset() {
    state = const AdoptionState();
  }
}
