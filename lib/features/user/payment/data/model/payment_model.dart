import 'package:pet_connect/features/user/payment/domain/entity/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  final String? userName;
  final String? petName;

  const PaymentModel({
    super.id,
    required super.userId,
    required super.businessId,
    required super.adoptionId,
    required super.petId,
    required super.amount,
    required super.status,
    required super.paymentMethod,
    super.transactionId,
    super.metadata = const {},
    super.createdAt,
    super.completedAt,
    this.userName,
    this.petName,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'],
      userId: json['userId'],
      businessId: json['businessId'],
      adoptionId: json['adoptionId'],
      petId: json['petId'],
      amount: json['amount'].toDouble(),
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      metadata: json['metadata'] ?? {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      userName: json['userName'],
      petName: json['petName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'businessId': businessId,
      'adoptionId': adoptionId,
      'petId': petId,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'metadata': metadata,
      'userName': userName,
      'petName': petName,
    };
  }
}

class PaymentSummaryModel extends PaymentSummaryEntity {
  const PaymentSummaryModel({
    required super.requiredAmount,
    required super.currentBalance,
    required super.shortfall,
    required super.canProceed,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      requiredAmount: json['requiredAmount'].toDouble(),
      currentBalance: json['currentBalance'].toDouble(),
      shortfall: json['shortfall'].toDouble(),
      canProceed: json['canProceed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requiredAmount': requiredAmount,
      'currentBalance': currentBalance,
      'shortfall': shortfall,
      'canProceed': canProceed,
    };
  }
}

class WalletModel extends WalletEntity {
  const WalletModel({
    super.id,
    required super.userId,
    required super.balance,
    required super.role,
    super.transactions = const [],
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['_id'],
      userId: json['userId'],
      balance: json['balance'].toDouble(),
      role: json['role'],
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((txn) => TransactionModel.fromJson(txn))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'balance': balance, 'role': role};
  }
}

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.transactionId,
    required super.type,
    required super.amount,
    required super.description,
    super.referenceId,
    super.referenceModel,
    required super.status,
    super.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      referenceId: json['referenceId'],
      referenceModel: json['referenceModel'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
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
    };
  }
}
