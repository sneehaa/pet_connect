import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

abstract class PetRepository {
  // Get all available pets
  Future<Either<Failure, List<UserPetEntity>>> getAllPets();

  // Get pet by ID
  Future<Either<Failure, UserPetEntity>> getPetById(String petId);

  // Get pets by business ID
  Future<Either<Failure, List<UserPetEntity>>> getPetsByBusiness(
    String businessId,
  );
}
