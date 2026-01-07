enum BusinessFlow {
  idle,
  registered,
  documentsUploaded,
  pendingApproval,
  loggedIn,
}

class BusinessState {
  final bool isLoading;
  final bool isError;
  final String? message;
  final List<dynamic>? nearbyBusinesses;
  final BusinessFlow flow;

  BusinessState({
    required this.isLoading,
    this.isError = false,
    this.message,
    this.nearbyBusinesses,
    this.flow = BusinessFlow.idle,
  });

  factory BusinessState.initial() => BusinessState(isLoading: false);

  BusinessState copyWith({
    bool? isLoading,
    bool? isError,
    String? message,
    List<dynamic>? nearbyBusinesses,
    bool clearMessage = false,
    BusinessFlow? flow,
  }) {
    return BusinessState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: clearMessage ? null : (message ?? this.message),
      nearbyBusinesses: nearbyBusinesses ?? this.nearbyBusinesses,
      flow: flow ?? this.flow,
    );
  }
}
