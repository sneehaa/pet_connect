import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/auth/domain/repository/auth_repository.dart';
import 'package:pet_connect/core/failure/failure.dart';

final loginUseCaseProvider = Provider.autoDispose<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

class LoginUseCase {
  final AuthRepository authRepository;
  LoginUseCase(this.authRepository);

  Future<Either<Failure, bool>> loginUser(String email, String password) async {
    return await authRepository.loginUser(email, password);
  }
}
