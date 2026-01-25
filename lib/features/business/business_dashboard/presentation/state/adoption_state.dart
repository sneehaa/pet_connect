import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';

enum BusinessAdoptionStatus { initial, loading, loaded, error }

class BusinessAdoptionState {
  final BusinessAdoptionStatus status;
  final List<BusinessAdoptionEntity> adoptions;
  final BusinessAdoptionEntity? currentAdoption;
  final String? message;
  final bool isLoading;

  const BusinessAdoptionState({
    this.status = BusinessAdoptionStatus.initial,
    this.adoptions = const [],
    this.currentAdoption,
    this.message,
    this.isLoading = false,
  });

  BusinessAdoptionState copyWith({
    BusinessAdoptionStatus? status,
    List<BusinessAdoptionEntity>? adoptions,
    BusinessAdoptionEntity? currentAdoption,
    String? message,
    bool? isLoading,
  }) {
    return BusinessAdoptionState(
      status: status ?? this.status,
      adoptions: adoptions ?? this.adoptions,
      currentAdoption: currentAdoption ?? this.currentAdoption,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
