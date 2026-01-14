import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/business/business_profile/domain/entity/business_profile_entity.dart';
import 'package:pet_connect/features/business/business_profile/domain/usecase/business_profile_usecase.dart';
import 'package:pet_connect/features/business/business_profile/presentation/state/business_profile_state.dart';

final businessProfileViewModelProvider =
    StateNotifierProvider<BusinessProfileViewModel, BusinessProfileState>(
      (ref) => BusinessProfileViewModel(
        ref.read(getBusinessProfileUseCaseProvider),
        ref.read(createBusinessProfileUseCaseProvider),
        ref.read(updateBusinessProfileUseCaseProvider),
        ref.read(getBusinessDetailsUseCaseProvider),
        ref.read(uploadDocumentsUseCaseProvider),
      ),
    );

class BusinessProfileViewModel extends StateNotifier<BusinessProfileState> {
  final GetBusinessProfileUseCase _getProfileUseCase;
  final CreateBusinessProfileUseCase _createProfileUseCase;
  final UpdateBusinessProfileUseCase _updateProfileUseCase;
  final GetBusinessDetailsUseCase _getDetailsUseCase;
  final UploadDocumentsUseCase _uploadDocsUseCase;

  BusinessProfileViewModel(
    this._getProfileUseCase,
    this._createProfileUseCase,
    this._updateProfileUseCase,
    this._getDetailsUseCase,
    this._uploadDocsUseCase,
  ) : super(BusinessProfileState.initial());

  /// Get current business profile
  Future<void> getMyProfile() async {
    state = state.copyWith(
      isLoading: true,
      isError: false,
      clearMessage: true,
      clearError: true,
    );

    final result = await _getProfileUseCase.execute();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          error: failure.error,
        );
      },
      (profile) {
        state = state.copyWith(
          isLoading: false,
          isError: false,
          flow: BusinessProfileFlow.loaded,
          profile: profile,
          message: 'Profile loaded successfully',
        );
      },
    );
  }

  /// Create business profile
  Future<void> createProfile(BusinessProfileEntity profile) async {
    state = state.copyWith(
      isLoading: true,
      isError: false,
      flow: BusinessProfileFlow.creating,
      clearMessage: true,
      clearError: true,
    );

    final result = await _createProfileUseCase.execute(profile);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          error: failure.error,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          isError: false,
          flow: BusinessProfileFlow.created,
          profile: profile,
          message: 'Profile created successfully',
        );
      },
    );
  }

  /// Update business profile
  Future<void> updateProfile(BusinessProfileEntity profile) async {
    state = state.copyWith(
      isLoading: true,
      isError: false,
      flow: BusinessProfileFlow.updating,
      clearMessage: true,
      clearError: true,
    );

    final result = await _updateProfileUseCase.execute(profile);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          error: failure.error,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          isError: false,
          flow: BusinessProfileFlow.updated,
          profile: profile,
          message: 'Profile updated successfully',
        );
      },
    );
  }

  /// Get business details (public)
  Future<void> getBusinessDetails(String businessId) async {
    state = state.copyWith(
      isLoading: true,
      isError: false,
      clearMessage: true,
      clearError: true,
    );

    final result = await _getDetailsUseCase.execute(businessId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          error: failure.error,
        );
      },
      (profile) {
        state = state.copyWith(
          isLoading: false,
          isError: false,
          flow: BusinessProfileFlow.loaded,
          profile: profile,
        );
      },
    );
  }

  /// Upload documents (reusing from auth)
  Future<void> uploadDocuments(List<String> filePaths) async {
    state = state.copyWith(
      isLoading: true,
      isError: false,
      clearMessage: true,
      clearError: true,
    );

    final result = await _uploadDocsUseCase.execute(filePaths);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          error: failure.error,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          isError: false,
          flow: BusinessProfileFlow.loaded,
          message: 'Documents uploaded successfully',
        );
        // Refresh profile to get updated documents
        getMyProfile();
      },
    );
  }

  /// Reset state
  void reset() {
    state = BusinessProfileState.initial();
  }
}
