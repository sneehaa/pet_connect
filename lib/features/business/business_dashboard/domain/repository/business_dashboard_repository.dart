import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';

import '../../domain/entity/pet_entity.dart';

abstract class BusinessDashboardRepository {
  // Pet management methods
  Future<Either<Failure, List<PetEntity>>> getPetsByBusiness(String businessId);
  Future<Either<Failure, PetEntity>> addPet(
    PetEntity pet,
    List<String>? photoPaths,
  );
  Future<Either<Failure, PetEntity>> updatePet(
    PetEntity pet,
    List<String>? photoPaths,
    String petId,
  );
  Future<Either<Failure, bool>> deletePet(String petId);
  Future<Either<Failure, bool>> changePetStatus(String petId, String status);

  Future<Either<Failure, List<BusinessAdoptionEntity>>> getPetAdoptions(
    String petId,
  );
  Future<Either<Failure, BusinessAdoptionEntity>> updateAdoptionStatus(
    String adoptionId,
    String status,
    String? rejectionReason,
  );
  Future<Either<Failure, BusinessAdoptionEntity>> approveAdoption(
    String adoptionId,
  );
  Future<Either<Failure, BusinessAdoptionEntity>> rejectAdoption(
    String adoptionId,
    String reason,
  );
  Future<Either<Failure, BusinessAdoptionEntity>> getAdoptionById(
    String adoptionId,
  );

  Future<Either<Failure, List<BusinessAdoptionEntity>>> getBusinessAdoptions();

  /// logout function
  Future<void> logout();
}
