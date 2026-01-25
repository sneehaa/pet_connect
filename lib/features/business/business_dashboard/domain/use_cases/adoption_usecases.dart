import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_dashboard/data/repository/business_dashboard_repository.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/repository/business_dashboard_repository.dart';

final getPetAdoptionsUseCaseProvider = Provider<GetPetAdoptionsUseCase>((ref) {
  return GetPetAdoptionsUseCase(ref.read(businessDashboardRepositoryProvider));
});

class GetPetAdoptionsUseCase {
  final BusinessDashboardRepository repository;
  GetPetAdoptionsUseCase(this.repository);

  Future<Either<Failure, List<BusinessAdoptionEntity>>> execute(String petId) {
    return repository.getPetAdoptions(petId);
  }
}

final updateAdoptionStatusUseCaseProvider =
    Provider<UpdateAdoptionStatusUseCase>((ref) {
      return UpdateAdoptionStatusUseCase(
        ref.read(businessDashboardRepositoryProvider),
      );
    });

class UpdateAdoptionStatusUseCase {
  final BusinessDashboardRepository repository;
  UpdateAdoptionStatusUseCase(this.repository);

  Future<Either<Failure, BusinessAdoptionEntity>> execute(
    String adoptionId,
    String status,
    String? rejectionReason,
  ) {
    return repository.updateAdoptionStatus(adoptionId, status, rejectionReason);
  }
}

final approveAdoptionUseCaseProvider = Provider<ApproveAdoptionUseCase>((ref) {
  return ApproveAdoptionUseCase(ref.read(businessDashboardRepositoryProvider));
});

class ApproveAdoptionUseCase {
  final BusinessDashboardRepository repository;
  ApproveAdoptionUseCase(this.repository);

  Future<Either<Failure, BusinessAdoptionEntity>> execute(String adoptionId) {
    return repository.approveAdoption(adoptionId);
  }
}

final rejectAdoptionUseCaseProvider = Provider<RejectAdoptionUseCase>((ref) {
  return RejectAdoptionUseCase(ref.read(businessDashboardRepositoryProvider));
});

class RejectAdoptionUseCase {
  final BusinessDashboardRepository repository;
  RejectAdoptionUseCase(this.repository);

  Future<Either<Failure, BusinessAdoptionEntity>> execute(
    String adoptionId,
    String reason,
  ) {
    return repository.rejectAdoption(adoptionId, reason);
  }
}

final getAdoptionByIdUseCaseProvider = Provider<GetAdoptionByIdUseCase>((ref) {
  return GetAdoptionByIdUseCase(ref.read(businessDashboardRepositoryProvider));
});

class GetAdoptionByIdUseCase {
  final BusinessDashboardRepository repository;
  GetAdoptionByIdUseCase(this.repository);

  Future<Either<Failure, BusinessAdoptionEntity>> execute(String adoptionId) {
    return repository.getAdoptionById(adoptionId);
  }
}

final getBusinessAdoptionsUseCaseProvider =
    Provider<GetBusinessAdoptionsUseCase>((ref) {
      return GetBusinessAdoptionsUseCase(
        ref.read(businessDashboardRepositoryProvider),
      );
    });

class GetBusinessAdoptionsUseCase {
  final BusinessDashboardRepository repository;
  GetBusinessAdoptionsUseCase(this.repository);

  Future<Either<Failure, List<BusinessAdoptionEntity>>> execute() {
    return repository.getBusinessAdoptions();
  }
}
