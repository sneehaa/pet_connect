import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/businesses/data/repository/business_remote_repository.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';
import 'package:pet_connect/features/user/businesses/domain/repository/business_repository.dart';

final businessUseCasesProvider = Provider.autoDispose<BusinessUseCases>(
  (ref) => BusinessUseCases(ref.watch(businessRemoteRepositoryProvider)),
);

class BusinessUseCases {
  final BusinessRepository businessRepository;

  BusinessUseCases(this.businessRepository);

  // Get all businesses
  Future<Either<Failure, List<BusinessEntity>>> getAllBusinesses() async {
    return await businessRepository.getAllBusinesses();
  }

  // Get business by ID
  Future<Either<Failure, BusinessEntity>> getBusinessById(
    String businessId,
  ) async {
    return await businessRepository.getBusinessById(businessId);
  }
}
