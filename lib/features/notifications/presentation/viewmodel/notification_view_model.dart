import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/core/failure/failure.dart';
import 'package:pet_connect/features/notifications/domain/usecase/notification_usecases.dart';
import 'package:pet_connect/features/notifications/presentation/state/notification_state.dart';

final notificationViewModelProvider =
    StateNotifierProvider.autoDispose<NotificationViewModel, NotificationState>(
      (ref) => NotificationViewModel(
        getBusinessNotificationsUseCase: ref.read(
          getBusinessNotificationsUseCaseProvider,
        ),
        getUserNotificationsUseCase: ref.read(
          getUserNotificationsUseCaseProvider,
        ),
        markNotificationAsReadUseCase: ref.read(
          markNotificationAsReadUseCaseProvider,
        ),
        clearAllNotificationsUseCase: ref.read(
          clearAllNotificationsUseCaseProvider,
        ),
      ),
    );

class NotificationViewModel extends StateNotifier<NotificationState> {
  final GetBusinessNotificationsUseCase _getBusinessNotificationsUseCase;
  final GetUserNotificationsUseCase _getUserNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final ClearAllNotificationsUseCase _clearAllNotificationsUseCase;

  NotificationViewModel({
    required GetBusinessNotificationsUseCase getBusinessNotificationsUseCase,
    required GetUserNotificationsUseCase getUserNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
    required ClearAllNotificationsUseCase clearAllNotificationsUseCase,
  }) : _getBusinessNotificationsUseCase = getBusinessNotificationsUseCase,
       _getUserNotificationsUseCase = getUserNotificationsUseCase,
       _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
       _clearAllNotificationsUseCase = clearAllNotificationsUseCase,
       super(const NotificationState());

  Future<void> getBusinessNotifications() async {
    state = state.copyWith(isLoading: true, status: NotificationStatus.loading);

    final result = await _getBusinessNotificationsUseCase.execute();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: NotificationStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (notifications) {
        final unreadCount = notifications.where((n) => n.isUnread).length;
        state = state.copyWith(
          isLoading: false,
          status: NotificationStatus.loaded,
          notifications: notifications,
          unreadCount: unreadCount,
          message: 'Loaded ${notifications.length} notifications',
        );
      },
    );
  }

  Future<void> getUserNotifications() async {
    state = state.copyWith(isLoading: true, status: NotificationStatus.loading);

    final result = await _getUserNotificationsUseCase.execute();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: NotificationStatus.error,
          message: _getErrorMessage(failure),
        );
      },
      (notifications) {
        final unreadCount = notifications.where((n) => n.isUnread).length;
        state = state.copyWith(
          isLoading: false,
          status: NotificationStatus.loaded,
          notifications: notifications,
          unreadCount: unreadCount,
          message: 'Loaded ${notifications.length} notifications',
        );
      },
    );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final result = await _markNotificationAsReadUseCase.execute(notificationId);

    result.fold(
      (failure) {
        state = state.copyWith(message: 'Failed to mark as read');
      },
      (notification) {
        final updatedNotifications = state.notifications.map((n) {
          return n.id == notificationId ? notification : n;
        }).toList();

        final unreadCount = updatedNotifications
            .where((n) => n.isUnread)
            .length;

        state = state.copyWith(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
          message: 'Notification marked as read',
        );
      },
    );
  }

  Future<void> clearAllNotifications() async {
    state = state.copyWith(isLoading: true);

    final result = await _clearAllNotificationsUseCase.execute();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          message: 'Failed to clear notifications',
        );
      },
      (success) {
        if (success) {
          state = state.copyWith(
            isLoading: false,
            notifications: [],
            unreadCount: 0,
            message: 'All notifications cleared',
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            message: 'Failed to clear notifications',
          );
        }
      },
    );
  }

  String _getErrorMessage(Failure failure) {
    return failure.error;
  }
}
