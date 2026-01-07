import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import '../../domain/entity/pet_entity.dart';

abstract class BusinessDashboardRepository {
  Future<Either<Failure, List<PetEntity>>> getPetsByBusiness(String businessId);
  Future<Either<Failure, PetEntity>> addPet(PetEntity pet, List<String>? photos);
  Future<Either<Failure, PetEntity>> updatePet(PetEntity pet, List<String>? photos);
  Future<Either<Failure, bool>> deletePet(String petId);
  Future<Either<Failure, bool>> changePetStatus(String petId, bool available);
}