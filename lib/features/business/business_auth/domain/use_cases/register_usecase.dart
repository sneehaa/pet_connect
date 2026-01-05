import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_auth/data/repository/business_remote_repository.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';
import 'package:pet_connect/features/business/business_auth/domain/repository/business_repository.dart';

final registerBusinessUseCaseProvider =
    Provider.autoDispose<RegisterBusinessUseCase>(
      (ref) =>
          RegisterBusinessUseCase(ref.read(businessRemoteRepositoryProvider)),
    );

class RegisterBusinessUseCase {
  final BusinessRepository repository;
  RegisterBusinessUseCase(this.repository);

  Future<Either<Failure, bool>> registerBusiness(BusinessEntity entity) async {
    return await repository.registerBusiness(entity);
  }
}
