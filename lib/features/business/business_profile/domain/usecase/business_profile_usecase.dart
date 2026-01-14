import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_profile/data/repository/business_profile_repository.dart';

import '../entity/business_profile_entity.dart';
import '../repository/business_profile_repository.dart';

/// Get Business Profile UseCase
final getBusinessProfileUseCaseProvider =
    Provider.autoDispose<GetBusinessProfileUseCase>(
      (ref) => GetBusinessProfileUseCase(
        ref.read(businessProfileRemoteRepositoryProvider),
      ),
    );

class GetBusinessProfileUseCase {
  final BusinessProfileRepository _repository;

  GetBusinessProfileUseCase(this._repository);

  Future<Either<Failure, BusinessProfileEntity>> execute() async {
    return _repository.getBusinessProfile();
  }
}

/// Create Business Profile UseCase
final createBusinessProfileUseCaseProvider =
    Provider.autoDispose<CreateBusinessProfileUseCase>(
      (ref) => CreateBusinessProfileUseCase(
        ref.read(businessProfileRemoteRepositoryProvider),
      ),
    );

class CreateBusinessProfileUseCase {
  final BusinessProfileRepository _repository;

  CreateBusinessProfileUseCase(this._repository);

  Future<Either<Failure, bool>> execute(BusinessProfileEntity profile) async {
    return _repository.createProfile(profile);
  }
}

/// Update Business Profile UseCase
final updateBusinessProfileUseCaseProvider =
    Provider.autoDispose<UpdateBusinessProfileUseCase>(
      (ref) => UpdateBusinessProfileUseCase(
        ref.read(businessProfileRemoteRepositoryProvider),
      ),
    );

class UpdateBusinessProfileUseCase {
  final BusinessProfileRepository _repository;

  UpdateBusinessProfileUseCase(this._repository);

  Future<Either<Failure, bool>> execute(BusinessProfileEntity profile) async {
    return _repository.updateProfile(profile);
  }
}

/// Get Business Details (Public) UseCase
final getBusinessDetailsUseCaseProvider =
    Provider.autoDispose<GetBusinessDetailsUseCase>(
      (ref) => GetBusinessDetailsUseCase(
        ref.read(businessProfileRemoteRepositoryProvider),
      ),
    );

class GetBusinessDetailsUseCase {
  final BusinessProfileRepository _repository;

  GetBusinessDetailsUseCase(this._repository);

  Future<Either<Failure, BusinessProfileEntity>> execute(
    String businessId,
  ) async {
    return _repository.getBusinessDetails(businessId);
  }
}

/// Upload Documents UseCase (reusing from auth)
final uploadDocumentsUseCaseProvider =
    Provider.autoDispose<UploadDocumentsUseCase>(
      (ref) => UploadDocumentsUseCase(
        ref.read(businessProfileRemoteRepositoryProvider),
      ),
    );

class UploadDocumentsUseCase {
  final BusinessProfileRepository _repository;

  UploadDocumentsUseCase(this._repository);

  Future<Either<Failure, bool>> execute(List<String> filePaths) async {
    return _repository.uploadDocuments(filePaths);
  }
}
