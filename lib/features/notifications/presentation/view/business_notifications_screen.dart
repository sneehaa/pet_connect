import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/notifications/presentation/state/notification_state.dart';
import 'package:pet_connect/features/notifications/presentation/view/widgets/notifications_screen_content.dart';
import 'package:pet_connect/features/notifications/presentation/viewmodel/notification_view_model.dart';


class BusinessNotificationsScreen extends ConsumerStatefulWidget {
  const BusinessNotificationsScreen({super.key});

  @override
  ConsumerState<BusinessNotificationsScreen> createState() =>
      _BusinessNotificationsScreenState();
}

class _BusinessNotificationsScreenState
    extends ConsumerState<BusinessNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationViewModelProvider.notifier)
          .getBusinessNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NotificationState>(notificationViewModelProvider, (
      previous,
      next,
    ) {
      if (next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.message!.contains('Failed'),
        );
      }
    });

    final state = ref.watch(notificationViewModelProvider);

    return NotificationsScreenContent(
      state: state,
      onRefresh: () => ref
          .read(notificationViewModelProvider.notifier)
          .getBusinessNotifications(),
      onClearAll: () => ref
          .read(notificationViewModelProvider.notifier)
          .clearAllNotifications(),
      onMarkAsRead: (id) => ref
          .read(notificationViewModelProvider.notifier)
          .markNotificationAsRead(id),
      title: 'Business Notifications',
      emptyMessage: 'No notifications for your business yet.',
    );
  }
}
