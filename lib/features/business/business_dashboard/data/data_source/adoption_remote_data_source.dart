import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';

import '../model/adoption_model.dart';

final adoptionRemoteDataSourceProvider = Provider<AdoptionRemoteDataSource>(
  (ref) => AdoptionRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class AdoptionRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AdoptionRemoteDataSource(this.dio, this.secureStorage);

  // Helper method to get auth token
  Future<String?> _getAuthToken() async {
    // Try user token first, then business token
    final userToken = await secureStorage.read(key: 'authToken');
    if (userToken != null) return userToken;

    final businessToken = await secureStorage.read(key: 'businessAuthToken');
    if (businessToken != null) return businessToken;

    throw Exception('No authentication token found');
  }

  // Helper method to get user ID from token
  Future<String?> _getUserIdFromToken() async {
    final token = await _getAuthToken();
    if (token == null) return null;

    try {
      // Decode JWT token to get user ID
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      return payloadMap['userId']?.toString() ?? payloadMap['_id']?.toString();
    } catch (e) {
      return null;
    }
  }

  Future<Either<Failure, AdoptionModel>> applyAdoption(
    String petId,
    String message,
  ) async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserIdFromToken();

      if (userId == null) {
        return Left(Failure(error: 'User not authenticated'));
      }

      final response = await dio.post(
        '/pets/$petId/adopt',
        data: {'message': message},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(AdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to apply for adoption',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, AdoptionModel>> getAdoptionStatus(String petId) async {
    try {
      final token = await _getAuthToken();

      final response = await dio.get(
        '/pets/$petId/status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(AdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(Failure(error: 'No adoption application found'));
      }
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to get adoption status',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, List<AdoptionModel>>> getAdoptionHistory() async {
    try {
      final token = await _getAuthToken();

      final response = await dio.get(
        '/history',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final adoptions = (response.data['adoptions'] as List)
          .map((e) => AdoptionModel.fromJson(e))
          .toList();
      return Right(adoptions);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to get adoption history',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, List<AdoptionModel>>> getPetAdoptions(
    String petId,
  ) async {
    try {
      final token = await _getAuthToken();

      final response = await dio.get(
        '/pets/$petId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final adoptions = (response.data['adoptions'] as List)
          .map((e) => AdoptionModel.fromJson(e))
          .toList();
      return Right(adoptions);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to get pet adoptions',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, AdoptionModel>> updateAdoptionStatus(
    String adoptionId,
    String status,
  ) async {
    try {
      final token = await _getAuthToken();

      final response = await dio.put(
        '/$adoptionId/status',
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(AdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to update adoption status',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }
}
