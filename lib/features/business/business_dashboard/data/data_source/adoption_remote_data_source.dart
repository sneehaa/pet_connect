import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/business/business_dashboard/data/model/adoption_model.dart';

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

  Future<String?> _getAuthToken() async {
    return await secureStorage.read(key: 'businessAuthToken');
  }

  Future<Either<Failure, List<BusinessAdoptionModel>>>
  getBusinessAdoptions() async {
    try {
      final token = await _getAuthToken();
      final response = await dio.get(
        ApiEndpoints.getBusinessAdoptions,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final adoptions = (response.data['adoptions'] as List)
          .map((e) => BusinessAdoptionModel.fromJson(e))
          .toList();
      return Right(adoptions);
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? 'Failed to fetch adoptions',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<BusinessAdoptionModel>>> getPetAdoptions(
    String petId,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.get(
        ApiEndpoints.getPetAdoptions(petId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final adoptions = (response.data['adoptions'] as List)
          .map((e) => BusinessAdoptionModel.fromJson(e))
          .toList();
      return Right(adoptions);
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? 'Failed to fetch applications',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, BusinessAdoptionModel>> updateAdoptionStatus({
    required String adoptionId,
    required String status,
    String? rejectionReason,
  }) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.put(
        ApiEndpoints.updateAdoptionStatus(adoptionId),
        data: {
          'status': status,
          if (rejectionReason != null) 'reason': rejectionReason,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(BusinessAdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? 'Update failed',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, BusinessAdoptionModel>> approveAdoption(
    String adoptionId,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.put(
        ApiEndpoints.updateAdoptionStatus(adoptionId),
        data: {'status': 'approved'},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(BusinessAdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? 'Approval failed',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, BusinessAdoptionModel>> rejectAdoption(
    String adoptionId,
    String reason,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.put(
        ApiEndpoints.updateAdoptionStatus(adoptionId),
        data: {'status': 'rejected', 'reason': reason},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(BusinessAdoptionModel.fromJson(response.data['adoption']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? 'Rejection failed',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, BusinessAdoptionModel>> getAdoptionById(
    String adoptionId,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.get(
        ApiEndpoints.getAdoptionById(adoptionId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return Right(BusinessAdoptionModel.fromJson(response.data['adoption']));
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
}
