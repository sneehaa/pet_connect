import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/profile/domain/entity/profile_entity.dart';

abstract class UserProfileRepository {
  // Get user profile
  Future<Either<Failure, UserProfileEntity>> getUserProfile();

  // Update user profile
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
    UserProfileEntity profile,
  );

  // Change password
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // Delete account
  Future<Either<Failure, bool>> deleteAccount();
}
