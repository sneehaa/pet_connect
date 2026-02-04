import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/features/user/compatibility/data/model/compatibility_model.dart';

final compatibilityRemoteDataSourceProvider =
    Provider<CompatibilityRemoteDataSource>((ref) {
      return CompatibilityRemoteDataSource(ref.read(httpServiceProvider));
    });

class CompatibilityRemoteDataSource {
  final Dio dio;

  CompatibilityRemoteDataSource(this.dio);

  // Submit questionnaire
  Future<Either<Failure, CompatibilityModel>> submitQuestionnaire(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.submitQuestionnaire,
        data: data,
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

  // Get user's questionnaire
  Future<Either<Failure, CompatibilityModel>> getQuestionnaire() async {
    try {
      final response = await dio.get(ApiEndpoints.getQuestionnaire);

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

  // Get compatibility with specific pet
  Future<Either<Failure, CompatibilityResultModel>> getCompatibilityWithPet(
    String petId,
  ) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getCompatibilityWithPet(petId),
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

  // Get compatibility with all pets
  Future<Either<Failure, List<CompatibilityResultModel>>> getCompatibilityAll({
    int limit = 50,
    int page = 1,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getCompatibilityAll,
        queryParameters: {'limit': limit, 'page': page},
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

  // Delete questionnaire
  Future<Either<Failure, bool>> deleteQuestionnaire() async {
    try {
      final response = await dio.delete(ApiEndpoints.deleteQuestionnaire);

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
