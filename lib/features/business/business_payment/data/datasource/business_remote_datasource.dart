// lib/features/business/payment/data/datasource/business_payment_remote_datasource.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/business/business_payment/data/model/business_payment_model.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

final businessPaymentRemoteDataSourceProvider =
    Provider<BusinessPaymentRemoteDataSource>((ref) {
      return BusinessPaymentRemoteDataSource(
        ref.read(httpServiceProvider),
        ref.read(flutterSecureStorageProvider),
      );
    });

class BusinessPaymentRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  BusinessPaymentRemoteDataSource(this.dio, this.secureStorage);

  Future<String?> _getBusinessAuthToken() async {
    return await secureStorage.read(key: 'businessAuthToken');
  }

  Future<void> _validateBusinessAuth() async {
    final token = await _getBusinessAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('Business authentication required. Please login.');
    }
  }

  // Get business earnings (history and stats)
  Future<Either<Failure, BusinessEarningsResponse>> getBusinessEarnings({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await _validateBusinessAuth();
      final token = await _getBusinessAuthToken();

      final response = await dio.get(
        ApiEndpoints.getBusinessEarnings,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(BusinessEarningsResponse.fromJson(response.data));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Get business wallet balance
  Future<Either<Failure, double>> getBusinessWalletBalance() async {
    try {
      await _validateBusinessAuth();
      final token = await _getBusinessAuthToken();

      final response = await dio.get(
        ApiEndpoints.getBusinessWalletBalance,
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

  // Get business transactions
  Future<Either<Failure, Map<String, dynamic>>> getBusinessTransactions({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await _validateBusinessAuth();
      final token = await _getBusinessAuthToken();

      final response = await dio.get(
        ApiEndpoints.getBusinessWalletTransactions,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right({
          'totalEarnings': response.data['totalEarnings']?.toDouble() ?? 0.0,
          'totalTransactions': response.data['totalTransactions']?.toInt() ?? 0,
          'recentTransactions': (response.data['recentTransactions'] as List)
              .map((txn) => TransactionModel.fromJson(txn))
              .toList(),
        });
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
          error: responseData['message'] ?? 'Business payment request failed',
        );
      }

      if (e.response?.statusCode == 401) {
        return Failure(error: 'Session expired. Please login again.');
      }

      if (e.response?.statusCode == 403) {
        return Failure(error: 'Access denied. Business account required.');
      }

      return Failure(
        error:
            responseData?['message'] ??
            'Business payment failed with status ${e.response?.statusCode}',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Failure(error: 'Connection timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return Failure(error: 'No internet connection');
    }

    return Failure(error: 'An unexpected business payment error occurred');
  }
}
