import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/user/profile/data/model/profile_model.dart';
import 'package:pet_connect/features/user/profile/domain/entity/profile_entity.dart';

final userProfileRemoteDataSourceProvider =
    Provider<UserProfileRemoteDataSource>((ref) {
      return UserProfileRemoteDataSource(
        ref.read(httpServiceProvider),
        ref.read(flutterSecureStorageProvider),
      );
    });

class UserProfileRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  UserProfileRemoteDataSource(this.dio, this.secureStorage);

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

  // Get user profile
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();
      final userId = await _getUserId();

      if (userId == null) {
        return Left(Failure(error: 'User ID not found'));
      }

      final response = await dio.get(
        ApiEndpoints.getUserProfile(userId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(UserProfileModel.fromJson(response.data['user']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Update user profile
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
    UserProfileEntity profile,
  ) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();
      final userId = await _getUserId();

      if (userId == null) {
        return Left(Failure(error: 'User ID not found'));
      }

      final response = await dio.put(
        ApiEndpoints.editUserProfile(userId),
        data: profile.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return Right(UserProfileModel.fromJson(response.data['user']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Change password
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();
      final userId = await _getUserId();

      if (userId == null) {
        return Left(Failure(error: 'User ID not found'));
      }

      final response = await dio.post(
        '${ApiEndpoints.baseUrl}/api/user/change-password',
        data: {
          'userId': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return const Right(true);
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Delete account
  Future<Either<Failure, bool>> deleteAccount() async {
    try {
      await _validateUserAuth();
      final token = await _getUserAuthToken();
      final userId = await _getUserId();

      if (userId == null) {
        return Left(Failure(error: 'User ID not found'));
      }

      final response = await dio.delete(
        ApiEndpoints.deleteUserAccount(userId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        // Clear stored credentials
        await secureStorage.delete(key: 'userAuthToken');
        await secureStorage.delete(key: 'userId');

        return const Right(true);
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
        return Failure(error: responseData['message'] ?? 'Request failed');
      }

      if (e.response?.statusCode == 401) {
        return Failure(error: 'Session expired. Please login again.');
      }

      return Failure(
        error:
            responseData?['message'] ??
            'Request failed with status ${e.response?.statusCode}',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Failure(error: 'Connection timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return Failure(error: 'No internet connection');
    }

    return Failure(error: 'An unexpected error occurred');
  }
}
