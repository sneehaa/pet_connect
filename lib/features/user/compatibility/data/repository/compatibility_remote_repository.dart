import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/compatibility/data/datasource/compatibility_remote_datasource.dart';
import 'package:pet_connect/features/user/compatibility/domain/entity/compatibility_entity.dart';
import 'package:pet_connect/features/user/compatibility/domain/repository/compatibility_repository.dart';

final compatibilityRepositoryProvider = Provider<CompatibilityRepository>((
  ref,
) {
  return CompatibilityRepositoryImpl(
    ref.read(compatibilityRemoteDataSourceProvider),
  );
});

class CompatibilityRepositoryImpl implements CompatibilityRepository {
  final CompatibilityRemoteDataSource _remoteDataSource;

  CompatibilityRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CompatibilityEntity>> submitQuestionnaire(
    Map<String, dynamic> data,
  ) {
    return _remoteDataSource.submitQuestionnaire(data);
  }

  @override
  Future<Either<Failure, CompatibilityEntity>> getQuestionnaire() {
    return _remoteDataSource.getQuestionnaire();
  }

  @override
  Future<Either<Failure, CompatibilityResultEntity>> getCompatibilityWithPet(
    String petId,
  ) {
    return _remoteDataSource.getCompatibilityWithPet(petId);
  }

  @override
  Future<Either<Failure, List<CompatibilityResultEntity>>> getCompatibilityAll({
    int limit = 50,
    int page = 1,
  }) {
    return _remoteDataSource.getCompatibilityAll(limit: limit, page: page);
  }

  @override
  Future<Either<Failure, bool>> deleteQuestionnaire() {
    return _remoteDataSource.deleteQuestionnaire();
  }
}
