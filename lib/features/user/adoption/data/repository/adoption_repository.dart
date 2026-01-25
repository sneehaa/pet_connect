import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/user/adoption/data/datasource/adoption_remote_datasource.dart';
import 'package:pet_connect/features/user/adoption/domain/entity/adoption_entity.dart';
import 'package:pet_connect/features/user/adoption/domain/repository/adoption_repository.dart';

final userAdoptionRepositoryProvider = Provider<UserAdoptionRepository>(
  (ref) => UserAdoptionRemoteRepository(
    ref.read(userAdoptionRemoteDataSourceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class UserAdoptionRemoteRepository implements UserAdoptionRepository {
  final UserAdoptionRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  UserAdoptionRemoteRepository(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, UserAdoptionEntity>> applyAdoption({
    required String petId,
    required Map<String, dynamic> applicationData,
  }) {
    return _remoteDataSource
        .applyAdoption(petId: petId, applicationData: applicationData)
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }

  @override
  Future<Either<Failure, UserAdoptionEntity>> getAdoptionStatus(String petId) {
    return _remoteDataSource
        .getAdoptionStatus(petId)
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }

  @override
  Future<Either<Failure, List<UserAdoptionEntity>>> getAdoptionHistory() {
    return _remoteDataSource.getAdoptionHistory().then(
      (result) =>
          result.fold((failure) => Left(failure), (models) => Right(models)),
    );
  }

  @override
  Future<Either<Failure, UserAdoptionEntity>> getAdoptionById(
    String adoptionId,
  ) {
    return _remoteDataSource
        .getAdoptionById(adoptionId)
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }

  @override
  Future<Either<Failure, UserAdoptionEntity>> markAdoptionPaid({
    required String adoptionId,
    required String paymentId,
  }) {
    return _remoteDataSource
        .markAdoptionPaid(adoptionId: adoptionId, paymentId: paymentId)
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }
}
