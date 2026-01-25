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
  final AdoptionRemoteDataSource _adoptionremoteDataSource;
  final FlutterSecureStorage _storage;

  BusinessDashboardRemoteRepository(
    this._remoteDataSource,
    this._adoptionremoteDataSource,
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

  @override
  Future<Either<Failure, AdoptionEntity>> applyAdoption(
    String petId,
    String message,
  ) {
    return _adoptionremoteDataSource.applyAdoption(petId, message);
  }

  @override
  Future<Either<Failure, AdoptionEntity>> getAdoptionStatus(String petId) {
    return _adoptionremoteDataSource.getAdoptionStatus(petId);
  }

  @override
  Future<Either<Failure, List<AdoptionEntity>>> getAdoptionHistory() {
    return _adoptionremoteDataSource.getAdoptionHistory();
  }

  @override
  Future<Either<Failure, List<AdoptionEntity>>> getPetAdoptions(String petId) {
    return _adoptionremoteDataSource.getPetAdoptions(petId);
  }

  @override
  Future<Either<Failure, AdoptionEntity>> updateAdoptionStatus(
    String adoptionId,
    String status,
  ) {
    return _adoptionremoteDataSource.updateAdoptionStatus(adoptionId, status);
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
