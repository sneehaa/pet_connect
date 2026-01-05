import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';
import 'package:pet_connect/features/business/business_auth/domain/repository/business_repository.dart';

import '../data_source/business_remote_datasource.dart';

final businessRemoteRepositoryProvider = Provider<BusinessRepository>(
  (ref) => BusinessRemoteRepository(ref.read(businessRemoteDataSourceProvider)),
);

class BusinessRemoteRepository implements BusinessRepository {
  final BusinessRemoteDataSource _remoteDataSource;

  BusinessRemoteRepository(this._remoteDataSource);

  @override
  Future<Either<Failure, bool>> registerBusiness(
    BusinessEntity business,
  ) async {
    return await _remoteDataSource.registerBusiness(business);
  }

  @override
  Future<Either<Failure, bool>> loginBusiness(
    String username,
    String password,
  ) async {
    return await _remoteDataSource.loginBusiness(username, password);
  }
}
