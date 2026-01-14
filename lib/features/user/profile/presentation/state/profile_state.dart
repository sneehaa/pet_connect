import 'package:pet_connect/features/user/profile/domain/entity/profile_entity.dart';

enum ProfileStatus { initial, loading, loaded, error }

enum PasswordStatus { initial, loading, success, error }

enum DeleteStatus { initial, loading, success, error }

class UserProfileState {
  final ProfileStatus profileStatus;
  final PasswordStatus passwordStatus;
  final DeleteStatus deleteStatus;
  final UserProfileEntity? userProfile;
  final String? message;
  final String? passwordMessage;
  final String? deleteMessage;
  final bool isLoading;
  final bool isUpdating;
  final bool isChangingPassword;
  final bool isDeleting;

  const UserProfileState({
    this.profileStatus = ProfileStatus.initial,
    this.passwordStatus = PasswordStatus.initial,
    this.deleteStatus = DeleteStatus.initial,
    this.userProfile,
    this.message,
    this.passwordMessage,
    this.deleteMessage,
    this.isLoading = false,
    this.isUpdating = false,
    this.isChangingPassword = false,
    this.isDeleting = false,
  });

  UserProfileState copyWith({
    ProfileStatus? profileStatus,
    PasswordStatus? passwordStatus,
    DeleteStatus? deleteStatus,
    UserProfileEntity? userProfile,
    String? message,
    String? passwordMessage,
    String? deleteMessage,
    bool? isLoading,
    bool? isUpdating,
    bool? isChangingPassword,
    bool? isDeleting,
  }) {
    return UserProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      userProfile: userProfile ?? this.userProfile,
      message: message ?? this.message,
      passwordMessage: passwordMessage ?? this.passwordMessage,
      deleteMessage: deleteMessage ?? this.deleteMessage,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}
