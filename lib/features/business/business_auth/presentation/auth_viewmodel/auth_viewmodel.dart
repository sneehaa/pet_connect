import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';
import 'package:pet_connect/features/business/business_auth/domain/use_cases/login_usecase.dart';
import 'package:pet_connect/features/business/business_auth/domain/use_cases/register_usecase.dart';


import '../state/auth_state.dart';

final businessAuthViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>(
      (ref) => AuthViewModel(
        ref.read(registerBusinessUseCaseProvider),
        ref.read(loginBusinessUseCaseProvider),
      ),
    );

class AuthViewModel extends StateNotifier<AuthState> {
  final RegisterBusinessUseCase _registerUseCase;
  final LoginBusinessUseCase _loginUseCase;

  AuthViewModel(this._registerUseCase, this._loginUseCase)
    : super(AuthState.initial());

  Future<void> registerBusiness(BusinessEntity entity) async {
    state = AuthState.initial().copyWith(isLoading: true);

    final result = await _registerUseCase.registerBusiness(entity);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        message: failure.error,
        isError: true,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: success
            ? 'Business Registered Successfully'
            : 'Registration failed',
        isError: !success,
      ),
    );
  }

  Future<void> loginBusiness(String username, String password) async {
    state = state.copyWith(isLoading: true, message: null);

    final result = await _loginUseCase.loginBusiness(username, password);

    state = state.copyWith(isLoading: false);

    result.fold(
      (failure) =>
          state = state.copyWith(message: failure.error, isError: true),
      (success) => state = state.copyWith(
        message: success ? 'Login Successful' : 'Invalid username or password',
        isError: !success,
      ),
    );
  }

  void reset() {
    state = AuthState.initial();
  }
}
