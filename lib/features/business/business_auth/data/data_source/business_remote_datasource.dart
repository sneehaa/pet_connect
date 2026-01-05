import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/business/business_auth/data/model/business_api_model.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';

final businessRemoteDataSourceProvider = Provider<BusinessRemoteDataSource>(
  (ref) => BusinessRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class BusinessRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  BusinessRemoteDataSource(this.dio, this.secureStorage);

  /// Register a new business
  Future<Either<Failure, bool>> registerBusiness(
    BusinessEntity business,
  ) async {
    try {
      BusinessApiModel apiModel = BusinessApiModel.fromEntity(business);

      Response response = await dio.post(
        ApiEndpoints.businessRegister, // e.g., "/business/register"
        data: {
          "businessName": apiModel.businessName,
          "username": apiModel.username,
          "email": apiModel.email,
          "password": apiModel.password,
          "phoneNumber": apiModel.phoneNumber,
          "address": apiModel.address,
          "adoptionPolicy": apiModel.adoptionPolicy,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"] ?? "Unknown error",
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  /// Login business
  Future<Either<Failure, bool>> loginBusiness(
    String username,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.businessLogin,
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic>? responseData =
            response.data as Map<String, dynamic>?;

        if (responseData != null && responseData.containsKey('token')) {
          final token = responseData['token'];
          await secureStorage.write(key: "businessAuthToken", value: token);

          return const Right(true);
        } else {
          return Left(
            Failure(
              error: response.data?['message'] ?? "Token not found",
              statusCode: response.statusCode.toString(),
            ),
          );
        }
      } else {
        return Left(
          Failure(
            error: response.data?['message'] ?? "Unknown error",
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(Failure(error: "Connection timeout. Please try again."));
      } else if (e.type == DioExceptionType.badResponse) {
        return Left(Failure(error: "Server error. Please try again later."));
      } else {
        return Left(Failure(error: "An unexpected error occurred."));
      }
    } catch (e) {
      return Left(Failure(error: "An unexpected error occurred."));
    }
  }

  /// Create or update business profile
  Future<Either<Failure, bool>> createOrUpdateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      // Get token from secure storage
      final token = await secureStorage.read(key: "businessAuthToken");
      if (token == null) {
        return Left(Failure(error: "Authentication token not found"));
      }

      Response response = await dio.post(
        ApiEndpoints.businessProfile, // e.g., "/business/profile"
        data: profileData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data?['message'] ?? "Unknown error",
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: "An unexpected error occurred."));
    }
  }
}
