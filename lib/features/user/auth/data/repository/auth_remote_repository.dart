import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/auth/data/data_source/auth_remote_datasource.dart';
import 'package:pet_connect/features/user/auth/domain/entity/auth_entity.dart';
import 'package:pet_connect/features/user/auth/domain/repository/auth_repository.dart';

final authRemoteRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRemoteRepositoy(ref.read(authRemoteDataSourceProvider)),
);

class AuthRemoteRepositoy implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRemoteRepositoy(this._authRemoteDataSource);

  @override
  Future<Either<Failure, bool>> registerUser(AuthEntity user) async {
    return await _authRemoteDataSource.registerUser(user);
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String email, String otp) {
    return _authRemoteDataSource.verifyOtp(email, otp);
  }

  @override
  Future<Either<Failure, bool>> resendOtp(String email) {
    return _authRemoteDataSource.resendOtp(email);
  }

  //login
  @override
  Future<Either<Failure, bool>> loginUser(String email, String password) async {
    return await _authRemoteDataSource.loginUser(email, password);
  }
}
