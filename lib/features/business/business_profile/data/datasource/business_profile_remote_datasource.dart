import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/business/business_profile/data/model/business_profile_model.dart';
import 'package:pet_connect/features/business/business_profile/domain/entity/business_profile_entity.dart';

final businessProfileRemoteDataSourceProvider =
    Provider<BusinessProfileRemoteDataSource>(
      (ref) => BusinessProfileRemoteDataSource(
        ref.read(httpServiceProvider),
        ref.read(flutterSecureStorageProvider),
      ),
    );

class BusinessProfileRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  BusinessProfileRemoteDataSource(this.dio, this.secureStorage);

  /// Get current business profile
  Future<Either<Failure, BusinessProfileEntity>> getBusinessProfile() async {
    try {
      final token = await secureStorage.read(key: 'businessAuthToken');

      if (token == null) {
        return Left(Failure(error: 'Not authenticated'));
      }

      final response = await dio.get(
        ApiEndpoints.businessMe,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final businessData = data['business'] ?? data;
        final apiModel = BusinessProfileApiModel.fromJson(businessData);
        return Right(apiModel.toEntity());
      } else {
        return Left(
          Failure(
            error: response.data['message'] ?? 'Failed to fetch profile',
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? e.message ?? 'Network error',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    }
  }

  /// Create business profile
  Future<Either<Failure, bool>> createProfile(
    BusinessProfileEntity profile,
  ) async {
    try {
      final token = await secureStorage.read(key: 'businessAuthToken');

      if (token == null) {
        return Left(Failure(error: 'Not authenticated'));
      }

      final data = <String, dynamic>{
        'businessName': profile.businessName,
        'phoneNumber': profile.phoneNumber,
        'address': profile.address ?? '',
        'adoptionPolicy': profile.adoptionPolicy ?? '',
      };

      if (profile.location != null) {
        data['latitude'] = profile.location!.latitude;
        data['longitude'] = profile.location!.longitude;
      }

      final response = await dio.post(
        ApiEndpoints.businessProfile,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'] ?? 'Failed to create profile',
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? e.message ?? 'Network error',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    }
  }

  /// Update business profile
  Future<Either<Failure, bool>> updateProfile(
    BusinessProfileEntity profile,
  ) async {
    try {
      final token = await secureStorage.read(key: 'businessAuthToken');

      if (token == null) {
        return Left(Failure(error: 'Not authenticated'));
      }

      final data = <String, dynamic>{
        'businessName': profile.businessName,
        'phoneNumber': profile.phoneNumber,
        'address': profile.address ?? '',
        'adoptionPolicy': profile.adoptionPolicy ?? '',
      };

      if (profile.location != null) {
        data['latitude'] = profile.location!.latitude;
        data['longitude'] = profile.location!.longitude;
      }

      final response = await dio.put(
        ApiEndpoints.updateBusinessProfile,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'] ?? 'Failed to update profile',
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? e.message ?? 'Network error',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    }
  }

  /// Get business details (public)
  Future<Either<Failure, BusinessProfileEntity>> getBusinessDetails(
    String businessId,
  ) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.businessBaseUrl}$businessId',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final businessData = data['business'] ?? data;
        final apiModel = BusinessProfileApiModel.fromJson(businessData);
        return Right(apiModel.toEntity());
      } else {
        return Left(
          Failure(
            error: response.data['message'] ?? 'Business not found',
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? e.message ?? 'Network error',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    }
  }

  /// Upload documents (reusing auth logic but with auth token)
  Future<Either<Failure, bool>> uploadDocuments(List<String> filePaths) async {
    try {
      final token = await secureStorage.read(key: 'businessAuthToken');

      if (token == null) {
        return Left(Failure(error: 'Authentication token not found'));
      }

      int successCount = 0;

      for (var path in filePaths) {
        try {
          final formData = FormData();
          formData.files.add(
            MapEntry(
              'document',
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );

          final response = await dio.post(
            ApiEndpoints.businessDocuments,
            data: formData,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
              contentType: null,
            ),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            successCount++;
          }
        } catch (e) {
          print('Failed to upload file: $path - Error: $e');
        }
      }

      if (successCount == filePaths.length) {
        return const Right(true);
      } else if (successCount > 0) {
        return Left(
          Failure(error: 'Uploaded $successCount of ${filePaths.length} files'),
        );
      } else {
        return Left(Failure(error: 'Failed to upload documents'));
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to upload documents',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e', statusCode: '0'));
    }
  }
}
