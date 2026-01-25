import 'package:pet_connect/features/notifications/domain/entity/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    super.userId,
    super.businessId,
    required super.type,
    required super.subject,
    required super.message,
    required super.status,
    super.sentAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      userId: json['userId'],
      businessId: json['businessId'],
      type: json['type'],
      subject: json['subject'],
      message: json['message'],
      status: json['status'],
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      if (businessId != null) 'businessId': businessId,
      'type': type,
      'subject': subject,
      'message': message,
      'status': status,
      if (sentAt != null) 'sentAt': sentAt!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
