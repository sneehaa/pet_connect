import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/payment/data/datasource/payment_remote_datasource.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';
import 'package:pet_connect/features/user/payment/domain/repository/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(ref.read(paymentRemoteDataSourceProvider));
});

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PaymentSummaryModel>> getPaymentSummary(
    String paymentId,
  ) {
    return _remoteDataSource.getPaymentSummary(paymentId);
  }

  @override
  Future<Either<Failure, PaymentModel>> initiatePayment({
    required String adoptionId,
    required String businessId,
    required String petId,
    required double amount,
  }) {
    return _remoteDataSource.initiatePayment(
      adoptionId: adoptionId,
      businessId: businessId,
      petId: petId,
      amount: amount,
    );
  }

  @override
  Future<Either<Failure, PaymentModel>> processPayment({
    required String paymentId,
    String paymentMethod = 'wallet',
  }) {
    return _remoteDataSource.processPayment(
      paymentId: paymentId,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<Either<Failure, WalletModel>> loadWallet({required double amount}) {
    return _remoteDataSource.loadWallet(amount: amount);
  }

  @override
  Future<Either<Failure, double>> getWalletBalance() {
    return _remoteDataSource.getWalletBalance();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTransactionHistory({
    int page = 1,
    int limit = 10,
  }) {
    return _remoteDataSource.getTransactionHistory(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, List<PaymentModel>>> getUserPayments({
    int page = 1,
    int limit = 10,
  }) {
    return _remoteDataSource.getUserPayments(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, PaymentModel>> getPaymentDetails(String paymentId) {
    return _remoteDataSource.getPaymentDetails(paymentId);
  }
}
