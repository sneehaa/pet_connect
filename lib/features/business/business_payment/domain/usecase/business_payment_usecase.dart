// lib/features/business/payment/domain/usecase/business_payment_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_payment/data/repository/business_payment_repository.dart';
import 'package:pet_connect/features/business/business_payment/domain/entity/business_payment_entity.dart';
import 'package:pet_connect/features/business/business_payment/domain/repository/business_payment_repository.dart';

// Get business earnings use case
final getBusinessEarningsUseCaseProvider =
    Provider.autoDispose<GetBusinessEarningsUseCase>((ref) {
      return GetBusinessEarningsUseCase(
        ref.read(businessPaymentRepositoryProvider),
      );
    });

class GetBusinessEarningsUseCase {
  final BusinessPaymentRepository repository;
  GetBusinessEarningsUseCase(this.repository);

  Future<Either<Failure, BusinessEarningsResponseEntity>> execute({
    int page = 1,
    int limit = 10,
  }) {
    return repository.getBusinessEarnings(page: page, limit: limit);
  }
}

// Get business wallet balance use case
final getBusinessWalletBalanceUseCaseProvider =
    Provider.autoDispose<GetBusinessWalletBalanceUseCase>((ref) {
      return GetBusinessWalletBalanceUseCase(
        ref.read(businessPaymentRepositoryProvider),
      );
    });

class GetBusinessWalletBalanceUseCase {
  final BusinessPaymentRepository repository;
  GetBusinessWalletBalanceUseCase(this.repository);

  Future<Either<Failure, double>> execute() {
    return repository.getBusinessWalletBalance();
  }
}

// Get business transactions use case
final getBusinessTransactionsUseCaseProvider =
    Provider.autoDispose<GetBusinessTransactionsUseCase>((ref) {
      return GetBusinessTransactionsUseCase(
        ref.read(businessPaymentRepositoryProvider),
      );
    });

class GetBusinessTransactionsUseCase {
  final BusinessPaymentRepository repository;
  GetBusinessTransactionsUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    int page = 1,
    int limit = 10,
  }) {
    return repository.getBusinessTransactions(page: page, limit: limit);
  }
}
