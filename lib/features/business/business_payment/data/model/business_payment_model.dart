import 'package:pet_connect/features/business/business_payment/domain/entity/business_payment_entity.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

class BusinessEarningsResponse extends BusinessEarningsResponseEntity {
  const BusinessEarningsResponse({
    required super.history,
    required super.stats,
  });

  factory BusinessEarningsResponse.fromJson(Map<String, dynamic> json) {
    return BusinessEarningsResponse(
      history: (json['history'] as List<dynamic>)
          .map((payment) => PaymentModel.fromJson(payment))
          .toList(),
      stats: BusinessPaymentStatsModel.fromJson(json['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'history': (history as List<PaymentModel>)
          .map((payment) => payment.toJson())
          .toList(),
      'stats': (stats as BusinessPaymentStatsModel).toJson(),
    };
  }
}

class BusinessPaymentStatsModel extends BusinessPaymentStatsEntity {
  const BusinessPaymentStatsModel({
    required super.businessId,
    required super.totalAmount,
    required super.totalTransactions,
    required super.averageAmount,
  });

  factory BusinessPaymentStatsModel.fromJson(Map<String, dynamic> json) {
    return BusinessPaymentStatsModel(
      businessId:
          json['businessId']?.toString() ??
          '', // Convert to string and handle null
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      totalTransactions: (json['totalTransactions'] ?? 0).toInt(),
      averageAmount: (json['averageAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'totalAmount': totalAmount,
      'totalTransactions': totalTransactions,
      'averageAmount': averageAmount,
    };
  }
}

class BusinessTransactionModel extends BusinessTransactionEntity {
  const BusinessTransactionModel({
    required super.transactionId,
    required super.type,
    required super.amount,
    required super.description,
    super.referenceId,
    super.referenceModel,
    required super.status,
    super.createdAt,
    super.businessId,
    super.customerName,
    super.userPhone,
    super.petName,
  });

  factory BusinessTransactionModel.fromJson(Map<String, dynamic> json) {
    return BusinessTransactionModel(
      transactionId: json['transactionId'],
      type: json['type'],
      amount: json['amount']?.toDouble() ?? 0.0,
      description: json['description'],
      referenceId: json['referenceId'],
      referenceModel: json['referenceModel'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      businessId: json['businessId'],
      customerName: json['userName'],
      userPhone: json['userPhone'],
      petName: json['petName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'type': type,
      'amount': amount,
      'description': description,
      'referenceId': referenceId,
      'referenceModel': referenceModel,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'businessId': businessId,
      'userName': customerName,
      'userPhone': userPhone,
      'petName': petName,
    };
  }
}
