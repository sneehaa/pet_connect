enum AuthFlow {
  idle,
  sendingOtp,
  otpSent,
  verifyingOtp,
  authenticated,
  unauthenticated,
}

class AuthState {
  final bool isLoading;
  final String? message;
  final bool isError;
  final String? imageName;
  final String? contactInfo;
  final String? verificationId;
  final AuthFlow flow;

  AuthState({
    required this.isLoading,
    this.message,
    this.isError = false,
    this.imageName,
    this.contactInfo,
    this.verificationId,
    this.flow = AuthFlow.idle,
  });

  factory AuthState.initial() => AuthState(isLoading: false);

  AuthState copyWith({
    bool? isLoading,
    String? message,
    bool? isError,
    String? imageName,
    String? contactInfo,
    String? verificationId,
    AuthFlow? flow,
    bool clearMessage = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      message: clearMessage ? null : (message ?? this.message),
      isError: isError ?? this.isError,
      imageName: imageName ?? this.imageName,
      contactInfo: contactInfo ?? this.contactInfo,
      verificationId: verificationId ?? this.verificationId,
      flow: flow ?? this.flow,
    );
  }
}
