import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

enum PaymentStatus { initial, loading, loaded, error }

enum WalletStatus { initial, loading, loaded, error }

enum TransactionStatus { initial, loading, loaded, error }

enum PaymentProcessingStatus { initial, processing, success, error }

enum WalletLoadStatus { initial, loading, success, error }

class PaymentState {
  final PaymentStatus paymentStatus;
  final WalletStatus walletStatus;
  final TransactionStatus transactionStatus;
  final PaymentProcessingStatus paymentProcessingStatus;
  final WalletLoadStatus walletLoadStatus;

  final PaymentSummaryModel? paymentSummary;
  final double walletBalance;
  final List<PaymentModel> userPayments;
  final List<TransactionModel> transactions;
  final PaymentModel? currentPayment;

  final String? message;
  final String? paymentMessage;
  final String? walletMessage;
  final String? transactionMessage;

  final bool isLoading;
  final bool isProcessingPayment;
  final bool isLoadingWallet;
  final bool isLoadingTransactions;

  final int currentPage;
  final int totalPages;
  final bool hasMoreTransactions;

  const PaymentState({
    this.paymentStatus = PaymentStatus.initial,
    this.walletStatus = WalletStatus.initial,
    this.transactionStatus = TransactionStatus.initial,
    this.paymentProcessingStatus = PaymentProcessingStatus.initial,
    this.walletLoadStatus = WalletLoadStatus.initial,

    this.paymentSummary,
    this.walletBalance = 0.0,
    this.userPayments = const [],
    this.transactions = const [],
    this.currentPayment,

    this.message,
    this.paymentMessage,
    this.walletMessage,
    this.transactionMessage,

    this.isLoading = false,
    this.isProcessingPayment = false,
    this.isLoadingWallet = false,
    this.isLoadingTransactions = false,

    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMoreTransactions = true,
  });

  PaymentState copyWith({
    PaymentStatus? paymentStatus,
    WalletStatus? walletStatus,
    TransactionStatus? transactionStatus,
    PaymentProcessingStatus? paymentProcessingStatus,
    WalletLoadStatus? walletLoadStatus,

    PaymentSummaryModel? paymentSummary,
    double? walletBalance,
    List<PaymentModel>? userPayments,
    List<TransactionModel>? transactions,
    PaymentModel? currentPayment,

    String? message,
    String? paymentMessage,
    String? walletMessage,
    String? transactionMessage,

    bool? isLoading,
    bool? isProcessingPayment,
    bool? isLoadingWallet,
    bool? isLoadingTransactions,

    int? currentPage,
    int? totalPages,
    bool? hasMoreTransactions,
  }) {
    return PaymentState(
      paymentStatus: paymentStatus ?? this.paymentStatus,
      walletStatus: walletStatus ?? this.walletStatus,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      paymentProcessingStatus:
          paymentProcessingStatus ?? this.paymentProcessingStatus,
      walletLoadStatus: walletLoadStatus ?? this.walletLoadStatus,

      paymentSummary: paymentSummary ?? this.paymentSummary,
      walletBalance: walletBalance ?? this.walletBalance,
      userPayments: userPayments ?? this.userPayments,
      transactions: transactions ?? this.transactions,
      currentPayment: currentPayment ?? this.currentPayment,

      message: message ?? this.message,
      paymentMessage: paymentMessage ?? this.paymentMessage,
      walletMessage: walletMessage ?? this.walletMessage,
      transactionMessage: transactionMessage ?? this.transactionMessage,

      isLoading: isLoading ?? this.isLoading,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      isLoadingWallet: isLoadingWallet ?? this.isLoadingWallet,
      isLoadingTransactions:
          isLoadingTransactions ?? this.isLoadingTransactions,

      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
    );
  }
}
