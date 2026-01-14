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
        ref.read(uploadProfileImageUseCaseProvider),
      ),
    );

class BusinessViewModel extends StateNotifier<BusinessState> {
  final RegisterBusinessUseCase _registerUseCase;
  final LoginBusinessUseCase _loginUseCase;
  final UploadDocumentsUseCase _uploadDocsUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;

  BusinessViewModel(
    this._registerUseCase,
    this._loginUseCase,
    this._uploadDocsUseCase,
    this._uploadProfileImageUseCase,
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

  Future<void> uploadProfileImage(String imagePath) async {
    state = state.copyWith(isLoading: true, clearMessage: true);

    final result = await _uploadProfileImageUseCase.execute(imagePath);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.error,
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isError: false,
        message: "Profile image uploaded successfully",
      ),
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

  /// Reset state
  void reset() {
    state = BusinessState.initial();
  }
}
