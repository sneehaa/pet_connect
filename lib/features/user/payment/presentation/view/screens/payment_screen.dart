import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/payment/presentation/state/payment_state.dart';
import 'package:pet_connect/features/user/payment/presentation/view/screens/payment_history_screen.dart';
import 'package:pet_connect/features/user/payment/presentation/view/widgets/payment_summary_card.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';

class PaymentScreen extends ConsumerWidget {
  final String paymentId;

  const PaymentScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. WATCH the processing boolean for the loading overlay
    final isProcessing = ref
        .watch(paymentViewModelProvider)
        .isProcessingPayment;

    // 2. LISTEN for the success status to navigate
    ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
      if (next.paymentProcessingStatus == PaymentProcessingStatus.success) {
        // Clear status so it doesn't trigger again on future visits
        ref
            .read(paymentViewModelProvider.notifier)
            .loadUserPayments(); // Optional: refresh history

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaymentHistoryScreen()),
        );
      }

      // Handle Error feedback here too
      if (next.paymentProcessingStatus == PaymentProcessingStatus.error &&
          next.paymentMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.paymentMessage!),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text('Checkout', style: AppStyles.headline3),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textBlack,
                size: 20,
              ),
              onPressed: isProcessing ? null : () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryWhite,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primaryOrange,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Finalize Your Adoption",
                  style: AppStyles.headline2.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Complete your adoption payment to welcome your new friend home!",
                  style: AppStyles.subtitle.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Logic Card
                PaymentSummaryCard(paymentId: paymentId),

                const SizedBox(height: 32),
                _buildSecurityBadge(),
              ],
            ),
          ),
        ),

        // 3. LOADING OVERLAY
        if (isProcessing)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            ),
          ),
      ],
    );
  }

  Widget _buildSecurityBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_outline_rounded,
          size: 16,
          color: AppColors.textLightGrey,
        ),
        const SizedBox(width: 8),
        Text(
          "Secure Encryption",
          style: AppStyles.small.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
