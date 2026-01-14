import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';

import '../entity/business_profile_entity.dart';

abstract class BusinessProfileRepository {
  // Get business profile (authenticated)
  Future<Either<Failure, BusinessProfileEntity>> getBusinessProfile();

  // Create business profile
  Future<Either<Failure, bool>> createProfile(BusinessProfileEntity profile);

  // Update business profile
  Future<Either<Failure, bool>> updateProfile(BusinessProfileEntity profile);

  // Get business details (public)
  Future<Either<Failure, BusinessProfileEntity>> getBusinessDetails(
    String businessId,
  );

  // Upload documents (reusing from auth)
  Future<Either<Failure, bool>> uploadDocuments(List<String> filePaths);
}
