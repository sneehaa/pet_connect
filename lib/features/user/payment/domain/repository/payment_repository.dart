import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentSummaryModel>> getPaymentSummary(
    String paymentId,
  );

  Future<Either<Failure, PaymentModel>> initiatePayment({
    required String adoptionId,
    required String businessId,
    required String petId,
    required double amount,
  });

  Future<Either<Failure, PaymentModel>> processPayment({
    required String paymentId,
    String paymentMethod,
  });

  Future<Either<Failure, WalletModel>> loadWallet({required double amount});

  Future<Either<Failure, double>> getWalletBalance();

  Future<Either<Failure, Map<String, dynamic>>> getTransactionHistory({
    int page,
    int limit,
  });

  Future<Either<Failure, List<PaymentModel>>> getUserPayments({
    int page,
    int limit,
  });

  Future<Either<Failure, PaymentModel>> getPaymentDetails(String paymentId);
}
