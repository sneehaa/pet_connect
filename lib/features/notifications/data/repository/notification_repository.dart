import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/features/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:pet_connect/features/notifications/domain/entity/notification_entity.dart';
import 'package:pet_connect/features/notifications/domain/repository/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRemoteRepository(
    ref.read(notificationRemoteDataSourceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class NotificationRemoteRepository implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  NotificationRemoteRepository(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getUserNotifications() {
    return _remoteDataSource.getUserNotifications().then(
      (result) => result.fold(
        (failure) => Left(failure),
        (models) =>
            Right(List<NotificationEntity>.from(models)), // Explicit cast
      ),
    );
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getBusinessNotifications() {
    return _remoteDataSource.getBusinessNotifications().then(
      (result) => result.fold(
        (failure) => Left(failure),
        (models) =>
            Right(List<NotificationEntity>.from(models)), // Explicit cast
      ),
    );
  }

  @override
  Future<Either<Failure, NotificationEntity>> markNotificationAsRead(
    String notificationId,
  ) {
    return _remoteDataSource
        .markNotificationAsRead(notificationId)
        .then(
          (result) => result.fold(
            (failure) => Left(failure),
            (model) => Right(model as NotificationEntity), // Explicit cast
          ),
        );
  }

  @override
  Future<Either<Failure, bool>> clearAllNotifications() {
    return _remoteDataSource.clearAllNotifications().then(
      (result) =>
          result.fold((failure) => Left(failure), (success) => Right(success)),
    );
  }
}
