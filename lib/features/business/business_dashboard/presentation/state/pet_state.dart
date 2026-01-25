import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';

enum PetStatus { initial, loading, loaded, error }

class PetState {
  final PetStatus status;
  final List<PetEntity> pets;
  final String? message;

  const PetState({
    this.status = PetStatus.initial,
    this.pets = const [],
    this.message,
  });

  bool get isLoading => status == PetStatus.loading;

  PetState copyWith({
    PetStatus? status,
    List<PetEntity>? pets,
    String? message,
  }) {
    return PetState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      message: message ?? this.message,
    );
  }
}
