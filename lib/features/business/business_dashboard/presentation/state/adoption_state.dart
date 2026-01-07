import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';

enum AdoptionStatus { initial, loading, loaded, error }

class AdoptionState {
  final AdoptionStatus status;
  final List<AdoptionEntity> adoptions;
  final AdoptionEntity? currentAdoption;
  final String? message;
  final bool isLoading;

  const AdoptionState({
    this.status = AdoptionStatus.initial,
    this.adoptions = const [],
    this.currentAdoption,
    this.message,
    this.isLoading = false,
  });

  AdoptionState copyWith({
    AdoptionStatus? status,
    List<AdoptionEntity>? adoptions,
    AdoptionEntity? currentAdoption,
    String? message,
    bool? isLoading,
  }) {
    return AdoptionState(
      status: status ?? this.status,
      adoptions: adoptions ?? this.adoptions,
      currentAdoption: currentAdoption ?? this.currentAdoption,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
