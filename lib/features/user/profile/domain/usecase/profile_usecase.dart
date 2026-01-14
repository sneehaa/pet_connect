import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/profile/data/repository/profile_remote_repository.dart';
import 'package:pet_connect/features/user/profile/domain/entity/profile_entity.dart';
import 'package:pet_connect/features/user/profile/domain/repository/profile_repository.dart';

// Get user profile use case
final getUserProfileUseCaseProvider =
    Provider.autoDispose<GetUserProfileUseCase>((ref) {
      return GetUserProfileUseCase(ref.read(userProfileRepositoryProvider));
    });

class GetUserProfileUseCase {
  final UserProfileRepository repository;
  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> execute() {
    return repository.getUserProfile();
  }
}

// Update user profile use case
final updateUserProfileUseCaseProvider =
    Provider.autoDispose<UpdateUserProfileUseCase>((ref) {
      return UpdateUserProfileUseCase(ref.read(userProfileRepositoryProvider));
    });

class UpdateUserProfileUseCase {
  final UserProfileRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> execute(
    UserProfileEntity profile,
  ) {
    return repository.updateUserProfile(profile);
  }
}

// Change password use case
final changePasswordUseCaseProvider =
    Provider.autoDispose<ChangePasswordUseCase>((ref) {
      return ChangePasswordUseCase(ref.read(userProfileRepositoryProvider));
    });

class ChangePasswordUseCase {
  final UserProfileRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, bool>> execute({
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}

// Delete account use case
final deleteAccountUseCaseProvider = Provider.autoDispose<DeleteAccountUseCase>(
  (ref) {
    return DeleteAccountUseCase(ref.read(userProfileRepositoryProvider));
  },
);

class DeleteAccountUseCase {
  final UserProfileRepository repository;
  DeleteAccountUseCase(this.repository);

  Future<Either<Failure, bool>> execute() {
    return repository.deleteAccount();
  }
}
