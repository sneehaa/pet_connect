import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';

enum PetStatus { initial, loading, loaded, error }

class PetState {
  final PetStatus status;
  final List<PetEntity> pets;
  final String? message;
  final bool isLoading;

  const PetState({
    this.status = PetStatus.initial,
    this.pets = const [],
    this.message,
    this.isLoading = false,
  });

  PetState copyWith({
    PetStatus? status,
    List<PetEntity>? pets,
    String? message,
    bool? isLoading,
  }) {
    return PetState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
