import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_dashboard/data/repository/business_dashboard_repository.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/repository/business_dashboard_repository.dart';

/// Get Pets UseCase
final getPetsUseCaseProvider = Provider.autoDispose<GetPetsUseCase>((ref) {
  return GetPetsUseCase(ref.read(businessDashboardRepositoryProvider));
});

class GetPetsUseCase {
  final BusinessDashboardRepository repository;
  GetPetsUseCase(this.repository);

  Future<Either<Failure, List<PetEntity>>> execute(String businessId) {
    return repository.getPetsByBusiness(businessId);
  }
}

/// Add Pet UseCase
final addPetUseCaseProvider = Provider.autoDispose<AddPetUseCase>((ref) {
  return AddPetUseCase(ref.read(businessDashboardRepositoryProvider));
});

class AddPetUseCase {
  final BusinessDashboardRepository repository;
  AddPetUseCase(this.repository);

  Future<Either<Failure, PetEntity>> execute(
    PetEntity pet,
    List<String>? photos,
  ) {
    return repository.addPet(pet, photos);
  }
}

/// Update Pet UseCase
final updatePetUseCaseProvider = Provider.autoDispose<UpdatePetUseCase>((ref) {
  return UpdatePetUseCase(ref.read(businessDashboardRepositoryProvider));
});

class UpdatePetUseCase {
  final BusinessDashboardRepository repository;
  UpdatePetUseCase(this.repository);

  Future<Either<Failure, PetEntity>> execute(
    PetEntity pet,
    List<String>? photos,
  ) {
    return repository.updatePet(pet, photos);
  }
}

/// Delete Pet UseCase
final deletePetUseCaseProvider = Provider.autoDispose<DeletePetUseCase>((ref) {
  return DeletePetUseCase(ref.read(businessDashboardRepositoryProvider));
});

class DeletePetUseCase {
  final BusinessDashboardRepository repository;
  DeletePetUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String petId) {
    return repository.deletePet(petId);
  }
}

/// Change Pet Status UseCase
final changePetStatusUseCaseProvider =
    Provider.autoDispose<ChangePetStatusUseCase>((ref) {
      return ChangePetStatusUseCase(
        ref.read(businessDashboardRepositoryProvider),
      );
    });

class ChangePetStatusUseCase {
  final BusinessDashboardRepository repository;
  ChangePetStatusUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String petId, bool available) {
    return repository.changePetStatus(petId, available);
  }
}
