import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String? businessId;
  final String type;
  final String subject;
  final String message;
  final String status;
  final DateTime? sentAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    this.businessId,
    required this.type,
    required this.subject,
    required this.message,
    required this.status,
    this.sentAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    businessId,
    type,
    subject,
    message,
    status,
    sentAt,
    createdAt,
    updatedAt,
  ];

  bool get isUnread => status == 'pending';

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? businessId,
    String? type,
    String? subject,
    String? message,
    String? status,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
