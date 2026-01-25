import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/adoption/domain/entity/adoption_entity.dart';

abstract class UserAdoptionRepository {
  Future<Either<Failure, UserAdoptionEntity>> applyAdoption({
    required String petId,
    required Map<String, dynamic> applicationData,
  });

  Future<Either<Failure, UserAdoptionEntity>> getAdoptionStatus(String petId);

  Future<Either<Failure, List<UserAdoptionEntity>>> getAdoptionHistory();

  Future<Either<Failure, UserAdoptionEntity>> getAdoptionById(
    String adoptionId,
  );

  Future<Either<Failure, UserAdoptionEntity>> markAdoptionPaid({
    required String adoptionId,
    required String paymentId,
  });
}
