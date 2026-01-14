import 'package:pet_connect/features/business/business_profile/domain/entity/business_profile_entity.dart';

enum BusinessProfileFlow {
  idle,
  loading,
  loaded,
  creating,
  created,
  updating,
  updated,
  error,
}

class BusinessProfileState {
  final BusinessProfileFlow flow;
  final BusinessProfileEntity? profile;
  final bool isLoading;
  final bool isError;
  final String? message;
  final String? error;

  BusinessProfileState({
    this.flow = BusinessProfileFlow.idle,
    this.profile,
    this.isLoading = false,
    this.isError = false,
    this.message,
    this.error,
  });

  factory BusinessProfileState.initial() => BusinessProfileState(
    flow: BusinessProfileFlow.idle,
    isLoading: false,
    isError: false,
  );

  BusinessProfileState copyWith({
    BusinessProfileFlow? flow,
    BusinessProfileEntity? profile,
    bool? isLoading,
    bool? isError,
    String? message,
    String? error,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return BusinessProfileState(
      flow: flow ?? this.flow,
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
