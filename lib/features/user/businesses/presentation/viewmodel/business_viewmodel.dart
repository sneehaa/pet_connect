import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/user/businesses/domain/usecase/business_usecase.dart';
import 'package:pet_connect/features/user/businesses/presentation/state/business_state.dart';

final businessViewModelProvider =
    StateNotifierProvider<BusinessViewModel, BusinessState>(
      (ref) => BusinessViewModel(ref.read(businessUseCasesProvider)),
    );

class BusinessViewModel extends StateNotifier<BusinessState> {
  final BusinessUseCases _businessUseCases;

  BusinessViewModel(this._businessUseCases) : super(BusinessState.initial());

  Future<void> getAllBusinesses() async {
    // Reset state first, then set loading
    state = BusinessState.initial();
    state = state.copyWith(isLoading: true);

    final result = await _businessUseCases.getAllBusinesses();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          message: failure.error,
          isError: true,
        );
      },
      (businesses) {
        state = state.copyWith(
          isLoading: false,
          businesses: businesses,
          isError: false,
        );
      },
    );
  }

  Future<void> getNearbyBusinesses({
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isLoadingNearby: true, message: null);

    final result = await _businessUseCases.getNearbyBusinesses(
      latitude: latitude,
      longitude: longitude,
    );

    state = state.copyWith(isLoadingNearby: false);

    result.fold(
      (failure) {
        state = state.copyWith(message: failure.error, isError: true);
      },
      (nearbyBusinesses) {
        state = state.copyWith(
          nearbyBusinesses: nearbyBusinesses,
          isError: false,
        );
      },
    );
  }

  Future<void> getBusinessById(String businessId) async {
    state = state.copyWith(isLoading: true, message: null);

    final result = await _businessUseCases.getBusinessById(businessId);

    state = state.copyWith(isLoading: false);

    result.fold(
      (failure) {
        state = state.copyWith(message: failure.error, isError: true);
      },
      (business) {
        state = state.copyWith(selectedBusiness: business, isError: false);
      },
    );
  }

  void clearSelectedBusiness() {
    state = state.copyWith(selectedBusiness: null);
  }

  void clearMessage() {
    state = state.copyWith(message: null, isError: false);
  }

  void reset() {
    state = BusinessState.initial();
  }
}
