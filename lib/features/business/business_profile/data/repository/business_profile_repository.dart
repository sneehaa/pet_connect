import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';

import '../../domain/entity/business_profile_entity.dart';
import '../../domain/repository/business_profile_repository.dart';
import '../datasource/business_profile_remote_datasource.dart';

final businessProfileRemoteRepositoryProvider =
    Provider<BusinessProfileRepository>(
      (ref) => BusinessProfileRemoteRepository(
        ref.read(businessProfileRemoteDataSourceProvider),
      ),
    );

class BusinessProfileRemoteRepository implements BusinessProfileRepository {
  final BusinessProfileRemoteDataSource _remoteDataSource;

  BusinessProfileRemoteRepository(this._remoteDataSource);

  @override
  Future<Either<Failure, BusinessProfileEntity>> getBusinessProfile() {
    return _remoteDataSource.getBusinessProfile();
  }

  @override
  Future<Either<Failure, bool>> createProfile(BusinessProfileEntity profile) {
    return _remoteDataSource.createProfile(profile);
  }

  @override
  Future<Either<Failure, bool>> updateProfile(BusinessProfileEntity profile) {
    return _remoteDataSource.updateProfile(profile);
  }

  @override
  Future<Either<Failure, BusinessProfileEntity>> getBusinessDetails(
    String businessId,
  ) {
    return _remoteDataSource.getBusinessDetails(businessId);
  }

  @override
  Future<Either<Failure, bool>> uploadDocuments(List<String> filePaths) {
    return _remoteDataSource.uploadDocuments(filePaths);
  }
}
