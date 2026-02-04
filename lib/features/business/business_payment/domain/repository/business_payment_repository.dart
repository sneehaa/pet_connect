// lib/features/business/payment/domain/repository/business_payment_repository.dart
import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_payment/domain/entity/business_payment_entity.dart';

abstract class BusinessPaymentRepository {
  Future<Either<Failure, BusinessEarningsResponseEntity>> getBusinessEarnings({
    int page,
    int limit,
  });

  Future<Either<Failure, double>> getBusinessWalletBalance();

  Future<Either<Failure, Map<String, dynamic>>> getBusinessTransactions({
    int page,
    int limit,
  });
}
