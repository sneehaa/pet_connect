import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/business/business_auth/data/model/business_api_model.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';

final businessRemoteDataSourceProvider = Provider<BusinessRemoteDataSource>(
  (ref) => BusinessRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class BusinessRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  BusinessRemoteDataSource(this.dio, this.secureStorage);


  Future<Either<Failure, bool>> registerBusiness(
    BusinessEntity business,
  ) async {
    try {
      final apiModel = BusinessApiModel.fromEntity(business);

      final formData = FormData();
      formData.fields.addAll([
        MapEntry('businessName', apiModel.businessName),
        MapEntry('username', apiModel.username),
        MapEntry('email', apiModel.email),
        MapEntry('password', apiModel.password),
        MapEntry('phoneNumber', apiModel.phoneNumber),
      ]);

      if (apiModel.address != null && apiModel.address!.isNotEmpty) {
        formData.fields.add(MapEntry('address', apiModel.address!));
      }

      if (apiModel.adoptionPolicy != null &&
          apiModel.adoptionPolicy!.isNotEmpty) {
        formData.fields.add(
          MapEntry('adoptionPolicy', apiModel.adoptionPolicy!),
        );
      }

      if (business.profileImagePath != null &&
          business.profileImagePath!.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await MultipartFile.fromFile(
              business.profileImagePath!,
              filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }

      final response = await dio.post(
        ApiEndpoints.businessRegister,
        data: formData,
        options: Options(contentType: null),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempToken = response.data['tempToken'];
        if (tempToken != null) {
          await secureStorage.write(key: "businessTempToken", value: tempToken);
        }
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"] ?? "Unknown error",
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      print('Registration error: ${e.message}');
      print('Error type: ${e.type}');
      print('Response data: ${e.response?.data}');

      return Left(
        Failure(
          error:
              e.response?.data?["message"] ??
              e.message ??
              "Registration failed",
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> verifyOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        ApiEndpoints.businessVerifyEmail,
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

  Future<Either<Failure, bool>> loginBusiness(
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.businessLogin,
        data: {"email": email, "password": password},
      );

      final responseData = response.data as Map<String, dynamic>?;
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Left(
          Failure(
            error: responseData?['message'] ?? 'Invalid credentials',
            statusCode: response.statusCode.toString(),
          ),
        );
      }

      if (responseData == null) {
        return Left(Failure(error: 'Invalid response from server'));
      }

      if (responseData['businessStatus'] == 'pending') {
        return Left(
          Failure(
            error: 'Your business is under review. Please wait for approval.',
          ),
        );
      }

      if (responseData['businessStatus'] == 'rejected') {
        return Left(
          Failure(
            error:
                'Your business verification was rejected. Please contact support.',
          ),
        );
      }

      if (!responseData.containsKey('token')) {
        return Left(Failure(error: 'No authentication token received'));
      }

      final token = responseData['token'];
      await secureStorage.write(key: 'businessAuthToken', value: token);

      String? businessId;
      try {
        final decodedToken = JwtDecoder.decode(token);
        businessId =
            decodedToken['businessId'] ??
            decodedToken['business_id'] ??
            decodedToken['id'] ??
            decodedToken['sub'];
      } catch (_) {}

      if (responseData['business'] != null) {
        businessId ??= (responseData['business'] as Map<String, dynamic>)['_id']
            ?.toString();
      } else {
        businessId ??=
            responseData['businessId']?.toString() ??
            responseData['userId']?.toString();
      }

      if (businessId != null) {
        await secureStorage.write(key: 'businessId', value: businessId);
      }

      return const Right(true);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(Failure(error: 'Connection timeout. Please try again.'));
      }
      if (e.type == DioExceptionType.badResponse) {
        final data = e.response?.data;
        return Left(
          Failure(
            error: data is Map<String, dynamic>
                ? data['message'] ?? 'Server error'
                : 'Server error. Please try again later.',
          ),
        );
      }
      return Left(Failure(error: 'Network error. Please try again.'));
    } catch (_) {
      return Left(Failure(error: 'Something went wrong. Please try again.'));
    }
  }

  Future<Either<Failure, bool>> uploadProfileImage(String imagePath) async {
    try {
      final token = await secureStorage.read(key: "businessAuthToken");
      if (token == null) {
        return Left(Failure(error: "Authentication token not found"));
      }

      final formData = FormData.fromMap({
        "profileImage": await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await dio.put(
        ApiEndpoints.businessProfileImage,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          contentType: null,
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'] ?? 'Failed to upload profile image',
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.response?.data?['message'] ?? 'Profile image upload failed',
          statusCode: e.response?.statusCode.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, bool>> uploadDocuments(List<String> filePaths) async {
    try {
      // Use temp token if available
      String? token = await secureStorage.read(key: "businessTempToken");
      if (token == null) {
        token = await secureStorage.read(key: "businessAuthToken");
        if (token == null) {
          return Left(Failure(error: "Authentication token not found"));
        }
      }

      int successCount = 0;

      // Upload files one by one
      for (var path in filePaths) {
        try {
          final formData = FormData();

          // Use "document" (singular) as backend expects
          formData.files.add(
            MapEntry(
              'document', // Changed from 'documents' to 'document'
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
        // Delete temp token after successful upload
        await secureStorage.delete(key: "businessTempToken");
        return const Right(true);
      } else if (successCount > 0) {
        return Left(
          Failure(error: 'Uploaded $successCount of ${filePaths.length} files'),
        );
      } else {
        return Left(Failure(error: 'Failed to upload documents'));
      }
    } on DioException catch (e) {
      print('DioException: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');

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
      print('Unexpected error: $e');
      return Left(Failure(error: 'Unexpected error: $e', statusCode: '0'));
    }
  }


  Future<Either<Failure, bool>> resendOtp(String email) async {
    try {
      final response = await dio.post(
        ApiEndpoints.businessResendOTP,
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
}
