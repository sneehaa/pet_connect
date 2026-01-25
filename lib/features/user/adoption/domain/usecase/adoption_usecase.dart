import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/adoption/data/repository/adoption_repository.dart';
import 'package:pet_connect/features/user/adoption/domain/entity/adoption_entity.dart';
import 'package:pet_connect/features/user/adoption/domain/repository/adoption_repository.dart';

/// Apply for adoption UseCase
final applyAdoptionUseCaseProvider = Provider.autoDispose<ApplyAdoptionUseCase>(
  (ref) {
    return ApplyAdoptionUseCase(ref.read(userAdoptionRepositoryProvider));
  },
);

class ApplyAdoptionUseCase {
  final UserAdoptionRepository repository;
  ApplyAdoptionUseCase(this.repository);

  Future<Either<Failure, UserAdoptionEntity>> execute({
    required String petId,
    required Map<String, dynamic> applicationData,
  }) {
    return repository.applyAdoption(
      petId: petId,
      applicationData: applicationData,
    );
  }
}

/// Get adoption status UseCase
final getAdoptionStatusUseCaseProvider =
    Provider.autoDispose<GetAdoptionStatusUseCase>((ref) {
      return GetAdoptionStatusUseCase(ref.read(userAdoptionRepositoryProvider));
    });

class GetAdoptionStatusUseCase {
  final UserAdoptionRepository repository;
  GetAdoptionStatusUseCase(this.repository);

  Future<Either<Failure, UserAdoptionEntity>> execute(String petId) {
    return repository.getAdoptionStatus(petId);
  }
}

/// Get adoption history UseCase
final getAdoptionHistoryUseCaseProvider =
    Provider.autoDispose<GetAdoptionHistoryUseCase>((ref) {
      return GetAdoptionHistoryUseCase(
        ref.read(userAdoptionRepositoryProvider),
      );
    });

class GetAdoptionHistoryUseCase {
  final UserAdoptionRepository repository;
  GetAdoptionHistoryUseCase(this.repository);

  Future<Either<Failure, List<UserAdoptionEntity>>> execute() {
    return repository.getAdoptionHistory();
  }
}

/// Get adoption by ID UseCase
final getAdoptionByIdUseCaseProvider =
    Provider.autoDispose<GetAdoptionByIdUseCase>((ref) {
      return GetAdoptionByIdUseCase(ref.read(userAdoptionRepositoryProvider));
    });

class GetAdoptionByIdUseCase {
  final UserAdoptionRepository repository;
  GetAdoptionByIdUseCase(this.repository);

  Future<Either<Failure, UserAdoptionEntity>> execute(String adoptionId) {
    return repository.getAdoptionById(adoptionId);
  }
}

/// Mark adoption as paid UseCase
final markAdoptionPaidUseCaseProvider =
    Provider.autoDispose<MarkAdoptionPaidUseCase>((ref) {
      return MarkAdoptionPaidUseCase(ref.read(userAdoptionRepositoryProvider));
    });

class MarkAdoptionPaidUseCase {
  final UserAdoptionRepository repository;
  MarkAdoptionPaidUseCase(this.repository);

  Future<Either<Failure, UserAdoptionEntity>> execute({
    required String adoptionId,
    required String paymentId,
  }) {
    return repository.markAdoptionPaid(
      adoptionId: adoptionId,
      paymentId: paymentId,
    );
  }
}
