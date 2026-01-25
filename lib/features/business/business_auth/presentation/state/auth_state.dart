enum BusinessFlow {
  idle,
  registered,
  needsOtp,
  otpVerified, 
  documentsUploaded,
  pendingApproval,
  loggedIn,
}

class BusinessState {
  final bool isLoading;
  final bool isError;
  final String? message;
  final String? email;
  final List<dynamic>? nearbyBusinesses;
  final BusinessFlow flow;

  BusinessState({
    required this.isLoading,
    this.isError = false,
    this.message,
    this.email,
    this.nearbyBusinesses,
    this.flow = BusinessFlow.idle,
  });

  factory BusinessState.initial() => BusinessState(isLoading: false);

  BusinessState copyWith({
    bool? isLoading,
    bool? isError,
    String? message,
    String? email, 
    List<dynamic>? nearbyBusinesses,
    bool clearMessage = false,
    BusinessFlow? flow,
  }) {
    return BusinessState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: clearMessage ? null : (message ?? this.message),
      email: email ?? this.email, 
      nearbyBusinesses: nearbyBusinesses ?? this.nearbyBusinesses,
      flow: flow ?? this.flow,
    );
  }
}
