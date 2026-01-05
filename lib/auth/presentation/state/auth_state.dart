class AuthState {
  final bool isLoading;
  final String? message;
  final bool isError;
  final String? imageName;

  AuthState({
    required this.isLoading,
    this.message,
    this.isError = false,
    this.imageName,
  });

  factory AuthState.initial() => AuthState(isLoading: false);

  AuthState copyWith({
    bool? isLoading,
    String? message,
    bool? isError,
    String? imageName,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      imageName: imageName ?? this.imageName,
    );
  }
}
