import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/pets/data/datasource/pet_remote_datasource.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/user/pets/domain/repository/pet_repository.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepositoryImpl(ref.read(petRemoteDataSourceProvider));
});

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource _remoteDataSource;

  PetRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<UserPetEntity>>> getAllPets() {
    return _remoteDataSource.getAllPets();
  }

  @override
  Future<Either<Failure, UserPetEntity>> getPetById(String petId) {
    return _remoteDataSource.getPetById(petId);
  }

  @override
  Future<Either<Failure, List<UserPetEntity>>> getPetsByBusiness(
    String businessId,
  ) {
    return _remoteDataSource.getPetsByBusiness(businessId);
  }
}
