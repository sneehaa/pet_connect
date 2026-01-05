import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_auth/data/repository/business_remote_repository.dart';
import 'package:pet_connect/features/business/business_auth/domain/repository/business_repository.dart';

final loginBusinessUseCaseProvider = Provider.autoDispose<LoginBusinessUseCase>(
  (ref) => LoginBusinessUseCase(ref.read(businessRemoteRepositoryProvider)),
);

class LoginBusinessUseCase {
  final BusinessRepository repository;
  LoginBusinessUseCase(this.repository);

  Future<Either<Failure, bool>> loginBusiness(
    String username,
    String password,
  ) async {
    return await repository.loginBusiness(username, password);
  }
}
