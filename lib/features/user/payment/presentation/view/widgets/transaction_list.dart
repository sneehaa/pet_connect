import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Add intl to your pubspec.yaml
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';
import 'package:pet_connect/features/user/payment/presentation/state/payment_state.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key});

  @override
  ConsumerState<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentViewModelProvider.notifier).loadTransactionHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(paymentViewModelProvider.notifier)
          .loadTransactionHistory(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentViewModelProvider);

    if (state.transactionStatus == TransactionStatus.loading &&
        state.transactions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (state.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.iconGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('No transactions yet', style: AppStyles.subtitle),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      onRefresh: () async {
        ref.read(paymentViewModelProvider.notifier).loadTransactionHistory();
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: state.transactions.length + 1,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: AppColors.backgroundGrey),
        itemBuilder: (context, index) {
          if (index == state.transactions.length) {
            return _buildLoader(state);
          }

          final transaction = state.transactions[index];
          return _buildTransactionItem(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel transaction) {
    final dateStr = transaction.createdAt != null
        ? DateFormat(
            'MMM dd, yyyy • hh:mm a',
          ).format(transaction.createdAt!.toLocal())
        : 'Unknown Date';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Elegant Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.isCredit
                  ? AppColors.successGreen.withOpacity(0.1)
                  : AppColors.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              transaction.isCredit ? Icons.add_rounded : Icons.remove_rounded,
              color: transaction.isCredit
                  ? AppColors.successGreen
                  : AppColors.errorRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: AppStyles.small.copyWith(
                    color: AppColors.textLightGrey,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isCredit ? '+' : '-'} NPR ${transaction.amount.toStringAsFixed(2)}',
                style: AppStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: transaction.isCredit
                      ? AppColors.successGreen
                      : AppColors.textBlack,
                ),
              ),
              if (transaction.transactionId.isNotEmpty)
                Text(
                  '#${transaction.transactionId.substring(0, 8)}',
                  style: AppStyles.small.copyWith(
                    fontSize: 10,
                    color: AppColors.iconGrey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoader(PaymentState state) {
    if (state.isLoadingTransactions) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );
    }
    if (!state.hasMoreTransactions && state.transactions.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            'End of history',
            style: AppStyles.small.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
