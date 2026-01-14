import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/business/business_dashboard/data/repository/business_dashboard_repository.dart';

/// Provider for the DashboardViewModel
final dashboardViewModelProvider =
    StateNotifierProvider<DashboardViewModel, DashboardState>((ref) {
      return DashboardViewModel(ref);
    });

/// State class for dashboard/logout actions
class DashboardState {
  final bool isLoggingOut;
  final String? message;
  final bool logoutSuccess;

  const DashboardState({
    this.isLoggingOut = false,
    this.message,
    this.logoutSuccess = false,
  });

  DashboardState copyWith({
    bool? isLoggingOut,
    String? message,
    bool? logoutSuccess,
  }) {
    return DashboardState(
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      message: message,
      logoutSuccess: logoutSuccess ?? this.logoutSuccess,
    );
  }
}

/// ViewModel / StateNotifier
class DashboardViewModel extends StateNotifier<DashboardState> {
  final Ref _ref;

  DashboardViewModel(this._ref) : super(const DashboardState());

  /// Logout function
  Future<void> logout() async {
    state = state.copyWith(isLoggingOut: true, message: null);
    try {
      await _ref.read(businessDashboardRepositoryProvider).logout();
      state = state.copyWith(
        isLoggingOut: false,
        logoutSuccess: true,
        message: 'Logged out successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoggingOut: false,
        logoutSuccess: false,
        message: 'Logout failed: $e',
      );
    }
  }

  /// Reset state
  void reset() {
    state = const DashboardState();
  }
}
