// lib/features/business/payment/presentation/viewmodel/business_payment_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/features/business/business_payment/domain/usecase/business_payment_usecase.dart';
import 'package:pet_connect/features/business/business_payment/presentation/state/business_payment_state.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

// Business payment use cases provider
final businessPaymentUseCasesProvider =
    Provider.autoDispose<BusinessPaymentUseCases>((ref) {
      return BusinessPaymentUseCases(
        getBusinessEarnings: ref.read(getBusinessEarningsUseCaseProvider),
        getBusinessWalletBalance: ref.read(
          getBusinessWalletBalanceUseCaseProvider,
        ),
        getBusinessTransactions: ref.read(
          getBusinessTransactionsUseCaseProvider,
        ),
      );
    });

class BusinessPaymentUseCases {
  final GetBusinessEarningsUseCase getBusinessEarnings;
  final GetBusinessWalletBalanceUseCase getBusinessWalletBalance;
  final GetBusinessTransactionsUseCase getBusinessTransactions;

  BusinessPaymentUseCases({
    required this.getBusinessEarnings,
    required this.getBusinessWalletBalance,
    required this.getBusinessTransactions,
  });
}

// Business payment view model provider
final businessPaymentViewModelProvider =
    StateNotifierProvider<BusinessPaymentViewModel, BusinessPaymentState>((
      ref,
    ) {
      return BusinessPaymentViewModel(
        ref.read(businessPaymentUseCasesProvider),
      );
    });

class BusinessPaymentViewModel extends StateNotifier<BusinessPaymentState> {
  final BusinessPaymentUseCases _useCases;

  BusinessPaymentViewModel(this._useCases)
    : super(const BusinessPaymentState());

  // Get business earnings (payments history and stats)
  Future<void> loadBusinessEarnings({int page = 1, int limit = 10}) async {
    try {
      state = state.copyWith(
        earningsStatus: BusinessEarningsStatus.loading,
        earningsMessage: null,
        isLoadingEarnings: true,
      );

      final result = await _useCases.getBusinessEarnings.execute(
        page: page,
        limit: limit,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            earningsStatus: BusinessEarningsStatus.error,
            earningsMessage: 'Failed to load earnings: ${failure.error}',
            isLoadingEarnings: false,
          );
        },
        (earnings) {
          state = state.copyWith(
            earningsStatus: BusinessEarningsStatus.loaded,
            earnings: earnings,
            earningsMessage: null,
            isLoadingEarnings: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        earningsStatus: BusinessEarningsStatus.error,
        earningsMessage: 'Error: $e',
        isLoadingEarnings: false,
      );
    }
  }

  // Get business wallet balance
  Future<void> loadBusinessWalletBalance() async {
    try {
      state = state.copyWith(
        walletStatus: BusinessWalletStatus.loading,
        walletMessage: null,
        isLoadingWallet: true,
      );

      final result = await _useCases.getBusinessWalletBalance.execute();

      result.fold(
        (failure) {
          state = state.copyWith(
            walletStatus: BusinessWalletStatus.error,
            walletMessage: 'Failed to load wallet balance: ${failure.error}',
            isLoadingWallet: false,
          );
        },
        (balance) {
          state = state.copyWith(
            walletStatus: BusinessWalletStatus.loaded,
            businessWalletBalance: balance,
            walletMessage: null,
            isLoadingWallet: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        walletStatus: BusinessWalletStatus.error,
        walletMessage: 'Error: $e',
        isLoadingWallet: false,
      );
    }
  }

  // Get business transactions (from wallet)
  Future<void> loadBusinessTransactions({int page = 1, int limit = 10}) async {
    try {
      state = state.copyWith(
        transactionsStatus: BusinessTransactionsStatus.loading,
        transactionsMessage: null,
        isLoadingTransactions: true,
      );

      final result = await _useCases.getBusinessTransactions.execute(
        page: page,
        limit: limit,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            transactionsStatus: BusinessTransactionsStatus.error,
            transactionsMessage:
                'Failed to load transactions: ${failure.error}',
            isLoadingTransactions: false,
          );
        },
        (transactions) {
          final recentTransactions =
              (transactions['recentTransactions'] as List<TransactionModel>);

          state = state.copyWith(
            transactionsStatus: BusinessTransactionsStatus.loaded,
            businessTransactions: transactions,
            recentTransactions: recentTransactions,
            transactionsMessage: null,
            isLoadingTransactions: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        transactionsStatus: BusinessTransactionsStatus.error,
        transactionsMessage: 'Error: $e',
        isLoadingTransactions: false,
      );
    }
  }

  // Clear messages
  void clearMessages() {
    state = state.copyWith(
      earningsMessage: null,
      walletMessage: null,
      transactionsMessage: null,
    );
  }

  // Reset state
  void reset() {
    state = const BusinessPaymentState();
  }
}
