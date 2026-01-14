import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/user/profile/domain/entity/profile_entity.dart';
import 'package:pet_connect/features/user/profile/domain/usecase/profile_usecase.dart';
import 'package:pet_connect/features/user/profile/presentation/state/profile_state.dart';


final userProfileUseCasesProvider = Provider.autoDispose<UserProfileUseCases>((
  ref,
) {
  return UserProfileUseCases(
    getUserProfile: ref.read(getUserProfileUseCaseProvider),
    updateUserProfile: ref.read(updateUserProfileUseCaseProvider),
    changePassword: ref.read(changePasswordUseCaseProvider),
    deleteAccount: ref.read(deleteAccountUseCaseProvider),
  );
});

class UserProfileUseCases {
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;
  final ChangePasswordUseCase changePassword;
  final DeleteAccountUseCase deleteAccount;

  UserProfileUseCases({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.changePassword,
    required this.deleteAccount,
  });
}

final userProfileViewModelProvider =
    StateNotifierProvider<UserProfileViewModel, UserProfileState>((ref) {
      return UserProfileViewModel(ref.read(userProfileUseCasesProvider));
    });

class UserProfileViewModel extends StateNotifier<UserProfileState> {
  final UserProfileUseCases _useCases;

  UserProfileViewModel(this._useCases) : super(const UserProfileState());

  // Load user profile
  Future<void> loadUserProfile() async {
    try {
      state = state.copyWith(
        profileStatus: ProfileStatus.loading,
        message: null,
        isLoading: true,
      );

      final result = await _useCases.getUserProfile.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            profileStatus: ProfileStatus.error,
            message: 'Failed to load profile: ${failure.error}',
            isLoading: false,
          );
        },
        (profile) {
          state = state.copyWith(
            profileStatus: ProfileStatus.loaded,
            userProfile: profile,
            message: null,
            isLoading: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        profileStatus: ProfileStatus.error,
        message: 'Error: $e',
        isLoading: false,
      );
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    try {
      state = state.copyWith(isUpdating: true, message: null);

      final result = await _useCases.updateUserProfile.execute(profile);

      result.fold(
        (failure) {
          state = state.copyWith(
            isUpdating: false,
            message: 'Failed to update profile: ${failure.error}',
          );
        },
        (updatedProfile) {
          state = state.copyWith(
            isUpdating: false,
            userProfile: updatedProfile,
            message: 'Profile updated successfully!',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(isUpdating: false, message: 'Error: $e');
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      state = state.copyWith(
        passwordStatus: PasswordStatus.loading,
        passwordMessage: null,
        isChangingPassword: true,
      );

      final result = await _useCases.changePassword.execute(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            passwordStatus: PasswordStatus.error,
            passwordMessage: 'Failed to change password: ${failure.error}',
            isChangingPassword: false,
          );
        },
        (success) {
          if (success) {
            state = state.copyWith(
              passwordStatus: PasswordStatus.success,
              passwordMessage: 'Password changed successfully!',
              isChangingPassword: false,
            );
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        passwordStatus: PasswordStatus.error,
        passwordMessage: 'Error: $e',
        isChangingPassword: false,
      );
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      state = state.copyWith(
        deleteStatus: DeleteStatus.loading,
        deleteMessage: null,
        isDeleting: true,
      );

      final result = await _useCases.deleteAccount.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            deleteStatus: DeleteStatus.error,
            deleteMessage: 'Failed to delete account: ${failure.error}',
            isDeleting: false,
          );
        },
        (success) {
          if (success) {
            state = state.copyWith(
              deleteStatus: DeleteStatus.success,
              deleteMessage: 'Account deleted successfully!',
              isDeleting: false,
            );
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        deleteStatus: DeleteStatus.error,
        deleteMessage: 'Error: $e',
        isDeleting: false,
      );
    }
  }

  // Clear messages
  void clearMessages() {
    state = state.copyWith(
      message: null,
      passwordMessage: null,
      deleteMessage: null,
    );
  }

  // Clear password status
  void clearPasswordStatus() {
    state = state.copyWith(
      passwordStatus: PasswordStatus.initial,
      passwordMessage: null,
    );
  }

  // Clear delete status
  void clearDeleteStatus() {
    state = state.copyWith(
      deleteStatus: DeleteStatus.initial,
      deleteMessage: null,
    );
  }

  // Reset state
  void reset() {
    state = const UserProfileState();
  }
}
