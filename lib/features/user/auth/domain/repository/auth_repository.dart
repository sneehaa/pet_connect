import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/features/user/auth/data/repository/auth_remote_repository.dart';
import 'package:pet_connect/features/user/auth/domain/entity/auth_entity.dart';

import '../../../../../../core/failure/failure.dart';

final authRepositoryProvider = Provider(
  (ref) => ref.read(authRemoteRepositoryProvider),
);

abstract class AuthRepository {
  Future<Either<Failure, bool>> registerUser(AuthEntity user);
  Future<Either<Failure, bool>> loginUser(String email, String password);
   Future<Either<Failure, bool>> verifyOtp(String email, String otp);
  Future<Either<Failure, bool>> resendOtp(String email);
}
