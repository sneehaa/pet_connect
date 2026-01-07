import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';

import '../../domain/entity/pet_entity.dart';

abstract class BusinessDashboardRepository {
  //pets
  Future<Either<Failure, List<PetEntity>>> getPetsByBusiness(String businessId);
  Future<Either<Failure, PetEntity>> addPet(
    PetEntity pet,
    List<String>? photos,
  );
  Future<Either<Failure, PetEntity>> updatePet(
    PetEntity pet,
    List<String>? photos,
  );
  Future<Either<Failure, bool>> deletePet(String petId);
  Future<Either<Failure, bool>> changePetStatus(String petId, bool available);

  //adoption
  Future<Either<Failure, AdoptionEntity>> applyAdoption(
    String petId,
    String message,
  );

  Future<Either<Failure, AdoptionEntity>> getAdoptionStatus(String petId);

  Future<Either<Failure, List<AdoptionEntity>>> getAdoptionHistory();

  Future<Either<Failure, List<AdoptionEntity>>> getPetAdoptions(String petId);

  Future<Either<Failure, AdoptionEntity>> updateAdoptionStatus(
    String adoptionId,
    String status,
  );
}
