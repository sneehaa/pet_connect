import 'package:pet_connect/features/user/adoption/domain/entity/adoption_entity.dart';

enum UserAdoptionStatus { initial, loading, loaded, error }

class UserAdoptionState {
  final UserAdoptionStatus status;
  final List<UserAdoptionEntity> adoptions;
  final UserAdoptionEntity? currentAdoption;
  final String? message;
  final bool isLoading;
  final Map<String, dynamic>? applicationFormData;

  const UserAdoptionState({
    this.status = UserAdoptionStatus.initial,
    this.adoptions = const [],
    this.currentAdoption,
    this.message,
    this.isLoading = false,
    this.applicationFormData,
  });

  UserAdoptionState copyWith({
    UserAdoptionStatus? status,
    List<UserAdoptionEntity>? adoptions,
    UserAdoptionEntity? currentAdoption,
    String? message,
    bool? isLoading,
    Map<String, dynamic>? applicationFormData,
  }) {
    return UserAdoptionState(
      status: status ?? this.status,
      adoptions: adoptions ?? this.adoptions,
      currentAdoption: currentAdoption ?? this.currentAdoption,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      applicationFormData: applicationFormData ?? this.applicationFormData,
    );
  }
}
