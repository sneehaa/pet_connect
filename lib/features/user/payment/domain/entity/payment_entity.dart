import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String userId;
  final String businessId;
  final String adoptionId;
  final String petId;
  final double amount;
  final String status;
  final String paymentMethod;
  final String? transactionId;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? completedAt;

  const PaymentEntity({
    this.id,
    required this.userId,
    required this.businessId,
    required this.adoptionId,
    required this.petId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.transactionId,
    this.metadata = const {},
    this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    businessId,
    adoptionId,
    petId,
    amount,
    status,
    paymentMethod,
    transactionId,
    metadata,
    createdAt,
    completedAt,
  ];

  PaymentEntity copyWith({
    String? id,
    String? userId,
    String? businessId,
    String? adoptionId,
    String? petId,
    double? amount,
    String? status,
    String? paymentMethod,
    String? transactionId,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return PaymentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      adoptionId: adoptionId ?? this.adoptionId,
      petId: petId ?? this.petId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Helper getters
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isProcessing => status == 'processing';
  bool get isRefunded => status == 'refunded';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }
}

class PaymentSummaryEntity extends Equatable {
  final double requiredAmount;
  final double currentBalance;
  final double shortfall;
  final bool canProceed;

  const PaymentSummaryEntity({
    required this.requiredAmount,
    required this.currentBalance,
    required this.shortfall,
    required this.canProceed,
  });

  @override
  List<Object?> get props => [
    requiredAmount,
    currentBalance,
    shortfall,
    canProceed,
  ];
}

class TransactionEntity extends Equatable {
  final String transactionId;
  final String type;
  final double amount;
  final String description;
  final String? referenceId;
  final String? referenceModel;
  final String status;
  final DateTime? createdAt;

  const TransactionEntity({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.description,
    this.referenceId,
    this.referenceModel,
    required this.status,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    transactionId,
    type,
    amount,
    description,
    referenceId,
    referenceModel,
    status,
    createdAt,
  ];

  String get typeText {
    switch (type) {
      case 'credit':
        return 'Credit';
      case 'debit':
        return 'Debit';
      case 'hold':
        return 'Hold';
      case 'release':
        return 'Release';
      case 'transfer':
        return 'Transfer';
      default:
        return type;
    }
  }

  bool get isCredit => type == 'credit';
  bool get isDebit => type == 'debit';
}

class WalletEntity extends Equatable {
  final String? id;
  final String userId;
  final double balance;
  final String role;
  final List<TransactionEntity> transactions;

  const WalletEntity({
    this.id,
    required this.userId,
    required this.balance,
    required this.role,
    this.transactions = const [],
  });

  @override
  List<Object?> get props => [id, userId, balance, role, transactions];
}
