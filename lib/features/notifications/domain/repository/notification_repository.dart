import 'package:dartz/dartz.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/notifications/domain/entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getUserNotifications();
  Future<Either<Failure, List<NotificationEntity>>> getBusinessNotifications();
  Future<Either<Failure, NotificationEntity>> markNotificationAsRead(
    String notificationId,
  );
  Future<Either<Failure, bool>> clearAllNotifications();
}
