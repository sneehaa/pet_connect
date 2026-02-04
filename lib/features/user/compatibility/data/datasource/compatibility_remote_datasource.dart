import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/user/compatibility/data/model/compatibility_model.dart';

final compatibilityRemoteDataSourceProvider =
    Provider<CompatibilityRemoteDataSource>((ref) {
      return CompatibilityRemoteDataSource(
        ref.read(httpServiceProvider),
        ref.read(flutterSecureStorageProvider),
      );
    });

class CompatibilityRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  CompatibilityRemoteDataSource(this.dio, this.secureStorage);

  Future<String?> _getAuthToken() async {
    return await secureStorage.read(key: 'authenticationToken');
  }

  Future<Either<Failure, CompatibilityModel>> submitQuestionnaire(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _getAuthToken();

      final response = await dio.post(
        ApiEndpoints.submitQuestionnaire,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        return Right(
          CompatibilityModel.fromJson(response.data['questionnaire']),
        );
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  Future<Either<Failure, CompatibilityModel>> getQuestionnaire() async {
    try {
      final token = await _getAuthToken();

      final response = await dio.get(
        ApiEndpoints.getQuestionnaire,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        return Right(
          CompatibilityModel.fromJson(response.data['questionnaire']),
        );
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  Future<Either<Failure, CompatibilityResultModel>> getCompatibilityWithPet(
    String petId,
  ) async {
    try {
      final token = await _getAuthToken();

      final response = await dio.get(
        ApiEndpoints.getCompatibilityWithPet(petId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        return Right(CompatibilityResultModel.fromJson(response.data));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  Future<Either<Failure, List<CompatibilityResultModel>>> getCompatibilityAll({
    int limit = 50,
    int page = 1,
  }) async {
    try {
      final token = await _getAuthToken();

      final response = await dio.get(
        ApiEndpoints.getCompatibilityAll,
        queryParameters: {'limit': limit, 'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        final results = (response.data['results'] as List)
            .map((e) => CompatibilityResultModel.fromJson(e))
            .toList();
        return Right(results);
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  Future<Either<Failure, bool>> deleteQuestionnaire() async {
    try {
      final token = await _getAuthToken();

      final response = await dio.delete(
        ApiEndpoints.deleteQuestionnaire,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        return Right(true);
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
