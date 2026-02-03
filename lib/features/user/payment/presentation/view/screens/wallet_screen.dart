import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/user/payment/presentation/state/payment_state.dart';
import 'package:pet_connect/features/user/payment/presentation/view/screens/payment_history_screen.dart';
import 'package:pet_connect/features/user/payment/presentation/view/widgets/transaction_list.dart';
import 'package:pet_connect/features/user/payment/presentation/view/widgets/wallet_card.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentViewModelProvider.notifier).loadWalletBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentViewModelProvider);
    ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
      if (previous?.walletStatus == WalletStatus.loading &&
          next.walletStatus != WalletStatus.loading) {
        if (next.walletMessage != null && next.walletMessage!.isNotEmpty) {
          // Use your custom showSnackBar function
          showSnackBar(
            context: context,
            message: next.walletMessage!,
            isSuccess: next.walletStatus != WalletStatus.error,
          );

          // Optional: Clear message in viewmodel after showing to prevent repeat triggers
          ref.read(paymentViewModelProvider.notifier).clearMessages();
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('My Wallet', style: AppStyles.headline3),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textBlack,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => ref
                  .read(paymentViewModelProvider.notifier)
                  .loadWalletBalance(),
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Wallet card with padding to breathe
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: WalletCard(),
          ),

          const SizedBox(height: 30),

          // Transaction history section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction History',
                        style: AppStyles.headline3.copyWith(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentHistoryScreen(),
                            ),
                          );
                        },
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Details',
                              style: AppStyles.small.copyWith(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.history_edu_rounded,
                              color: AppColors.primaryOrange,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Expanded(child: TransactionList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(PaymentState state) {
    final isError = state.walletStatus == WalletStatus.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isError
            ? AppColors.errorRed.withOpacity(0.1)
            : AppColors.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        state.walletMessage!,
        style: AppStyles.small.copyWith(
          color: isError ? AppColors.errorRed : AppColors.successGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
