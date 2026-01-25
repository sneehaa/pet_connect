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
        ref.read(verifyOtpUseCaseProvider),
        ref.read(resendOtpUseCaseProvider),
      ),
    );

class BusinessViewModel extends StateNotifier<BusinessState> {
  final RegisterBusinessUseCase _registerUseCase;
  final LoginBusinessUseCase _loginUseCase;
  final UploadDocumentsUseCase _uploadDocsUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  BusinessViewModel(
    this._registerUseCase,
    this._loginUseCase,
    this._uploadDocsUseCase,
    this._uploadProfileImageUseCase,
    this._verifyOtpUseCase,
    this._resendOtpUseCase,
  ) : super(BusinessState.initial());

  Future<void> registerBusiness(BusinessEntity entity) async {
    state = state.copyWith(isLoading: true, isError: false, clearMessage: true);
    final result = await _registerUseCase.execute(entity);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.error,
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isError: false,
        email: entity.email,
        flow: BusinessFlow.needsOtp,
        message: 'OTP sent to ${entity.email}',
      ),
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (state.email == null) return;

    state = state.copyWith(isLoading: true, isError: false);
    final result = await _verifyOtpUseCase.execute(state.email!, otp);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.error,
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isError: false,
        flow: BusinessFlow.otpVerified,
        message: "Email verified! You can now upload your business documents.",
      ),
    );
  }

  Future<void> resendOtp() async {
    if (state.email == null) {
      state = state.copyWith(
        isError: true,
        message: "Email not found. Please register again.",
      );
      return;
    }

    state = state.copyWith(isLoading: true, isError: false, clearMessage: true);

    final result = await _resendOtpUseCase.execute(state.email!);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.error,
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isError: false,
        message: "A new verification code has been sent to ${state.email}",
      ),
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
