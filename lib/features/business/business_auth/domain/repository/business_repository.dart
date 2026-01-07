import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';

abstract class BusinessRepository {
  Future<Either<Failure, bool>> registerBusiness(BusinessEntity entity);

  Future<Either<Failure, bool>> loginBusiness(String username, String password);

  Future<Either<Failure, bool>> uploadDocuments(List<String> filePaths);

  Future<Either<Failure, List<dynamic>>> getNearby(
    double latitude,
    double longitude,
  );
}
