import 'package:pet_connect/features/notifications/domain/entity/notification_entity.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationState {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final String? message;
  final bool isLoading;
  final int unreadCount;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.message,
    this.isLoading = false,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    String? message,
    bool? isLoading,
    int? unreadCount,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
