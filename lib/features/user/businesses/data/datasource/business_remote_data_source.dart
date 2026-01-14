import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/features/user/businesses/data/model/business_api_model.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

final businessRemoteDataSourceProvider = Provider<BusinessRemoteDataSource>(
  (ref) => BusinessRemoteDataSource(ref.read(httpServiceProvider)),
);

class BusinessRemoteDataSource {
  final Dio dio;

  BusinessRemoteDataSource(this.dio);

  // Get all businesses
  Future<Either<Failure, List<BusinessEntity>>> getAllBusinesses() async {
    try {
      Response response = await dio.get(ApiEndpoints.businessBaseUrl);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['businesses'] ?? [];
        final List<BusinessEntity> businesses = responseData
            .map((json) => BusinessApiModel.fromJson(json).toEntity())
            .toList();
        return Right(businesses);
      } else {
        return Left(
          Failure(
            error: response.data["message"] ?? "Failed to load businesses",
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

  // Get nearby businesses
  Future<Either<Failure, List<BusinessEntity>>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
  }) async {
    try {
      Response response = await dio.get(
        ApiEndpoints.businessNearby,
        queryParameters: {'latitude': latitude, 'longitude': longitude},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['businesses'] ?? [];
        final List<BusinessEntity> businesses = responseData
            .map((json) => BusinessApiModel.fromJson(json).toEntity())
            .toList();
        return Right(businesses);
      } else {
        return Left(
          Failure(
            error:
                response.data["message"] ?? "Failed to load nearby businesses",
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

  // Get business by ID
  Future<Either<Failure, BusinessEntity>> getBusinessById(
    String businessId,
  ) async {
    try {
      Response response = await dio.get(
        '${ApiEndpoints.businessBaseUrl}/$businessId',
      );

      if (response.statusCode == 200) {
        final business = BusinessApiModel.fromJson(
          response.data['business'],
        ).toEntity();
        return Right(business);
      } else {
        return Left(
          Failure(
            error: response.data["message"] ?? "Business not found",
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
}
