import 'package:flutter_riverpod/legacy.dart'; // Keep legacy for StateNotifierProvider
import 'package:pet_connect/features/user/auth/domain/use_cases/login_usecase.dart';
import 'package:pet_connect/features/user/auth/domain/use_cases/register_usecase.dart';

import '../../domain/entity/auth_entity.dart';
import '../state/auth_state.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    ref.read(registerUseCaseProvider),
    ref.read(loginUseCaseProvider),
    ref.read(verifyOtpUseCaseProvider),
    ref.read(resendOtpUseCaseProvider),
  ),
);

class AuthViewModel extends StateNotifier<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  AuthViewModel(
    this._registerUseCase,
    this._loginUseCase,
    this._verifyOtpUseCase,
    this._resendOtpUseCase,
  ) : super(AuthState.initial());

  Future<void> registerUser(AuthEntity entity) async {
    state = state.copyWith(isLoading: true, isError: false);

    final result = await _registerUseCase.registerUser(entity);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        message: failure.error,
        isError: true,
      ),
      (success) {
        state = state.copyWith(
          isLoading: false,
          message: 'OTP sent to your email',
          contactInfo: entity.email,
          flow: AuthFlow.otpSent,
          isError: false,
        );
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (state.contactInfo == null) return;

    state = state.copyWith(isLoading: true, isError: false);
    final result = await _verifyOtpUseCase.execute(state.contactInfo!, otp);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        message: failure.error,
        isError: true,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: 'Email Verified Successfully',
        flow: AuthFlow.authenticated, // Move to login or dashboard
        isError: false,
      ),
    );
  }

  Future<void> resendOtp() async {
    if (state.contactInfo == null) return;

    state = state.copyWith(isLoading: true);
    final result = await _resendOtpUseCase.execute(state.contactInfo!);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        message: failure.error,
        isError: true,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: 'OTP Resent Successfully',
        isError: false,
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    state = state.copyWith(isLoading: true, message: null);
    final result = await _loginUseCase.loginUser(email, password);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        message: failure.error,
        isError: true,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: 'Login Successful',
        flow: AuthFlow.authenticated,
        isError: false,
      ),
    );
  }

  void reset() => state = AuthState.initial();
}
