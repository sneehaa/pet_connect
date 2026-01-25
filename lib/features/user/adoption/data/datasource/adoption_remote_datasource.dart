import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/user/adoption/data/model/adoption_model.dart';

final userAdoptionRemoteDataSourceProvider =
    Provider<UserAdoptionRemoteDataSource>(
      (ref) => UserAdoptionRemoteDataSource(
        ref.read(httpServiceProvider),
        ref.read(flutterSecureStorageProvider),
      ),
    );

class UserAdoptionRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  UserAdoptionRemoteDataSource(this.dio, this.secureStorage);

  Future<String?> _getAuthToken() async {
    return await secureStorage.read(key: 'authenticationToken');
  }

  Future<Either<Failure, UserAdoptionModel>> applyAdoption({
    required String petId,
    required Map<String, dynamic> applicationData,
  }) async {
    try {
      final token = await _getAuthToken();

      final response = await dio.post(
        ApiEndpoints.applyForAdoption(petId),
        data: applicationData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return Right(UserAdoptionModel.fromJson(responseData['adoption']));
        } else {
          return Left(
            Failure(error: responseData['message'] ?? 'Submission failed'),
          );
        }
      }

      return Left(Failure(error: 'Unexpected server response format'));
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map
          ? e.response?.data['message']
          : e.message;

      return Left(
        Failure(
          error: errorMessage ?? 'Network Error: ${e.type}',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'An unexpected error occurred: $e'));
    }
  }

  Future<Either<Failure, UserAdoptionModel>> getAdoptionStatus(
    String petId,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.get(
        ApiEndpoints.getAdoptionStatus(petId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(UserAdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ?? 'Failed to fetch adoption status',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<UserAdoptionModel>>> getAdoptionHistory() async {
    try {
      final token = await _getAuthToken();
      final response = await dio.get(
        ApiEndpoints.getUserAdoptions,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final adoptions = (response.data['adoptions'] as List)
          .map((e) => UserAdoptionModel.fromJson(e))
          .toList();
      return Right(adoptions);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              'Failed to fetch adoption history',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, UserAdoptionModel>> getAdoptionById(
    String adoptionId,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.get(
        ApiEndpoints.getAdoptionById(adoptionId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(UserAdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              'Failed to fetch adoption details',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, UserAdoptionModel>> markAdoptionPaid({
    required String adoptionId,
    required String paymentId,
  }) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.patch(
        ApiEndpoints.markAdoptionPaid(adoptionId),
        data: {'paymentId': paymentId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(UserAdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ?? 'Failed to mark adoption as paid',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
