import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/notifications/data/repository/notification_repository.dart';
import 'package:pet_connect/features/notifications/domain/entity/notification_entity.dart';
import 'package:pet_connect/features/notifications/domain/repository/notification_repository.dart';

// Use case to get business notifications
class GetBusinessNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  GetBusinessNotificationsUseCase(this._notificationRepository);

  Future<Either<Failure, List<NotificationEntity>>> execute() {
    return _notificationRepository.getBusinessNotifications();
  }
}

// Use case to get user notifications
class GetUserNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  GetUserNotificationsUseCase(this._notificationRepository);

  Future<Either<Failure, List<NotificationEntity>>> execute() {
    return _notificationRepository.getUserNotifications();
  }
}

// Use case to mark notification as read
class MarkNotificationAsReadUseCase {
  final NotificationRepository _notificationRepository;

  MarkNotificationAsReadUseCase(this._notificationRepository);

  Future<Either<Failure, NotificationEntity>> execute(String notificationId) {
    return _notificationRepository.markNotificationAsRead(notificationId);
  }
}

// Use case to clear all notifications
class ClearAllNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  ClearAllNotificationsUseCase(this._notificationRepository);

  Future<Either<Failure, bool>> execute() {
    return _notificationRepository.clearAllNotifications();
  }
}

// Provider for use cases
final getBusinessNotificationsUseCaseProvider =
    Provider<GetBusinessNotificationsUseCase>(
      (ref) => GetBusinessNotificationsUseCase(
        ref.read(notificationRepositoryProvider),
      ),
    );

final getUserNotificationsUseCaseProvider =
    Provider<GetUserNotificationsUseCase>(
      (ref) =>
          GetUserNotificationsUseCase(ref.read(notificationRepositoryProvider)),
    );

final markNotificationAsReadUseCaseProvider =
    Provider<MarkNotificationAsReadUseCase>(
      (ref) => MarkNotificationAsReadUseCase(
        ref.read(notificationRepositoryProvider),
      ),
    );

final clearAllNotificationsUseCaseProvider =
    Provider<ClearAllNotificationsUseCase>(
      (ref) => ClearAllNotificationsUseCase(
        ref.read(notificationRepositoryProvider),
      ),
    );
