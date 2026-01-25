import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/use_cases/adoption_usecases.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/state/adoption_state.dart';

final adoptionViewModelProvider =
    StateNotifierProvider.autoDispose<AdoptionViewModel, BusinessAdoptionState>(
      (ref) {
        return AdoptionViewModel(
          getPetAdoptionsUseCase: ref.read(getPetAdoptionsUseCaseProvider),
          approveAdoptionUseCase: ref.read(approveAdoptionUseCaseProvider),
          rejectAdoptionUseCase: ref.read(rejectAdoptionUseCaseProvider),
          getAdoptionByIdUseCase: ref.read(getAdoptionByIdUseCaseProvider),
          updateAdoptionStatusUseCase: ref.read(
            updateAdoptionStatusUseCaseProvider,
          ),
          getBusinessAdoptionsUseCase: ref.read(
            getBusinessAdoptionsUseCaseProvider,
          ),
        );
      },
    );

class AdoptionViewModel extends StateNotifier<BusinessAdoptionState> {
  final GetPetAdoptionsUseCase _getPetAdoptionsUseCase;
  final ApproveAdoptionUseCase _approveAdoptionUseCase;
  final RejectAdoptionUseCase _rejectAdoptionUseCase;
  final GetAdoptionByIdUseCase _getAdoptionByIdUseCase;
  final UpdateAdoptionStatusUseCase _updateAdoptionStatusUseCase;
  final GetBusinessAdoptionsUseCase _getBusinessAdoptionsUseCase;

  AdoptionViewModel({
    required GetPetAdoptionsUseCase getPetAdoptionsUseCase,
    required ApproveAdoptionUseCase approveAdoptionUseCase,
    required RejectAdoptionUseCase rejectAdoptionUseCase,
    required GetAdoptionByIdUseCase getAdoptionByIdUseCase,
    required UpdateAdoptionStatusUseCase updateAdoptionStatusUseCase,
    required GetBusinessAdoptionsUseCase getBusinessAdoptionsUseCase,
  }) : _getPetAdoptionsUseCase = getPetAdoptionsUseCase,
       _approveAdoptionUseCase = approveAdoptionUseCase,
       _rejectAdoptionUseCase = rejectAdoptionUseCase,
       _getAdoptionByIdUseCase = getAdoptionByIdUseCase,
       _updateAdoptionStatusUseCase = updateAdoptionStatusUseCase,
       _getBusinessAdoptionsUseCase = getBusinessAdoptionsUseCase,
       super(const BusinessAdoptionState());

  Future<void> getPetAdoptions(String petId) async {
    state = state.copyWith(
      isLoading: true,
      status: BusinessAdoptionStatus.loading,
    );

    final result = await _getPetAdoptionsUseCase.execute(petId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: BusinessAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoptions) {
        state = state.copyWith(
          isLoading: false,
          status: BusinessAdoptionStatus.loaded,
          adoptions: adoptions,
          message: 'Loaded ${adoptions.length} applications',
        );
      },
    );
  }

  // ADD THIS METHOD: Get all adoptions for the business
  Future<void> getBusinessAdoptions() async {
    state = state.copyWith(
      isLoading: true,
      status: BusinessAdoptionStatus.loading,
    );

    final result = await _getBusinessAdoptionsUseCase.execute();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: BusinessAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoptions) {
        state = state.copyWith(
          isLoading: false,
          status: BusinessAdoptionStatus.loaded,
          adoptions: adoptions,
          message: 'Loaded ${adoptions.length} adoption requests',
        );
      },
    );
  }

  // FIXED: Renamed to approveAdoption
  Future<void> approveAdoption(String adoptionId) async {
    state = state.copyWith(isLoading: true);

    final result = await _approveAdoptionUseCase.execute(adoptionId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: BusinessAdoptionStatus.error,
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
          message: 'Adoption application approved successfully',
        );
      },
    );
  }

  // FIXED: Renamed to rejectAdoption
  Future<void> rejectAdoption(String adoptionId, String reason) async {
    state = state.copyWith(isLoading: true);

    final result = await _rejectAdoptionUseCase.execute(adoptionId, reason);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: BusinessAdoptionStatus.error,
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
          message: 'Adoption application rejected',
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
          status: BusinessAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoption) {
        state = state.copyWith(isLoading: false, currentAdoption: adoption);
      },
    );
  }

  // FIXED: Renamed to updateAdoptionStatus
  Future<void> updateAdoptionStatus(
    String adoptionId,
    String status,
    String? rejectionReason,
  ) async {
    state = state.copyWith(isLoading: true);

    final result = await _updateAdoptionStatusUseCase.execute(
      adoptionId,
      status,
      rejectionReason,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: BusinessAdoptionStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (adoption) {
        final updatedAdoptions = state.adoptions.map((a) {
          return a.id == adoption.id ? adoption : a;
        }).toList();

        state = state.copyWith(
          isLoading: false,
          adoptions: updatedAdoptions,
          currentAdoption: adoption,
          message: status == 'approved'
              ? 'Application approved'
              : 'Application rejected',
        );
      },
    );
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
