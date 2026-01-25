import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/notifications/domain/entity/notification_entity.dart';
import 'package:pet_connect/features/notifications/presentation/state/notification_state.dart';

class NotificationsScreenContent extends StatelessWidget {
  final NotificationState state;
  final Future<void> Function() onRefresh;
  final void Function() onClearAll;
  final void Function(String) onMarkAsRead;
  final String title;
  final String emptyMessage;

  const NotificationsScreenContent({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onClearAll,
    required this.onMarkAsRead,
    required this.title,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        title: Text(
          title,
          style: AppStyles.headline3.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDarkGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (state.notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
              onPressed: () {
                _showClearAllDialog(context, onClearAll);
              },
              tooltip: 'Clear all',
            ),
        ],
      ),
      body: state.status == NotificationStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.status == NotificationStatus.error
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.errorRed,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Failed to load notifications',
                    style: AppStyles.headline3,
                  ),
                  Text(
                    state.message ?? 'Please try again',
                    style: AppStyles.subtitle,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onRefresh,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Retry', style: AppStyles.button),
                  ),
                ],
              ),
            )
          : state.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    color: AppColors.primaryOrange,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text('No Notifications', style: AppStyles.headline3),
                  Text(emptyMessage, style: AppStyles.subtitle),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: onRefresh,
              backgroundColor: AppColors.background,
              color: AppColors.primaryOrange,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _buildNotificationCard(
                    notification,
                    context,
                    onMarkAsRead,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildNotificationCard(
    NotificationEntity notification,
    BuildContext context,
    void Function(String) onMarkAsRead,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: notification.isUnread
            ? AppColors.primaryOrange.withOpacity(0.05)
            : AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: notification.isUnread
              ? AppColors.primaryOrange.withOpacity(0.2)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (notification.isUnread) {
            onMarkAsRead(notification.id);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.subject),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _getNotificationIcon(notification.subject),
                ),
              ),
              const SizedBox(width: 16),
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.subject,
                            style: AppStyles.body.copyWith(
                              fontWeight: notification.isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              fontSize: 16,
                              color: notification.isUnread
                                  ? AppColors.textDarkGrey
                                  : AppColors.textDarkGrey.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (notification.isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: AppStyles.small.copyWith(
                        color: AppColors.textDarkGrey.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textLightGrey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat(
                            'MMM dd, yyyy - hh:mm a',
                          ).format(notification.createdAt),
                          style: AppStyles.small.copyWith(
                            color: AppColors.textLightGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(String subject) {
    if (subject.contains('New Adoption') || subject.contains('🐾')) {
      return Colors.blue.withOpacity(0.15);
    } else if (subject.contains('Approved') || subject.contains('🎉')) {
      return Colors.green.withOpacity(0.15);
    } else if (subject.contains('Payment')) {
      return Colors.purple.withOpacity(0.15);
    } else if (subject.contains('Rejected') || subject.contains('Update')) {
      return AppColors.errorRed.withOpacity(0.15);
    } else {
      return AppColors.primaryOrange.withOpacity(0.15);
    }
  }

  Widget _getNotificationIcon(String subject) {
    IconData icon;
    Color color;

    if (subject.contains('New Adoption') || subject.contains('🐾')) {
      icon = Icons.pets;
      color = Colors.blue;
    } else if (subject.contains('Approved') || subject.contains('🎉')) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (subject.contains('Payment')) {
      icon = Icons.payment;
      color = Colors.purple;
    } else if (subject.contains('Rejected') || subject.contains('Update')) {
      icon = Icons.info;
      color = AppColors.errorRed;
    } else {
      icon = Icons.notifications;
      color = AppColors.primaryOrange;
    }

    return Icon(icon, color: color, size: 24);
  }

  void _showClearAllDialog(BuildContext context, void Function() onClearAll) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: AppColors.errorRed, size: 28),
              const SizedBox(width: 12),
              Text('Clear All Notifications', style: AppStyles.headline3),
            ],
          ),
          content: Text(
            'Are you sure you want to clear all notifications? This action cannot be undone.',
            style: AppStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppStyles.button.copyWith(color: AppColors.textDarkGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onClearAll();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Clear All', style: AppStyles.button),
            ),
          ],
        );
      },
    );
  }
}
