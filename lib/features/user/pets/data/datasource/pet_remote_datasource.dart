import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

final petRemoteDataSourceProvider = Provider<PetRemoteDataSource>((ref) {
  return PetRemoteDataSource(ref.read(httpServiceProvider));
});

class PetRemoteDataSource {
  final Dio dio;

  PetRemoteDataSource(this.dio);

  // Get all pets
  Future<Either<Failure, List<UserPetEntity>>> getAllPets() async {
    try {
      final response = await dio.get(ApiEndpoints.getAllPets());

      if (response.data['success'] == true) {
        final pets = (response.data['pets'] as List)
            .map((e) => UserPetEntity.fromJson(e))
            .toList();
        return Right(pets);
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Get pet by ID
  Future<Either<Failure, UserPetEntity>> getPetById(String petId) async {
    try {
      final response = await dio.get(ApiEndpoints.getPetDetail(petId));

      if (response.data['success'] == true) {
        return Right(UserPetEntity.fromJson(response.data['pet']));
      } else {
        return Left(Failure(error: response.data['message']));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  // Get pets by business ID
  Future<Either<Failure, List<UserPetEntity>>> getPetsByBusiness(
    String businessId,
  ) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getPetsByBusiness(businessId),
      );

      if (response.data['success'] == true) {
        final pets = (response.data['pets'] as List)
            .map((e) => UserPetEntity.fromJson(e))
            .toList();
        return Right(pets);
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
