// lib/features/business/payment/data/repository/business_payment_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_payment/data/datasource/business_remote_datasource.dart';
import 'package:pet_connect/features/business/business_payment/data/model/business_payment_model.dart';
import 'package:pet_connect/features/business/business_payment/domain/repository/business_payment_repository.dart';

final businessPaymentRepositoryProvider = Provider<BusinessPaymentRepository>((
  ref,
) {
  return BusinessPaymentRepositoryImpl(
    ref.read(businessPaymentRemoteDataSourceProvider),
  );
});

class BusinessPaymentRepositoryImpl implements BusinessPaymentRepository {
  final BusinessPaymentRemoteDataSource _remoteDataSource;

  BusinessPaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, BusinessEarningsResponse>> getBusinessEarnings({
    int page = 1,
    int limit = 10,
  }) {
    return _remoteDataSource.getBusinessEarnings(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, double>> getBusinessWalletBalance() {
    return _remoteDataSource.getBusinessWalletBalance();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBusinessTransactions({
    int page = 1,
    int limit = 10,
  }) {
    return _remoteDataSource.getBusinessTransactions(page: page, limit: limit);
  }
}
