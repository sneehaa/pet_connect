import 'package:flutter_riverpod/legacy.dart'; // Keep legacy for StateNotifierProvider
import 'package:pet_connect/auth/domain/use_cases/login_usecase.dart';
import 'package:pet_connect/auth/domain/use_cases/register_usecase.dart';

import '../../domain/entity/auth_entity.dart';
import '../state/auth_state.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    ref.read(registerUseCaseProvider),
    ref.read(loginUseCaseProvider),
  ),
);

class AuthViewModel extends StateNotifier<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;

  AuthViewModel(this._registerUseCase, this._loginUseCase)
    : super(AuthState.initial());

  Future<void> registerUser(AuthEntity entity) async {
    state = state.copyWith(isLoading: true, message: null, isError: false);

    final result = await _registerUseCase.registerUser(entity);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          message: failure.error,
          isError: true,
        );
      },
      (success) {
        if (success) {
          state = state.copyWith(
            isLoading: false,
            message: 'User Registered Successfully',
            isError: false,
          );
        } else {
          // Handle case where success is false (e.g., server returned false)
          state = state.copyWith(
            isLoading: false,
            message: 'Registration failed. Please try again.',
            isError: true,
          );
        }
      },
    );
  }

  Future<void> loginUser(String email, String password) async {
    state = state.copyWith(isLoading: true, message: null);

    final result = await _loginUseCase.loginUser(email, password);

    state = state.copyWith(isLoading: false);

    result.fold(
      (failure) {
        state = state.copyWith(message: failure.error, isError: true);
      },
      (success) {
        if (success) {
          state = state.copyWith(message: 'Login Successful', isError: false);
        } else {
          state = state.copyWith(
            message: 'Invalid username or password',
            isError: true,
          );
        }
      },
    );
  }

  void reset() {
    state = state.copyWith(
      isLoading: false,
      message: null,
      imageName: null,
      isError: false,
    );
  }
}
