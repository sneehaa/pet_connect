import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

class BusinessState {
  final bool isLoading;
  final bool isLoadingNearby;
  final String? message;
  final bool isError;
  final List<BusinessEntity> businesses;
  final List<BusinessEntity> nearbyBusinesses;
  final BusinessEntity? selectedBusiness;

  const BusinessState({
    this.isLoading = false,
    this.isLoadingNearby = false,
    this.message,
    this.isError = false,
    this.businesses = const [],
    this.nearbyBusinesses = const [],
    this.selectedBusiness,
  });

  factory BusinessState.initial() {
    return const BusinessState(
      isLoading: false,
      isLoadingNearby: false,
      message: null,
      isError: false,
      businesses: [],
      nearbyBusinesses: [],
      selectedBusiness: null,
    );
  }

  BusinessState copyWith({
    bool? isLoading,
    bool? isLoadingNearby,
    String? message,
    bool? isError,
    List<BusinessEntity>? businesses,
    List<BusinessEntity>? nearbyBusinesses,
    BusinessEntity? selectedBusiness,
  }) {
    return BusinessState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingNearby: isLoadingNearby ?? this.isLoadingNearby,
      message: message,
      isError: isError ?? this.isError,
      businesses: businesses ?? this.businesses,
      nearbyBusinesses: nearbyBusinesses ?? this.nearbyBusinesses,
      selectedBusiness: selectedBusiness ?? this.selectedBusiness,
    );
  }
}
