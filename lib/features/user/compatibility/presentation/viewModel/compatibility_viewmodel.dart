import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/user/compatibility/domain/usecase/compatibility_usecase.dart';

import '../state/compatibility_state.dart';

final compatibilityUseCasesProvider =
    Provider.autoDispose<CompatibilityUseCases>((ref) {
      return CompatibilityUseCases(
        submitQuestionnaire: ref.read(submitQuestionnaireUseCaseProvider),
        getQuestionnaire: ref.read(getQuestionnaireUseCaseProvider),
        getCompatibilityWithPet: ref.read(
          getCompatibilityWithPetUseCaseProvider,
        ),
        getCompatibilityAll: ref.read(getCompatibilityAllUseCaseProvider),
        deleteQuestionnaire: ref.read(deleteQuestionnaireUseCaseProvider),
      );
    });

class CompatibilityUseCases {
  final SubmitQuestionnaireUseCase submitQuestionnaire;
  final GetQuestionnaireUseCase getQuestionnaire;
  final GetCompatibilityWithPetUseCase getCompatibilityWithPet;
  final GetCompatibilityAllUseCase getCompatibilityAll;
  final DeleteQuestionnaireUseCase deleteQuestionnaire;

  CompatibilityUseCases({
    required this.submitQuestionnaire,
    required this.getQuestionnaire,
    required this.getCompatibilityWithPet,
    required this.getCompatibilityAll,
    required this.deleteQuestionnaire,
  });
}

final compatibilityViewModelProvider =
    StateNotifierProvider<CompatibilityViewModel, CompatibilityState>((ref) {
      return CompatibilityViewModel(ref.read(compatibilityUseCasesProvider));
    });

class CompatibilityViewModel extends StateNotifier<CompatibilityState> {
  final CompatibilityUseCases _useCases;

  CompatibilityViewModel(this._useCases) : super(const CompatibilityState());

  // Submit questionnaire
  Future<void> submitQuestionnaire(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(isLoading: true, message: null);
      final result = await _useCases.submitQuestionnaire.execute(data);

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            message: 'Failed to submit questionnaire: ${failure.error}',
          );
        },
        (questionnaire) {
          state = state.copyWith(
            isLoading: false,
            questionnaire: questionnaire,
            message: 'Questionnaire saved successfully',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        message: 'Error submitting questionnaire: $e',
      );
    }
  }

  // Get user's questionnaire
  Future<void> getQuestionnaire() async {
    try {
      state = state.copyWith(isLoading: true, message: null);
      final result = await _useCases.getQuestionnaire.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            message: 'No questionnaire found. Please complete one first.',
          );
        },
        (questionnaire) {
          state = state.copyWith(
            isLoading: false,
            questionnaire: questionnaire,
            message: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        message: 'Error loading questionnaire: $e',
      );
    }
  }

  // Get compatibility with specific pet
  Future<void> getCompatibilityWithPet(String petId) async {
    try {
      state = state.copyWith(isLoading: true, message: null);
      final result = await _useCases.getCompatibilityWithPet.execute(petId);

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            message: 'Failed to calculate compatibility: ${failure.error}',
          );
        },
        (compatibility) {
          state = state.copyWith(
            isLoading: false,
            selectedCompatibility: compatibility,
            message: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        message: 'Error calculating compatibility: $e',
      );
    }
  }

  // Get compatibility with all pets
  Future<void> getCompatibilityAll({int limit = 50, int page = 1}) async {
    try {
      state = state.copyWith(
        status: CompatibilityStatus.loading,
        message: null,
      );

      final result = await _useCases.getCompatibilityAll.execute(
        limit: limit,
        page: page,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            status: CompatibilityStatus.error,
            message: 'Failed to load compatibility scores: ${failure.error}',
          );
        },
        (results) {
          state = state.copyWith(
            status: CompatibilityStatus.loaded,
            compatibilityResults: results,
            message: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: CompatibilityStatus.error,
        message: 'Error loading compatibility scores: $e',
      );
    }
  }

  // Delete questionnaire
  Future<void> deleteQuestionnaire() async {
    try {
      state = state.copyWith(isLoading: true, message: null);
      final result = await _useCases.deleteQuestionnaire.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            message: 'Failed to delete questionnaire: ${failure.error}',
          );
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            questionnaire: null,
            compatibilityResults: [],
            selectedCompatibility: null,
            message: 'Questionnaire deleted successfully',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        message: 'Error deleting questionnaire: $e',
      );
    }
  }

  // Clear selected compatibility
  void clearSelectedCompatibility() {
    state = state.copyWith(selectedCompatibility: null);
  }

  // Clear message
  void clearMessage() {
    state = state.copyWith(message: null);
  }
}
