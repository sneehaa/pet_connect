import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_dashboard/data/repository/business_dashboard_repository.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/repository/business_dashboard_repository.dart';

/// Apply for adoption UseCase
final applyAdoptionUseCaseProvider = Provider.autoDispose<ApplyAdoptionUseCase>(
  (ref) {
    return ApplyAdoptionUseCase(ref.read(businessDashboardRepositoryProvider));
  },
);

class ApplyAdoptionUseCase {
  final BusinessDashboardRepository repository;
  ApplyAdoptionUseCase(this.repository);

  Future<Either<Failure, AdoptionEntity>> execute(
    String petId,
    String message,
  ) {
    return repository.applyAdoption(petId, message);
  }
}

/// Get adoption status UseCase
final getAdoptionStatusUseCaseProvider =
    Provider.autoDispose<GetAdoptionStatusUseCase>((ref) {
      return GetAdoptionStatusUseCase(
        ref.read(businessDashboardRepositoryProvider),
      );
    });

class GetAdoptionStatusUseCase {
  final BusinessDashboardRepository repository;
  GetAdoptionStatusUseCase(this.repository);

  Future<Either<Failure, AdoptionEntity>> execute(String petId) {
    return repository.getAdoptionStatus(petId);
  }
}

/// Get adoption history UseCase
final getAdoptionHistoryUseCaseProvider =
    Provider.autoDispose<GetAdoptionHistoryUseCase>((ref) {
      return GetAdoptionHistoryUseCase(
        ref.read(businessDashboardRepositoryProvider),
      );
    });

class GetAdoptionHistoryUseCase {
  final BusinessDashboardRepository repository;
  GetAdoptionHistoryUseCase(this.repository);

  Future<Either<Failure, List<AdoptionEntity>>> execute() {
    return repository.getAdoptionHistory();
  }
}

/// Get pet adoptions UseCase (for businesses)
final getPetAdoptionsUseCaseProvider =
    Provider.autoDispose<GetPetAdoptionsUseCase>((ref) {
      return GetPetAdoptionsUseCase(
        ref.read(businessDashboardRepositoryProvider),
      );
    });

class GetPetAdoptionsUseCase {
  final BusinessDashboardRepository repository;
  GetPetAdoptionsUseCase(this.repository);

  Future<Either<Failure, List<AdoptionEntity>>> execute(String petId) {
    return repository.getPetAdoptions(petId);
  }
}

/// Update adoption status UseCase (for businesses)
final updateAdoptionStatusUseCaseProvider =
    Provider.autoDispose<UpdateAdoptionStatusUseCase>((ref) {
      return UpdateAdoptionStatusUseCase(
        ref.read(businessDashboardRepositoryProvider),
      );
    });

class UpdateAdoptionStatusUseCase {
  final BusinessDashboardRepository repository;
  UpdateAdoptionStatusUseCase(this.repository);

  Future<Either<Failure, AdoptionEntity>> execute(
    String adoptionId,
    String status,
  ) {
    return repository.updateAdoptionStatus(adoptionId, status);
  }
}
