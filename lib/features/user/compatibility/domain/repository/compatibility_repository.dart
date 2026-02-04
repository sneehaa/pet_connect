import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/compatibility/domain/entity/compatibility_entity.dart';

abstract class CompatibilityRepository {
  Future<Either<Failure, CompatibilityEntity>> submitQuestionnaire(
    Map<String, dynamic> data,
  );

  Future<Either<Failure, CompatibilityEntity>> getQuestionnaire();

  Future<Either<Failure, CompatibilityResultEntity>> getCompatibilityWithPet(
    String petId,
  );

  Future<Either<Failure, List<CompatibilityResultEntity>>> getCompatibilityAll({
    int limit,
    int page,
  });

  Future<Either<Failure, bool>> deleteQuestionnaire();
}
