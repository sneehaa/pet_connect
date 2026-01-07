import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_dashboard/data/data_source/pets_remote_data_source.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/repository/business_dashboard_repository.dart';

final businessDashboardRepositoryProvider = Provider<BusinessDashboardRepository>(
  (ref) => BusinessDashboardRemoteRepository(ref.read(petsRemoteDataSourceProvider)),
);

class BusinessDashboardRemoteRepository implements BusinessDashboardRepository {
  final PetsRemoteDataSource _remoteDataSource;

  BusinessDashboardRemoteRepository(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PetEntity>>> getPetsByBusiness(String businessId) {
    return _remoteDataSource.getPetsByBusiness(businessId);
  }

  @override
  Future<Either<Failure, PetEntity>> addPet(PetEntity pet, List<String>? photos) {
    return _remoteDataSource.addPet(pet, photos);
  }

  @override
  Future<Either<Failure, PetEntity>> updatePet(PetEntity pet, List<String>? photos) {
    return _remoteDataSource.updatePet(pet, photos);
  }

  @override
  Future<Either<Failure, bool>> deletePet(String petId) {
    return _remoteDataSource.deletePet(petId);
  }

  @override
  Future<Either<Failure, bool>> changePetStatus(String petId, bool available) {
    // This needs to be implemented in the data source
    // For now, we'll update the pet locally
    // You should create a specific endpoint for this
    return _remoteDataSource.updatePetStatus(petId, available);
  }
}