import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/adoption/domain/usecase/adoption_usecase.dart';
import 'package:pet_connect/features/user/adoption/presentation/state/adoption_state.dart';

final userAdoptionViewModelProvider =
    StateNotifierProvider.autoDispose<UserAdoptionViewModel, UserAdoptionState>(
      (ref) {
        return UserAdoptionViewModel(
          applyAdoptionUseCase: ref.read(applyAdoptionUseCaseProvider),
          getAdoptionStatusUseCase: ref.read(getAdoptionStatusUseCaseProvider),
          getAdoptionHistoryUseCase: ref.read(
            getAdoptionHistoryUseCaseProvider,
          ),
          getAdoptionByIdUseCase: ref.read(getAdoptionByIdUseCaseProvider),
          markAdoptionPaidUseCase: ref.read(markAdoptionPaidUseCaseProvider),
        );
      },
    );

class UserAdoptionViewModel extends StateNotifier<UserAdoptionState> {
  final ApplyAdoptionUseCase _applyAdoptionUseCase;
  final GetAdoptionStatusUseCase _getAdoptionStatusUseCase;
  final GetAdoptionHistoryUseCase _getAdoptionHistoryUseCase;
  final GetAdoptionByIdUseCase _getAdoptionByIdUseCase;
  final MarkAdoptionPaidUseCase _markAdoptionPaidUseCase;

  UserAdoptionViewModel({
    required ApplyAdoptionUseCase applyAdoptionUseCase,
    required GetAdoptionStatusUseCase getAdoptionStatusUseCase,
    required GetAdoptionHistoryUseCase getAdoptionHistoryUseCase,
    required GetAdoptionByIdUseCase getAdoptionByIdUseCase,
    required MarkAdoptionPaidUseCase markAdoptionPaidUseCase,
  }) : _applyAdoptionUseCase = applyAdoptionUseCase,
       _getAdoptionStatusUseCase = getAdoptionStatusUseCase,
       _getAdoptionHistoryUseCase = getAdoptionHistoryUseCase,
       _getAdoptionByIdUseCase = getAdoptionByIdUseCase,
       _markAdoptionPaidUseCase = markAdoptionPaidUseCase,
       super(const UserAdoptionState());

  Future<void> applyForAdoption({
    required String petId,
    required Map<String, dynamic> applicationData,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _applyAdoptionUseCase.execute(
      petId: petId,
      applicationData: applicationData,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: UserAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoption) {
        // Add to adoptions list
        final updatedAdoptions = [adoption, ...state.adoptions];

        state = state.copyWith(
          isLoading: false,
          status: UserAdoptionStatus.loaded,
          adoptions: updatedAdoptions,
          currentAdoption: adoption,
          message: 'Adoption application submitted successfully!',
          applicationFormData: null,
        );
      },
    );
  }

  Future<void> getAdoptionStatus(String petId) async {
    state = state.copyWith(isLoading: true);

    final result = await _getAdoptionStatusUseCase.execute(petId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: UserAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoption) {
        state = state.copyWith(isLoading: false, currentAdoption: adoption);
      },
    );
  }

  Future<void> getAdoptionHistory() async {
    state = state.copyWith(isLoading: true, status: UserAdoptionStatus.loading);

    final result = await _getAdoptionHistoryUseCase.execute();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: UserAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoptions) {
        state = state.copyWith(
          isLoading: false,
          status: UserAdoptionStatus.loaded,
          adoptions: adoptions,
          message: 'Loaded ${adoptions.length} adoption records',
        );
      },
    );
  }

  Future<void> getAdoptionDetails(String adoptionId) async {
    state = state.copyWith(isLoading: true);

    final result = await _getAdoptionByIdUseCase.execute(adoptionId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: UserAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoption) {
        state = state.copyWith(isLoading: false, currentAdoption: adoption);
      },
    );
  }

  Future<void> markAdoptionAsPaid({
    required String adoptionId,
    required String paymentId,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _markAdoptionPaidUseCase.execute(
      adoptionId: adoptionId,
      paymentId: paymentId,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: UserAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoption) {
        // Update the adoption in the list
        final updatedAdoptions = state.adoptions.map((a) {
          return a.id == adoption.id ? adoption : a;
        }).toList();

        state = state.copyWith(
          isLoading: false,
          adoptions: updatedAdoptions,
          currentAdoption: adoption,
          message: 'Payment recorded successfully!',
        );
      },
    );
  }

  void updateApplicationFormData(Map<String, dynamic> formData) {
    state = state.copyWith(applicationFormData: formData);
  }

  void clearApplicationFormData() {
    state = state.copyWith(applicationFormData: null);
  }

  void clearCurrentAdoption() {
    state = state.copyWith(currentAdoption: null);
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  String _getErrorMessage(Failure failure) {
    return failure.error;
  }
}
