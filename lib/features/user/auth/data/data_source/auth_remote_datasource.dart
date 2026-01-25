import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';

import '../../domain/entity/auth_entity.dart';
import '../model/auth_api_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AuthRemoteDataSource(this.dio, this.secureStorage);

  // features/user/auth/data/data_source/auth_remote_datasource.dart
  Future<Either<Failure, bool>> registerUser(AuthEntity user) async {
    try {
      AuthApiModel apiModel = AuthApiModel.fromEntity(user);
      Response response = await dio.post(
        ApiEndpoints.userRegister,
        data: {
          "fullName": apiModel.fullName,
          "username": apiModel.username,
          "email": apiModel.email,
          "password": apiModel.password,
          "phoneNumber": apiModel.phoneNumber,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await secureStorage.write(
          key: 'user_fullName',
          value: apiModel.fullName,
        );
        await secureStorage.write(key: 'user_email', value: apiModel.email);
        await secureStorage.write(
          key: 'user_phoneNumber',
          value: apiModel.phoneNumber,
        );
        final userJson = apiModel.toJson();
        await secureStorage.write(
          key: 'user_data',
          value: jsonEncode(userJson),
        );

        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
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

  Future<Either<Failure, bool>> verifyOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        ApiEndpoints.userVerifyEmail,
        data: {"email": email, "otp": otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(Failure(error: response.data["message"] ?? "Invalid OTP"));
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?["message"] ?? "Verification failed",
          statusCode: e.response?.statusCode.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, bool>> resendOtp(String email) async {
    try {
      final response = await dio.post(
        ApiEndpoints.userResendOTP,
        data: {"email": email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"] ?? "Failed to resend OTP",
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?["message"] ?? "Resend failed",
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> loginUser(String email, String password) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.userLogin,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic>? responseData =
            response.data as Map<String, dynamic>?;

        if (responseData != null && responseData.containsKey('token')) {
          final token = responseData['token'];
          await secureStorage.write(key: "authenticationToken", value: token);

          // Simply return success if token exists, no need to verify email
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
}
