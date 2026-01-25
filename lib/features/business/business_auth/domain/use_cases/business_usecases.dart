import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/business/business_auth/data/repository/business_remote_repository.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';
import 'package:pet_connect/features/business/business_auth/domain/repository/business_repository.dart';

/// Register Business UseCase
final registerBusinessUseCaseProvider =
    Provider.autoDispose<RegisterBusinessUseCase>(
      (ref) =>
          RegisterBusinessUseCase(ref.read(businessRemoteRepositoryProvider)),
    );

class RegisterBusinessUseCase {
  final BusinessRepository repository;
  RegisterBusinessUseCase(this.repository);

  Future<Either<Failure, bool>> execute(BusinessEntity entity) async {
    return repository.registerBusiness(entity);
  }
}

final verifyOtpUseCaseProvider = Provider.autoDispose<VerifyOtpUseCase>(
  (ref) => VerifyOtpUseCase(ref.read(businessRemoteRepositoryProvider)),
);

class VerifyOtpUseCase {
  final BusinessRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String email, String otp) async {
    return await repository.verifyOtp(email, otp);
  }
}

final resendOtpUseCaseProvider = Provider.autoDispose<ResendOtpUseCase>(
  (ref) => ResendOtpUseCase(ref.read(businessRemoteRepositoryProvider)),
);

class ResendOtpUseCase {
  final BusinessRepository repository;
  ResendOtpUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String email) async {
    return await repository.resendOtp(email);
  }
}

/// Login Business UseCase
final loginBusinessUseCaseProvider = Provider.autoDispose<LoginBusinessUseCase>(
  (ref) => LoginBusinessUseCase(ref.read(businessRemoteRepositoryProvider)),
);

class LoginBusinessUseCase {
  final BusinessRepository repository;
  LoginBusinessUseCase(this.repository);

  Future<Either<Failure, bool>> execute(
    String username,
    String password,
  ) async {
    return repository.loginBusiness(username, password);
  }
}

/// Upload Documents UseCase
final uploadDocumentsUseCaseProvider =
    Provider.autoDispose<UploadDocumentsUseCase>(
      (ref) =>
          UploadDocumentsUseCase(ref.read(businessRemoteRepositoryProvider)),
    );

class UploadDocumentsUseCase {
  final BusinessRepository repository;
  UploadDocumentsUseCase(this.repository);

  Future<Either<Failure, bool>> execute(List<String> filePaths) async {
    return repository.uploadDocuments(filePaths);
  }
}

final uploadProfileImageUseCaseProvider =
    Provider.autoDispose<UploadProfileImageUseCase>(
      (ref) =>
          UploadProfileImageUseCase(ref.read(businessRemoteRepositoryProvider)),
    );

class UploadProfileImageUseCase {
  final BusinessRepository repository;
  UploadProfileImageUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String imagePath) {
    return repository.uploadProfileImage(imagePath);
  }
}
