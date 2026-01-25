import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/notifications/data/model/notification_model.dart';

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>(
      (ref) => NotificationRemoteDataSource(
        ref.read(httpServiceProvider),
        ref.read(flutterSecureStorageProvider),
      ),
    );

class NotificationRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  NotificationRemoteDataSource(this.dio, this.secureStorage);

  // Helper method to determine which token to use
  Future<String?> _getAuthToken({required bool isUser}) async {
    if (isUser) {
      // Get user token
      return await secureStorage.read(key: 'authenticationToken');
    } else {
      // Get business token
      return await secureStorage.read(key: 'businessAuthToken');
    }
  }

  Future<Either<Failure, List<NotificationModel>>>
  getUserNotifications() async {
    try {
      // Use user token for user notifications
      final token = await _getAuthToken(isUser: true);

      if (token == null) {
        return Left(Failure(error: 'User authentication token not found'));
      }

      final response = await dio.get(
        ApiEndpoints.getUserNotifications,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final notifications = (response.data['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
      return Right(notifications);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              'Failed to fetch user notifications',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<NotificationModel>>>
  getBusinessNotifications() async {
    try {
      // Use business token for business notifications
      final token = await _getAuthToken(isUser: false);

      if (token == null) {
        return Left(Failure(error: 'Business authentication token not found'));
      }

      final response = await dio.get(
        ApiEndpoints.getBusinessNotifications,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final notifications = (response.data['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
      return Right(notifications);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              'Failed to fetch business notifications',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, NotificationModel>> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      // Try both tokens - whichever works
      String? token = await _getAuthToken(isUser: false); // Try business first
      token ??= await _getAuthToken(
        isUser: true,
      ); // If business token not found, try user

      if (token == null) {
        return Left(Failure(error: 'Authentication token not found'));
      }

      final response = await dio.put(
        '${ApiEndpoints.notificationBaseUrl}/$notificationId/read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(NotificationModel.fromJson(response.data['notification']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              'Failed to mark notification as read',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> clearAllNotifications() async {
    try {
      // Try both tokens
      String? token = await _getAuthToken(isUser: false);
      token ??= await _getAuthToken(isUser: true);

      if (token == null) {
        return Left(Failure(error: 'Authentication token not found'));
      }

      final response = await dio.delete(
        '${ApiEndpoints.notificationBaseUrl}/clear',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(response.data['success'] ?? false);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ?? 'Failed to clear notifications',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
