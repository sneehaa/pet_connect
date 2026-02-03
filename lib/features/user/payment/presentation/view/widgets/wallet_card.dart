import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';

class WalletCard extends ConsumerWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentViewModelProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange,
            Color(0xFFFFBBAA), // A slightly lighter coral
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background circles for a modern look
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primaryWhite.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: AppStyles.subtitle.copyWith(
                          color: AppColors.primaryWhite.withOpacity(0.9),
                        ),
                      ),
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppColors.primaryWhite,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NPR ${state.walletBalance.toStringAsFixed(2)}',
                    style: AppStyles.headline1.copyWith(
                      color: AppColors.primaryWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showLoadWalletDialog(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryWhite,
                            foregroundColor: AppColors.primaryOrange,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Add Money',
                            style: AppStyles.button.copyWith(
                              color: AppColors.primaryOrange,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Secondary Action (History or Refresh)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => ref
                              .read(paymentViewModelProvider.notifier)
                              .loadWalletBalance(),
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadWalletDialog(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Top Up Wallet', style: AppStyles.headline3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter the amount you wish to add', style: AppStyles.small),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: AppStyles.body,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primaryWhite,
                  prefixText: 'NPR  ',
                  prefixStyle: AppStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [100, 500, 1000, 2000].map((amount) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        backgroundColor: AppColors.primaryWhite,
                        label: Text(
                          'NPR $amount',
                          style: AppStyles.small.copyWith(
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: AppColors.primaryOrange.withOpacity(0.3),
                          ),
                        ),
                        onPressed: () =>
                            amountController.text = amount.toString(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  ref
                      .read(paymentViewModelProvider.notifier)
                      .loadWallet(amount: amount);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add Now',
                style: AppStyles.button.copyWith(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
