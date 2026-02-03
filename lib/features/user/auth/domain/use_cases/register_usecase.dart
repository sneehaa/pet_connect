import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/auth/domain/entity/auth_entity.dart';

import '../repository/auth_repository.dart';

final registerUseCaseProvider = Provider.autoDispose<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.read(authRepositoryProvider)),
);

class RegisterUseCase {
  final AuthRepository authRepository;
  RegisterUseCase(this.authRepository);

  Future<Either<Failure, bool>> registerUser(AuthEntity entity) async {
    return await authRepository.registerUser(entity);
  }
}

final verifyOtpUseCaseProvider = Provider.autoDispose<VerifyOtpUseCase>(
  (ref) => VerifyOtpUseCase(ref.read(authRepositoryProvider)),
);

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String email, String otp) async {
    return await repository.verifyOtp(email, otp);
  }
}

final resendOtpUseCaseProvider = Provider.autoDispose<ResendOtpUseCase>(
  (ref) => ResendOtpUseCase(ref.read(authRepositoryProvider)),
);

class ResendOtpUseCase {
  final AuthRepository repository;
  ResendOtpUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String email) async {
    return await repository.resendOtp(email);
  }
}


