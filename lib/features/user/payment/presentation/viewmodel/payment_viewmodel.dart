import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';
import 'package:pet_connect/features/user/payment/domain/usecase/payment_usecase.dart';
import 'package:pet_connect/features/user/payment/presentation/state/payment_state.dart';

final paymentUseCasesProvider = Provider.autoDispose<PaymentUseCases>((ref) {
  return PaymentUseCases(
    getPaymentSummary: ref.read(getPaymentSummaryUseCaseProvider),
    initiatePayment: ref.read(initiatePaymentUseCaseProvider),
    processPayment: ref.read(processPaymentUseCaseProvider),
    loadWallet: ref.read(loadWalletUseCaseProvider),
    getWalletBalance: ref.read(getWalletBalanceUseCaseProvider),
    getTransactionHistory: ref.read(getTransactionHistoryUseCaseProvider),
    getUserPayments: ref.read(getUserPaymentsUseCaseProvider),
    getPaymentDetails: ref.read(getPaymentDetailsUseCaseProvider),
  );
});

class PaymentUseCases {
  final GetPaymentSummaryUseCase getPaymentSummary;
  final InitiatePaymentUseCase initiatePayment;
  final ProcessPaymentUseCase processPayment;
  final LoadWalletUseCase loadWallet;
  final GetWalletBalanceUseCase getWalletBalance;
  final GetTransactionHistoryUseCase getTransactionHistory;
  final GetUserPaymentsUseCase getUserPayments;
  final GetPaymentDetailsUseCase getPaymentDetails;

  PaymentUseCases({
    required this.getPaymentSummary,
    required this.initiatePayment,
    required this.processPayment,
    required this.loadWallet,
    required this.getWalletBalance,
    required this.getTransactionHistory,
    required this.getUserPayments,
    required this.getPaymentDetails,
  });
}

final paymentViewModelProvider =
    StateNotifierProvider<PaymentViewModel, PaymentState>((ref) {
      return PaymentViewModel(ref.read(paymentUseCasesProvider));
    });

class PaymentViewModel extends StateNotifier<PaymentState> {
  final PaymentUseCases _useCases;

  PaymentViewModel(this._useCases) : super(const PaymentState());

  // Get payment summary
  Future<void> loadPaymentSummary(String paymentId) async {
    try {
      state = state.copyWith(
        paymentStatus: PaymentStatus.loading,
        message: null,
        isLoading: true,
      );

      final result = await _useCases.getPaymentSummary.execute(paymentId);

      result.fold(
        (failure) {
          state = state.copyWith(
            paymentStatus: PaymentStatus.error,
            message: 'Failed to load payment summary: ${failure.error}',
            isLoading: false,
          );
        },
        (summary) {
          state = state.copyWith(
            paymentStatus: PaymentStatus.loaded,
            paymentSummary: summary,
            message: null,
            isLoading: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        paymentStatus: PaymentStatus.error,
        message: 'Error: $e',
        isLoading: false,
      );
    }
  }

  // Add this method to your PaymentViewModel class
  Future<PaymentSummaryModel?> checkWalletStatus({
    required double requiredAmount,
  }) async {
    try {
      // First try to get wallet balance
      final balanceResult = await _useCases.getWalletBalance.execute();

      return balanceResult.fold(
        (failure) {
          // If wallet not found or other error
          state = state.copyWith(
            walletStatus: WalletStatus.error,
            walletMessage: failure.error,
          );
          return null;
        },
        (balance) {
          // Calculate if sufficient funds
          final canProceed = balance >= requiredAmount;
          final shortfall = requiredAmount - balance;

          return PaymentSummaryModel(
            requiredAmount: requiredAmount,
            currentBalance: balance,
            shortfall: shortfall > 0 ? shortfall : 0,
            canProceed: canProceed,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        walletStatus: WalletStatus.error,
        walletMessage: 'Error checking wallet: $e',
      );
      return null;
    }
  }

  Future<void> initiatePayment({
    required String adoptionId,
    required String businessId,
    required String petId,
    required double amount,
    bool checkWalletFirst = true,
  }) async {
    try {
      if (checkWalletFirst) {
        // Check wallet status first
        state = state.copyWith(
          paymentProcessingStatus: PaymentProcessingStatus.processing,
          paymentMessage: 'Checking wallet...',
          isProcessingPayment: true,
        );

        final walletCheck = await checkWalletStatus(requiredAmount: amount);

        if (walletCheck == null || !walletCheck.canProceed) {
          // Wallet not found or insufficient funds
          state = state.copyWith(
            paymentProcessingStatus: PaymentProcessingStatus.error,
            paymentMessage: walletCheck == null
                ? 'Wallet not found. Please set up a wallet first.'
                : 'Insufficient funds. You need Rs. ${walletCheck.shortfall} more.',
            isProcessingPayment: false,
          );
          return;
        }
      }

      // If wallet check passes, proceed with payment initiation
      state = state.copyWith(
        paymentProcessingStatus: PaymentProcessingStatus.processing,
        paymentMessage: 'Initiating payment...',
        isProcessingPayment: true,
      );

      final result = await _useCases.initiatePayment.execute(
        adoptionId: adoptionId,
        businessId: businessId,
        petId: petId,
        amount: amount,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            paymentProcessingStatus: PaymentProcessingStatus.error,
            paymentMessage: 'Failed to initiate payment: ${failure.error}',
            isProcessingPayment: false,
          );
        },
        (payment) {
          state = state.copyWith(
            paymentProcessingStatus: PaymentProcessingStatus.success,
            currentPayment: payment,
            paymentMessage: 'Payment initiated successfully!',
            isProcessingPayment: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        paymentProcessingStatus: PaymentProcessingStatus.error,
        paymentMessage: 'Error: $e',
        isProcessingPayment: false,
      );
    }
  }

  // Process payment
  Future<void> processPayment({
    required String paymentId,
    String paymentMethod = 'wallet',
  }) async {
    try {
      state = state.copyWith(
        paymentProcessingStatus: PaymentProcessingStatus.processing,
        paymentMessage: null,
        isProcessingPayment: true,
      );

      final result = await _useCases.processPayment.execute(
        paymentId: paymentId,
        paymentMethod: paymentMethod,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            paymentProcessingStatus: PaymentProcessingStatus.error,
            paymentMessage: 'Payment failed: ${failure.error}',
            isProcessingPayment: false,
          );
        },
        (payment) {
          state = state.copyWith(
            paymentProcessingStatus: PaymentProcessingStatus.success,
            currentPayment: payment,
            paymentMessage: 'Payment processed successfully!',
            walletBalance: state.walletBalance - payment.amount,
            isProcessingPayment: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        paymentProcessingStatus: PaymentProcessingStatus.error,
        paymentMessage: 'Error: $e',
        isProcessingPayment: false,
      );
    }
  }

  // Load wallet
  Future<void> loadWallet({required double amount}) async {
    try {
      state = state.copyWith(
        walletLoadStatus: WalletLoadStatus.loading,
        walletMessage: null,
        isLoadingWallet: true,
      );

      final result = await _useCases.loadWallet.execute(amount: amount);

      result.fold(
        (failure) {
          state = state.copyWith(
            walletLoadStatus: WalletLoadStatus.error,
            walletMessage: 'Failed to load wallet: ${failure.error}',
            isLoadingWallet: false,
          );
        },
        (wallet) {
          state = state.copyWith(
            walletLoadStatus: WalletLoadStatus.success,
            walletBalance: wallet.balance,
            walletMessage: 'Wallet loaded successfully!',
            isLoadingWallet: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        walletLoadStatus: WalletLoadStatus.error,
        walletMessage: 'Error: $e',
        isLoadingWallet: false,
      );
    }
  }

  // Get wallet balance
  Future<void> loadWalletBalance() async {
    try {
      state = state.copyWith(
        walletStatus: WalletStatus.loading,
        walletMessage: null,
        isLoadingWallet: true,
      );

      final result = await _useCases.getWalletBalance.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            walletStatus: WalletStatus.error,
            walletMessage: 'Failed to load balance: ${failure.error}',
            isLoadingWallet: false,
          );
        },
        (balance) {
          state = state.copyWith(
            walletStatus: WalletStatus.loaded,
            walletBalance: balance,
            walletMessage: null,
            isLoadingWallet: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        walletStatus: WalletStatus.error,
        walletMessage: 'Error: $e',
        isLoadingWallet: false,
      );
    }
  }

  // Get transaction history
  Future<void> loadTransactionHistory({bool loadMore = false}) async {
    try {
      if (loadMore && !state.hasMoreTransactions) return;

      final page = loadMore ? state.currentPage + 1 : 1;

      state = state.copyWith(
        transactionStatus: TransactionStatus.loading,
        transactionMessage: null,
        isLoadingTransactions: true,
        currentPage: page,
      );

      final result = await _useCases.getTransactionHistory.execute(
        page: page,
        limit: 10,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            transactionStatus: TransactionStatus.error,
            transactionMessage: 'Failed to load transactions: ${failure.error}',
            isLoadingTransactions: false,
          );
        },
        (data) {
          final newTransactions =
              data['transactions'] as List<TransactionModel>;
          final totalPages = data['totalPages'] as int;
          final allTransactions = loadMore
              ? [...state.transactions, ...newTransactions]
              : newTransactions;

          state = state.copyWith(
            transactionStatus: TransactionStatus.loaded,
            transactions: allTransactions,
            totalPages: totalPages,
            hasMoreTransactions: page < totalPages,
            isLoadingTransactions: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionMessage: 'Error: $e',
        isLoadingTransactions: false,
      );
    }
  }

  // Get user payments
  Future<void> loadUserPayments() async {
    try {
      state = state.copyWith(
        paymentStatus: PaymentStatus.loading,
        message: null,
        isLoading: true,
      );

      final result = await _useCases.getUserPayments.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            paymentStatus: PaymentStatus.error,
            message: 'Failed to load payments: ${failure.error}',
            isLoading: false,
          );
        },
        (payments) {
          state = state.copyWith(
            paymentStatus: PaymentStatus.loaded,
            userPayments: payments,
            message: null,
            isLoading: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        paymentStatus: PaymentStatus.error,
        message: 'Error: $e',
        isLoading: false,
      );
    }
  }

  // Get payment details
  Future<void> loadPaymentDetails(String paymentId) async {
    try {
      state = state.copyWith(
        paymentStatus: PaymentStatus.loading,
        message: null,
        isLoading: true,
      );

      final result = await _useCases.getPaymentDetails.execute(paymentId);

      result.fold(
        (failure) {
          state = state.copyWith(
            paymentStatus: PaymentStatus.error,
            message: 'Failed to load payment details: ${failure.error}',
            isLoading: false,
          );
        },
        (payment) {
          state = state.copyWith(
            paymentStatus: PaymentStatus.loaded,
            currentPayment: payment,
            message: null,
            isLoading: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        paymentStatus: PaymentStatus.error,
        message: 'Error: $e',
        isLoading: false,
      );
    }
  }

  // Clear messages
  void clearMessages() {
    state = state.copyWith(
      message: null,
      paymentMessage: null,
      walletMessage: null,
      transactionMessage: null,
    );
  }

  // Clear payment status
  void clearPaymentProcessingStatus() {
    state = state.copyWith(
      paymentProcessingStatus: PaymentProcessingStatus.initial,
      paymentMessage: null,
    );
  }

  // Clear wallet load status
  void clearWalletLoadStatus() {
    state = state.copyWith(
      walletLoadStatus: WalletLoadStatus.initial,
      walletMessage: null,
    );
  }

  // Reset state
  void reset() {
    state = const PaymentState();
  }
}
