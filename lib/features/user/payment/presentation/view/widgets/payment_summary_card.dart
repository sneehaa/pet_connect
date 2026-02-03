import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/payment/presentation/view/screens/wallet_screen.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';

class PaymentSummaryCard extends ConsumerStatefulWidget {
  final String paymentId;

  const PaymentSummaryCard({super.key, required this.paymentId});

  @override
  ConsumerState<PaymentSummaryCard> createState() => _PaymentSummaryCardState();
}

class _PaymentSummaryCardState extends ConsumerState<PaymentSummaryCard> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref
          .read(paymentViewModelProvider.notifier)
          .loadPaymentSummary(widget.paymentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentViewModelProvider);
    final summary = state.paymentSummary;

    if (summary == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 12),
                Text(
                  'Payment Summary',
                  style: AppStyles.headline3.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Balance Ledger Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Amount Due',
                  'NPR ${summary.requiredAmount.toStringAsFixed(2)}',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.backgroundGrey, thickness: 1),
                ),
                _buildSummaryRow(
                  'Wallet Balance',
                  'NPR ${summary.currentBalance.toStringAsFixed(2)}',
                ),

                if (summary.shortfall > 0) ...[
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Shortfall',
                    'NPR ${summary.shortfall.toStringAsFixed(2)}',
                    color: AppColors.errorRed,
                    isBold: true,
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: summary.canProceed
                ? _buildProceedButton(context, ref, widget.paymentId)
                : _buildAddMoneyButton(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.body.copyWith(color: AppColors.textGrey)),
        Text(
          value,
          style: AppStyles.body.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? AppColors.textBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton(
    BuildContext context,
    WidgetRef ref,
    String paymentId,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ref
              .read(paymentViewModelProvider.notifier)
              .processPayment(paymentId: paymentId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text('Confirm & Pay', style: AppStyles.button),
      ),
    );
  }

  Widget _buildAddMoneyButton(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.warningYellow,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Insufficient Wallet Balance',
              style: AppStyles.small.copyWith(
                color: AppColors.warningYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text('Add Money to Wallet', style: AppStyles.button),
          ),
        ),
      ],
    );
  }
}
