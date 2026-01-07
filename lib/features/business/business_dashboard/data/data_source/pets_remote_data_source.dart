import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';

import '../../domain/entity/pet_entity.dart';
import '../model/pet_model.dart';

final petsRemoteDataSourceProvider = Provider<PetsRemoteDataSource>(
  (ref) => PetsRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class PetsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  PetsRemoteDataSource(this.dio, this.secureStorage);

  // Helper method to get auth token
  Future<String?> _getAuthToken() async {
    final token = await secureStorage.read(key: 'businessAuthToken');
    if (token == null) {
      throw Exception('No authentication token found');
    }
    return token;
  }

  Future<Either<Failure, List<PetModel>>> getPetsByBusiness(
    String businessId,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.get(
        '/pets/business/$businessId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final pets = (response.data['pets'] as List)
          .map((e) => PetModel.fromJson(e))
          .toList();
      return Right(pets);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to fetch pets',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, PetModel>> addPet(
    PetEntity pet,
    List<String>? photoPaths,
  ) async {
    try {
      final token = await _getAuthToken();
      final petModel = PetModel(
        id: pet.id,
        name: pet.name,
        breed: pet.breed,
        age: pet.age,
        gender: pet.gender,
        vaccinated: pet.vaccinated,
        description: pet.description,
        personality: pet.personality,
        medicalInfo: pet.medicalInfo,
        photos: pet.photos,
        available: pet.available,
      );

      final formData = FormData.fromMap(petModel.toJson());

      if (photoPaths != null && photoPaths.isNotEmpty) {
        for (var path in photoPaths) {
          formData.files.add(
            MapEntry(
              'photos',
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await dio.post(
        '/pets',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: null,
        ),
      );

      return Right(PetModel.fromJson(response.data['pet']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ?? e.message ?? 'Failed to add pet',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, PetModel>> updatePet(
    PetEntity pet,
    List<String>? photoPaths,
  ) async {
    try {
      final token = await _getAuthToken();
      final petModel = PetModel(
        id: pet.id,
        name: pet.name,
        breed: pet.breed,
        age: pet.age,
        gender: pet.gender,
        vaccinated: pet.vaccinated,
        description: pet.description,
        personality: pet.personality,
        medicalInfo: pet.medicalInfo,
        photos: pet.photos,
        available: pet.available,
      );

      final formData = FormData.fromMap(petModel.toJson());

      if (photoPaths != null && photoPaths.isNotEmpty) {
        for (var path in photoPaths) {
          formData.files.add(
            MapEntry(
              'photos',
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await dio.put(
        '/pets/${pet.id}',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: null,
        ),
      );

      return Right(PetModel.fromJson(response.data['pet']));
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to update pet',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, bool>> deletePet(String petId) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.delete(
        '/pets/$petId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return Right(response.data['success'] ?? false);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to delete pet',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, bool>> updatePetStatus(
    String petId,
    bool available,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await dio.patch(
        '/pets/$petId/status',
        data: {'available': available},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return Right(response.data['success'] ?? false);
    } on DioException catch (e) {
      return Left(
        Failure(
          error:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to update pet status',
          statusCode: e.response?.statusCode?.toString() ?? '0',
        ),
      );
    } catch (e) {
      return Left(Failure(error: 'Unexpected error: $e'));
    }
  }
}
