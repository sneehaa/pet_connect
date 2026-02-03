import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';
import 'package:pet_connect/features/user/payment/data/repository/payment_repository.dart';
import 'package:pet_connect/features/user/payment/domain/repository/payment_repository.dart';

// Get payment summary use case
final getPaymentSummaryUseCaseProvider =
    Provider.autoDispose<GetPaymentSummaryUseCase>((ref) {
      return GetPaymentSummaryUseCase(ref.read(paymentRepositoryProvider));
    });

class GetPaymentSummaryUseCase {
  final PaymentRepository repository;
  GetPaymentSummaryUseCase(this.repository);

  Future<Either<Failure, PaymentSummaryModel>> execute(String paymentId) {
    return repository.getPaymentSummary(paymentId);
  }
}

// Initiate payment use case
final initiatePaymentUseCaseProvider =
    Provider.autoDispose<InitiatePaymentUseCase>((ref) {
      return InitiatePaymentUseCase(ref.read(paymentRepositoryProvider));
    });

class InitiatePaymentUseCase {
  final PaymentRepository repository;
  InitiatePaymentUseCase(this.repository);

  Future<Either<Failure, PaymentModel>> execute({
    required String adoptionId,
    required String businessId,
    required String petId,
    required double amount,
  }) {
    return repository.initiatePayment(
      adoptionId: adoptionId,
      businessId: businessId,
      petId: petId,
      amount: amount,
    );
  }
}

// Process payment use case
final processPaymentUseCaseProvider =
    Provider.autoDispose<ProcessPaymentUseCase>((ref) {
      return ProcessPaymentUseCase(ref.read(paymentRepositoryProvider));
    });

class ProcessPaymentUseCase {
  final PaymentRepository repository;
  ProcessPaymentUseCase(this.repository);

  Future<Either<Failure, PaymentModel>> execute({
    required String paymentId,
    String paymentMethod = 'wallet',
  }) {
    return repository.processPayment(
      paymentId: paymentId,
      paymentMethod: paymentMethod,
    );
  }
}

// Load wallet use case
final loadWalletUseCaseProvider = Provider.autoDispose<LoadWalletUseCase>((
  ref,
) {
  return LoadWalletUseCase(ref.read(paymentRepositoryProvider));
});

class LoadWalletUseCase {
  final PaymentRepository repository;
  LoadWalletUseCase(this.repository);

  Future<Either<Failure, WalletModel>> execute({required double amount}) {
    return repository.loadWallet(amount: amount);
  }
}

// Get wallet balance use case
final getWalletBalanceUseCaseProvider =
    Provider.autoDispose<GetWalletBalanceUseCase>((ref) {
      return GetWalletBalanceUseCase(ref.read(paymentRepositoryProvider));
    });

class GetWalletBalanceUseCase {
  final PaymentRepository repository;
  GetWalletBalanceUseCase(this.repository);

  Future<Either<Failure, double>> execute() {
    return repository.getWalletBalance();
  }
}

// Get transaction history use case
final getTransactionHistoryUseCaseProvider =
    Provider.autoDispose<GetTransactionHistoryUseCase>((ref) {
      return GetTransactionHistoryUseCase(ref.read(paymentRepositoryProvider));
    });

class GetTransactionHistoryUseCase {
  final PaymentRepository repository;
  GetTransactionHistoryUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    int page = 1,
    int limit = 10,
  }) {
    return repository.getTransactionHistory(page: page, limit: limit);
  }
}

// Get user payments use case
final getUserPaymentsUseCaseProvider =
    Provider.autoDispose<GetUserPaymentsUseCase>((ref) {
      return GetUserPaymentsUseCase(ref.read(paymentRepositoryProvider));
    });

class GetUserPaymentsUseCase {
  final PaymentRepository repository;
  GetUserPaymentsUseCase(this.repository);

  Future<Either<Failure, List<PaymentModel>>> execute({
    int page = 1,
    int limit = 10,
  }) {
    return repository.getUserPayments(page: page, limit: limit);
  }
}

// Get payment details use case
final getPaymentDetailsUseCaseProvider =
    Provider.autoDispose<GetPaymentDetailsUseCase>((ref) {
      return GetPaymentDetailsUseCase(ref.read(paymentRepositoryProvider));
    });

class GetPaymentDetailsUseCase {
  final PaymentRepository repository;
  GetPaymentDetailsUseCase(this.repository);

  Future<Either<Failure, PaymentModel>> execute(String paymentId) {
    return repository.getPaymentDetails(paymentId);
  }
}
