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
  final String? email;
  final bool isError;
  final String? imageName;
  final AuthFlow flow;

  AuthState({
    required this.isLoading,
    this.message,
    this.email,
    this.isError = false,
    this.imageName,
    this.flow = AuthFlow.idle,
  });

  factory AuthState.initial() => AuthState(isLoading: false);

  AuthState copyWith({
    bool? isLoading,
    String? message,
    String? email,
    bool? isError,
    String? imageName,
    bool clearMessage = false,
    AuthFlow? flow,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      message: clearMessage ? null : (message ?? this.message),
      isError: isError ?? this.isError,
      email: email ?? this.email,
      imageName: imageName ?? this.imageName,
      flow: flow ?? this.flow,
    );
  }
}
