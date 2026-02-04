import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/user/compatibility/data/repository/compatibility_remote_repository.dart';
import 'package:pet_connect/features/user/compatibility/domain/entity/compatibility_entity.dart';
import 'package:pet_connect/features/user/compatibility/domain/repository/compatibility_repository.dart';

// Submit questionnaire use case
final submitQuestionnaireUseCaseProvider =
    Provider.autoDispose<SubmitQuestionnaireUseCase>((ref) {
      return SubmitQuestionnaireUseCase(
        ref.read(compatibilityRepositoryProvider),
      );
    });

class SubmitQuestionnaireUseCase {
  final CompatibilityRepository repository;
  SubmitQuestionnaireUseCase(this.repository);

  Future<Either<Failure, CompatibilityEntity>> execute(
    Map<String, dynamic> data,
  ) {
    return repository.submitQuestionnaire(data);
  }
}

// Get questionnaire use case
final getQuestionnaireUseCaseProvider =
    Provider.autoDispose<GetQuestionnaireUseCase>((ref) {
      return GetQuestionnaireUseCase(ref.read(compatibilityRepositoryProvider));
    });

class GetQuestionnaireUseCase {
  final CompatibilityRepository repository;
  GetQuestionnaireUseCase(this.repository);

  Future<Either<Failure, CompatibilityEntity>> execute() {
    return repository.getQuestionnaire();
  }
}

// Get compatibility with pet use case
final getCompatibilityWithPetUseCaseProvider =
    Provider.autoDispose<GetCompatibilityWithPetUseCase>((ref) {
      return GetCompatibilityWithPetUseCase(
        ref.read(compatibilityRepositoryProvider),
      );
    });

class GetCompatibilityWithPetUseCase {
  final CompatibilityRepository repository;
  GetCompatibilityWithPetUseCase(this.repository);

  Future<Either<Failure, CompatibilityResultEntity>> execute(String petId) {
    return repository.getCompatibilityWithPet(petId);
  }
}

// Get all compatibility scores use case
final getCompatibilityAllUseCaseProvider =
    Provider.autoDispose<GetCompatibilityAllUseCase>((ref) {
      return GetCompatibilityAllUseCase(
        ref.read(compatibilityRepositoryProvider),
      );
    });

class GetCompatibilityAllUseCase {
  final CompatibilityRepository repository;
  GetCompatibilityAllUseCase(this.repository);

  Future<Either<Failure, List<CompatibilityResultEntity>>> execute({
    int limit = 50,
    int page = 1,
  }) {
    return repository.getCompatibilityAll(limit: limit, page: page);
  }
}

// Delete questionnaire use case
final deleteQuestionnaireUseCaseProvider =
    Provider.autoDispose<DeleteQuestionnaireUseCase>((ref) {
      return DeleteQuestionnaireUseCase(
        ref.read(compatibilityRepositoryProvider),
      );
    });

class DeleteQuestionnaireUseCase {
  final CompatibilityRepository repository;
  DeleteQuestionnaireUseCase(this.repository);

  Future<Either<Failure, bool>> execute() {
    return repository.deleteQuestionnaire();
  }
}
