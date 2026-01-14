import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/businesses/data/datasource/business_remote_data_source.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';
import 'package:pet_connect/features/user/businesses/domain/repository/business_repository.dart';


final businessRemoteRepositoryProvider = Provider<BusinessRepository>(
  (ref) => BusinessRemoteRepository(ref.read(businessRemoteDataSourceProvider)),
);

class BusinessRemoteRepository implements BusinessRepository {
  final BusinessRemoteDataSource _businessRemoteDataSource;

  BusinessRemoteRepository(this._businessRemoteDataSource);

  @override
  Future<Either<Failure, List<BusinessEntity>>> getAllBusinesses() async {
    return await _businessRemoteDataSource.getAllBusinesses();
  }

  @override
  Future<Either<Failure, List<BusinessEntity>>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
  }) async {
    return await _businessRemoteDataSource.getNearbyBusinesses(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<Either<Failure, BusinessEntity>> getBusinessById(
    String businessId,
  ) async {
    return await _businessRemoteDataSource.getBusinessById(businessId);
  }

}
