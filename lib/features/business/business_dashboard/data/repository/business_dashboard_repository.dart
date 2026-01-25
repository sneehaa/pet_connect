import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/business/business_dashboard/data/data_source/adoption_remote_data_source.dart';
import 'package:pet_connect/features/business/business_dashboard/data/data_source/pets_remote_data_source.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/repository/business_dashboard_repository.dart';

final businessDashboardRepositoryProvider =
    Provider<BusinessDashboardRepository>(
      (ref) => BusinessDashboardRemoteRepository(
        ref.read(petsRemoteDataSourceProvider),
        ref.read(adoptionRemoteDataSourceProvider),
        ref.read(flutterSecureStorageProvider),
      ),
    );

class BusinessDashboardRemoteRepository implements BusinessDashboardRepository {
  final PetsRemoteDataSource _remoteDataSource;
  final AdoptionRemoteDataSource _adoptionRemoteDataSource;
  final FlutterSecureStorage _storage;

  BusinessDashboardRemoteRepository(
    this._remoteDataSource,
    this._adoptionRemoteDataSource,
    this._storage, 
  );

  @override
  Future<Either<Failure, List<PetEntity>>> getPetsByBusiness(
    String businessId,
  ) {
    return _remoteDataSource.getPetsByBusiness(businessId);
  }

  @override
  Future<Either<Failure, PetEntity>> addPet(
    PetEntity pet,
    List<String>? photoPaths,
  ) {
    return _remoteDataSource.addPet(pet, photoPaths);
  }

  @override
  Future<Either<Failure, PetEntity>> updatePet(
    PetEntity pet,
    List<String>? photoPaths,
    String petId,
  ) {
    return _remoteDataSource.updatePet(pet, photoPaths, petId);
  }

  @override
  Future<Either<Failure, bool>> deletePet(String petId) {
    return _remoteDataSource.deletePet(petId);
  }

  @override
  Future<Either<Failure, bool>> changePetStatus(String petId, String status) {
    return _remoteDataSource.updatePetStatus(petId, status);
  }

  // Business-side adoption methods
  @override
  Future<Either<Failure, List<BusinessAdoptionEntity>>> getPetAdoptions(
    String petId,
  ) {
    return _adoptionRemoteDataSource
        .getPetAdoptions(petId)
        .then(
          (result) => result.fold(
            (failure) => Left(failure),
            (models) => Right(models),
          ),
        );
  }

  @override
  Future<Either<Failure, BusinessAdoptionEntity>> updateAdoptionStatus(
    String adoptionId,
    String status,
    String? rejectionReason,
  ) {
    return _adoptionRemoteDataSource
        .updateAdoptionStatus(
          adoptionId: adoptionId,
          status: status,
          rejectionReason: rejectionReason,
        )
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }

  @override
  Future<Either<Failure, BusinessAdoptionEntity>> approveAdoption(
    String adoptionId,
  ) {
    return _adoptionRemoteDataSource
        .approveAdoption(adoptionId)
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }

  @override
  Future<Either<Failure, BusinessAdoptionEntity>> rejectAdoption(
    String adoptionId,
    String reason,
  ) {
    return _adoptionRemoteDataSource
        .rejectAdoption(adoptionId, reason)
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }

  @override
  Future<Either<Failure, BusinessAdoptionEntity>> getAdoptionById(
    String adoptionId,
  ) {
    return _adoptionRemoteDataSource
        .getAdoptionById(adoptionId)
        .then(
          (result) =>
              result.fold((failure) => Left(failure), (model) => Right(model)),
        );
  }

  @override
  Future<Either<Failure, List<BusinessAdoptionEntity>>> getBusinessAdoptions() {
    return _adoptionRemoteDataSource.getBusinessAdoptions().then(
      (result) =>
          result.fold((failure) => Left(failure), (models) => Right(models)),
    );
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
