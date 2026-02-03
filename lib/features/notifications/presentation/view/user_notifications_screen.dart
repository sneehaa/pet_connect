import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/notifications/presentation/state/notification_state.dart';
import 'package:pet_connect/features/notifications/presentation/view/widgets/notifications_screen_content.dart';
import 'package:pet_connect/features/notifications/presentation/viewmodel/notification_view_model.dart';

class UserNotificationsScreen extends ConsumerStatefulWidget {
  const UserNotificationsScreen({super.key});

  @override
  ConsumerState<UserNotificationsScreen> createState() =>
      _UserNotificationsScreenState();
}

class _UserNotificationsScreenState
    extends ConsumerState<UserNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask for a cleaner lifecycle entry
    Future.microtask(
      () => ref
          .read(notificationViewModelProvider.notifier)
          .getUserNotifications(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModelProvider);

    // Listen for errors/messages
    ref.listen<NotificationState>(notificationViewModelProvider, (prev, next) {
      if (next.message != null && next.message != prev?.message) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.message!.toLowerCase().contains('failed'),
        );
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(notificationViewModelProvider.notifier)
            .getUserNotifications(),
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(NotificationState state) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No notifications yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return NotificationsScreenContent(
      state: state,
      onRefresh: () => ref
          .read(notificationViewModelProvider.notifier)
          .getUserNotifications(),
      onClearAll: () => ref
          .read(notificationViewModelProvider.notifier)
          .clearAllNotifications(),
      onMarkAsRead: (id) => ref
          .read(notificationViewModelProvider.notifier)
          .markNotificationAsRead(id),
      title: 'My Notifications',
      emptyMessage: 'No notifications yet.',
    );
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all?'),
        content: const Text(
          'This will remove all your notifications permanently.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(notificationViewModelProvider.notifier)
                  .clearAllNotifications();
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
