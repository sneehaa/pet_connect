import 'package:equatable/equatable.dart';
import 'package:pet_connect/features/user/payment/domain/entity/payment_entity.dart';

class BusinessPaymentStatsEntity extends Equatable {
  final String businessId;
  final double totalAmount;
  final int totalTransactions;
  final double averageAmount;

  const BusinessPaymentStatsEntity({
    required this.businessId,
    required this.totalAmount,
    required this.totalTransactions,
    required this.averageAmount,
  });

  @override
  List<Object?> get props => [
    businessId,
    totalAmount,
    totalTransactions,
    averageAmount,
  ];

  BusinessPaymentStatsEntity copyWith({
    String? businessId,
    double? totalAmount,
    int? totalTransactions,
    double? averageAmount,
  }) {
    return BusinessPaymentStatsEntity(
      businessId: businessId ?? this.businessId,
      totalAmount: totalAmount ?? this.totalAmount,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      averageAmount: averageAmount ?? this.averageAmount,
    );
  }
}

class BusinessEarningsResponseEntity extends Equatable {
  final List<PaymentEntity> history;
  final BusinessPaymentStatsEntity stats;

  const BusinessEarningsResponseEntity({
    required this.history,
    required this.stats,
  });

  @override
  List<Object?> get props => [history, stats];

  BusinessEarningsResponseEntity copyWith({
    List<PaymentEntity>? history,
    BusinessPaymentStatsEntity? stats,
  }) {
    return BusinessEarningsResponseEntity(
      history: history ?? this.history,
      stats: stats ?? this.stats,
    );
  }
}

class BusinessTransactionEntity extends TransactionEntity {
  final String? businessId;
  final String? customerName;
  final String? userPhone;
  final String? petName;

  const BusinessTransactionEntity({
    required super.transactionId,
    required super.type,
    required super.amount,
    required super.description,
    super.referenceId,
    super.referenceModel,
    required super.status,
    super.createdAt,
    this.businessId,
    this.customerName,
    this.userPhone,
    this.petName,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    businessId,
    customerName,
    userPhone,
    petName,
  ];

  @override
  BusinessTransactionEntity copyWith({
    String? transactionId,
    String? type,
    double? amount,
    String? description,
    String? referenceId,
    String? referenceModel,
    String? status,
    DateTime? createdAt,
    String? businessId,
    String? customerName,
    String? userPhone,
    String? petName,
  }) {
    return BusinessTransactionEntity(
      transactionId: transactionId ?? this.transactionId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      referenceId: referenceId ?? this.referenceId,
      referenceModel: referenceModel ?? this.referenceModel,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      businessId: businessId ?? this.businessId,
      customerName: customerName ?? this.customerName,
      userPhone: userPhone ?? this.userPhone,
      petName: petName ?? this.petName,
    );
  }
}
