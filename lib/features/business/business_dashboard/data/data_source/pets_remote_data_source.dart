import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/config/constants/api_endpoints.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/network/http_service.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/business/business_dashboard/data/model/pet_model.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';

final petsRemoteDataSourceProvider = Provider<PetsRemoteDataSource>((ref) {
  return PetsRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  );
});

class PetsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  PetsRemoteDataSource(this.dio, this.secureStorage);

  Future<String?> _getBusinessAuthToken() async {
    return await secureStorage.read(key: 'businessAuthToken');
  }

  Future<bool> _isBusinessAuthenticated() async {
    final token = await _getBusinessAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _validateBusinessAuth() async {
    if (!await _isBusinessAuthenticated()) {
      throw Exception(
        'Business authentication required. Please login as business.',
      );
    }
  }

  Future<Either<Failure, PetEntity>> addPet(
    PetEntity pet,
    List<String>? photoPaths,
  ) async {
    try {
      await _validateBusinessAuth();
      final token = await _getBusinessAuthToken();

      final response = await dio.post(
        ApiEndpoints.createPet(),
        data: _buildPetFormData(pet, photoPaths),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          contentType: null, 
        ),
      );

      return Right(PetModel.fromJson(response.data['pet']));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(Failure(error: 'Authentication error: $e'));
    }
  }

  Future<Either<Failure, PetEntity>> updatePet(
    PetEntity pet,
    List<String>? photoPaths,
    String petId,
  ) async {
    try {
      await _validateBusinessAuth();
      final token = await _getBusinessAuthToken();

      final response = await dio.put(
        ApiEndpoints.updatePet(petId),
        data: _buildPetFormData(pet, photoPaths),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          contentType: null,
        ),
      );

      return Right(PetModel.fromJson(response.data['pet']));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(Failure(error: 'Authentication error: $e'));
    }
  }

  Future<Either<Failure, List<PetEntity>>> getPetsByBusiness(
    String businessId,
  ) async {
    try {
      final token = await _getBusinessAuthToken();

      final response = await dio.get(
        ApiEndpoints.getPetsByBusiness(businessId),
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        ),
      );

      final pets = (response.data['pets'] as List)
          .map((e) => PetModel.fromJson(e))
          .toList();

      return Right(pets);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    }
  }

  Future<Either<Failure, bool>> deletePet(String petId) async {
    try {
      await _validateBusinessAuth();
      final token = await _getBusinessAuthToken();

      await dio.delete(
        ApiEndpoints.deletePet(petId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(Failure(error: 'Authentication error: $e'));
    }
  }

  Future<Either<Failure, bool>> updatePetStatus(
    String petId,
    bool available,
  ) async {
    try {
      await _validateBusinessAuth();
      final token = await _getBusinessAuthToken();

      await dio.patch(
        "${ApiEndpoints.petsBaseUrl}$petId/status",
        data: {'available': available},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(Failure(error: 'Authentication error: $e'));
    }
  }

  // ---------------- HELPERS ----------------

  FormData _buildPetFormData(PetEntity pet, List<String>? photoPaths) {
    final formData = FormData.fromMap({
      'name': pet.name,
      'breed': pet.breed,
      'age': pet.age,
      'gender': pet.gender,
      'vaccinated': pet.vaccinated,
      'available': pet.available,
      if (pet.description?.isNotEmpty == true) 'description': pet.description,
      if (pet.personality?.isNotEmpty == true) 'personality': pet.personality,
      if (pet.medicalInfo?.isNotEmpty == true) 'medicalInfo': pet.medicalInfo,
    });

    if (pet.photos != null) {
      for (final url in pet.photos!) {
        formData.fields.add(MapEntry('existingPhotos[]', url));
      }
    }

    if (photoPaths != null) {
      for (final path in photoPaths) {
        formData.files.add(
          MapEntry('photos', MultipartFile.fromFileSync(path)),
        );
      }
    }

    return formData;
  }

  Failure _mapDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        return Failure(error: 'Session expired. Please login again.');
      }

      return Failure(
        error:
            e.response?.data?['message'] ??
            'Request failed with status ${e.response?.statusCode}',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Failure(error: 'Connection timeout');
    }

    return Failure(error: 'No internet connection');
  }
}
