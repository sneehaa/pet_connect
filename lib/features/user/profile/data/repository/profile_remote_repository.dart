import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/profile/data/datasource/profile_remote_datasource.dart';
import 'package:pet_connect/features/user/profile/domain/entity/profile_entity.dart';
import 'package:pet_connect/features/user/profile/domain/repository/profile_repository.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(
    ref.read(userProfileRemoteDataSourceProvider),
  );
});

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource _remoteDataSource;

  UserProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() {
    return _remoteDataSource.getUserProfile();
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
    UserProfileEntity profile,
  ) {
    return _remoteDataSource.updateUserProfile(profile);
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<Either<Failure, bool>> deleteAccount() {
    return _remoteDataSource.deleteAccount();
  }
}
