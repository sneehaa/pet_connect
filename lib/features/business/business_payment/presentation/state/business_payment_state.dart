// lib/features/business/payment/presentation/state/business_payment_state.dart
import 'package:pet_connect/features/business/business_payment/domain/entity/business_payment_entity.dart';
import 'package:pet_connect/features/user/payment/domain/entity/payment_entity.dart';

enum BusinessEarningsStatus { initial, loading, loaded, error }

enum BusinessWalletStatus { initial, loading, loaded, error }

enum BusinessTransactionsStatus { initial, loading, loaded, error }

class BusinessPaymentState {
  final BusinessEarningsStatus earningsStatus;
  final BusinessWalletStatus walletStatus;
  final BusinessTransactionsStatus transactionsStatus;

  final BusinessEarningsResponseEntity? earnings;
  final double businessWalletBalance;
  final Map<String, dynamic>? businessTransactions;
  final List<BusinessTransactionEntity> recentTransactions;

  final String? earningsMessage;
  final String? walletMessage;
  final String? transactionsMessage;

  final bool isLoadingEarnings;
  final bool isLoadingWallet;
  final bool isLoadingTransactions;

  const BusinessPaymentState({
    this.earningsStatus = BusinessEarningsStatus.initial,
    this.walletStatus = BusinessWalletStatus.initial,
    this.transactionsStatus = BusinessTransactionsStatus.initial,

    this.earnings,
    this.businessWalletBalance = 0.0,
    this.businessTransactions,
    this.recentTransactions = const [],

    this.earningsMessage,
    this.walletMessage,
    this.transactionsMessage,

    this.isLoadingEarnings = false,
    this.isLoadingWallet = false,
    this.isLoadingTransactions = false,
  });

  double get totalEarnings => businessTransactions?['totalEarnings'] ?? 0.0;
  int get totalTransactions => businessTransactions?['totalTransactions'] ?? 0;

  // Helper method to get stats safely
  BusinessPaymentStatsEntity? get earningsStats => earnings?.stats;

  BusinessPaymentState copyWith({
    BusinessEarningsStatus? earningsStatus,
    BusinessWalletStatus? walletStatus,
    BusinessTransactionsStatus? transactionsStatus,

    BusinessEarningsResponseEntity? earnings,
    double? businessWalletBalance,
    Map<String, dynamic>? businessTransactions,
    List<TransactionEntity>? recentTransactions,

    String? earningsMessage,
    String? walletMessage,
    String? transactionsMessage,

    bool? isLoadingEarnings,
    bool? isLoadingWallet,
    bool? isLoadingTransactions,
  }) {
    return BusinessPaymentState(
      earningsStatus: earningsStatus ?? this.earningsStatus,
      walletStatus: walletStatus ?? this.walletStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,

      earnings: earnings ?? this.earnings,
      businessWalletBalance:
          businessWalletBalance ?? this.businessWalletBalance,
      businessTransactions: businessTransactions ?? this.businessTransactions,

      earningsMessage: earningsMessage ?? this.earningsMessage,
      walletMessage: walletMessage ?? this.walletMessage,
      transactionsMessage: transactionsMessage ?? this.transactionsMessage,

      isLoadingEarnings: isLoadingEarnings ?? this.isLoadingEarnings,
      isLoadingWallet: isLoadingWallet ?? this.isLoadingWallet,
      isLoadingTransactions:
          isLoadingTransactions ?? this.isLoadingTransactions,
    );
  }
}
