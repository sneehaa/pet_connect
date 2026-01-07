import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';
import 'package:pet_connect/features/business/business_auth/presentation/state/auth_state.dart';

import '../../domain/use_cases/business_usecases.dart';

final businessViewModelProvider =
    StateNotifierProvider<BusinessViewModel, BusinessState>(
      (ref) => BusinessViewModel(
        ref.read(registerBusinessUseCaseProvider),
        ref.read(loginBusinessUseCaseProvider),
        ref.read(uploadDocumentsUseCaseProvider),
        ref.read(nearbyBusinessesUseCaseProvider),
      ),
    );

class BusinessViewModel extends StateNotifier<BusinessState> {
  final RegisterBusinessUseCase _registerUseCase;
  final LoginBusinessUseCase _loginUseCase;
  final UploadDocumentsUseCase _uploadDocsUseCase;
  final NearbyBusinessesUseCase _nearbyUseCase;

  BusinessViewModel(
    this._registerUseCase,
    this._loginUseCase,
    this._uploadDocsUseCase,
    this._nearbyUseCase,
  ) : super(BusinessState.initial());

  /// Register
  Future<void> registerBusiness(BusinessEntity entity) async {
    state = state.copyWith(isLoading: true, isError: false, clearMessage: true);

    final result = await _registerUseCase.execute(entity);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          message: failure.error,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          isError: false,
          flow: BusinessFlow.registered,
          message:
              'Business registered successfully. Please upload documents for verification.',
        );
      },
    );
  }

  /// Login
  Future<void> loginBusiness(String username, String password) async {
    state = state.copyWith(isLoading: true, isError: false, clearMessage: true);

    final result = await _loginUseCase.execute(username, password);

    result.fold(
      (failure) {
        if (failure.error.toLowerCase().contains('under review')) {
          state = state.copyWith(
            isLoading: false,
            isError: false,
            flow: BusinessFlow.pendingApproval,
            message: failure.error,
          );
          return;
        }
        state = state.copyWith(
          isLoading: false,
          isError: true,
          message: failure.error,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          isError: false,
          flow: BusinessFlow.loggedIn,
          message: 'Login successful',
        );
      },
    );
  }

  /// Upload documents
  Future<void> uploadDocuments(List<String> files) async {
    state = state.copyWith(isLoading: true, message: null);

    final result = await _uploadDocsUseCase.execute(files);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.error,
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isError: false,
        message:
            'Documents uploaded successfully. Please wait for Admin approval',
        flow: BusinessFlow.documentsUploaded,
      ),
    );
  }

  /// Get nearby businesses
  Future<void> getNearbyBusinesses(double lat, double lng) async {
    state = state.copyWith(isLoading: true, message: null);
    final result = await _nearbyUseCase.execute(lat, lng);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.error,
      ),
      (businesses) => state = state.copyWith(
        isLoading: false,
        isError: false,
        nearbyBusinesses: businesses,
      ),
    );
  }

  /// Reset state
  void reset() {
    state = BusinessState.initial();
  }
}
