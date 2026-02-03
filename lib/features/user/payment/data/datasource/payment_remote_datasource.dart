import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((
  ref,
) {
  return PaymentRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  );
});

class PaymentRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  PaymentRemoteDataSource(this.dio, this.secureStorage);

  Future<String?> _getUserAuthToken() async {
    return await secureStorage.read(key: 'authenticationToken');
  }

  Future<String?> _getUserId() async {
    return await secureStorage.read(key: 'userId');
  }

  Future<void> _validateUserAuth() async {
    final token = await _getUserAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('User authentication required. Please login.');
    }
  }

  // Get payment summary
  Future<Either<Failure, PaymentSummaryModel>> getPaymentSummary(
    String paymentId,
  ) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.get(
        ApiEndpoints.getPaymentSummary(paymentId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(PaymentSummaryModel.fromJson(response.data['summary']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Initiate payment
  Future<Either<Failure, PaymentModel>> initiatePayment({
    required String adoptionId,
    required String businessId,
    required String petId,
    required double amount,
  }) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.post(
        ApiEndpoints.initiatePayment,
        data: {
          'adoptionId': adoptionId,
          'businessId': businessId,
          'petId': petId,
          'amount': amount,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(PaymentModel.fromJson(response.data['payment']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Process payment
  Future<Either<Failure, PaymentModel>> processPayment({
    required String paymentId,
    String paymentMethod = 'wallet',
  }) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.post(
        ApiEndpoints.processPayment,
        data: {'paymentId': paymentId, 'paymentMethod': paymentMethod},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(PaymentModel.fromJson(response.data['payment']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Load wallet
  Future<Either<Failure, WalletModel>> loadWallet({
    required double amount,
  }) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.post(
        ApiEndpoints.loadWallet,
        data: {'amount': amount},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(WalletModel.fromJson(response.data['wallet']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Get wallet balance
  Future<Either<Failure, double>> getWalletBalance() async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.get(
        ApiEndpoints.getWalletBalance,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(response.data['balance'].toDouble());
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Get transaction history
  Future<Either<Failure, Map<String, dynamic>>> getTransactionHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.get(
        ApiEndpoints.getWalletTransactions,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right({
          'transactions': (response.data['transactions'] as List)
              .map((txn) => TransactionModel.fromJson(txn))
              .toList(),
          'total': response.data['total'],
          'page': response.data['page'],
          'totalPages': response.data['totalPages'],
        });
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Get user payments
  Future<Either<Failure, List<PaymentModel>>> getUserPayments({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.get(
        ApiEndpoints.getUserPayments,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        final payments = (response.data['payments'] as List)
            .map((payment) => PaymentModel.fromJson(payment))
            .toList();
        return Right(payments);
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Get payment details
  Future<Either<Failure, PaymentModel>> getPaymentDetails(
    String paymentId,
  ) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();

      final response = await dio.get(
        ApiEndpoints.getPaymentDetails(paymentId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(PaymentModel.fromJson(response.data['payment']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.response != null) {
      final responseData = e.response?.data;

      if (responseData is Map && responseData['success'] == false) {
        return Failure(
          error: responseData['message'] ?? 'Payment request failed',
        );
      }

      if (e.response?.statusCode == 401) {
        return Failure(error: 'Session expired. Please login again.');
      }

      return Failure(
        error:
            responseData?['message'] ??
            'Payment failed with status ${e.response?.statusCode}',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Failure(error: 'Connection timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return Failure(error: 'No internet connection');
    }

    return Failure(error: 'An unexpected payment error occurred');
  }
}
