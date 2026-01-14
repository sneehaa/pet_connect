import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

abstract class BusinessRepository {
  Future<Either<Failure, List<BusinessEntity>>> getAllBusinesses();
  Future<Either<Failure, BusinessEntity>> getBusinessById(String businessId);
}
