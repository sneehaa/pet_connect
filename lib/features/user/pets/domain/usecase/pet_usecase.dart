import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/pets/data/repository/pet_remote_repository.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/user/pets/domain/repository/pet_repository.dart';

// Get all pets use case
final getAllPetsUseCaseProvider = Provider.autoDispose<GetAllPetsUseCase>((
  ref,
) {
  return GetAllPetsUseCase(ref.read(petRepositoryProvider));
});

class GetAllPetsUseCase {
  final PetRepository repository;
  GetAllPetsUseCase(this.repository);

  Future<Either<Failure, List<UserPetEntity>>> execute() {
    return repository.getAllPets();
  }
}

// Get pet by ID use case
final getPetByIdUseCaseProvider = Provider.autoDispose<GetPetByIdUseCase>((
  ref,
) {
  return GetPetByIdUseCase(ref.read(petRepositoryProvider));
});

class GetPetByIdUseCase {
  final PetRepository repository;
  GetPetByIdUseCase(this.repository);

  Future<Either<Failure, UserPetEntity>> execute(String petId) {
    return repository.getPetById(petId);
  }
}

// Get pets by business use case
final getPetsByBusinessUseCaseProvider =
    Provider.autoDispose<GetPetsByBusinessUseCase>((ref) {
      return GetPetsByBusinessUseCase(ref.read(petRepositoryProvider));
    });

class GetPetsByBusinessUseCase {
  final PetRepository repository;
  GetPetsByBusinessUseCase(this.repository);

  Future<Either<Failure, List<UserPetEntity>>> execute(String businessId) {
    return repository.getPetsByBusiness(businessId);
  }
}
