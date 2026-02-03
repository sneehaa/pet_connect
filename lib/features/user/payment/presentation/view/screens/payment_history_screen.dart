import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';
import 'package:pet_connect/features/user/payment/presentation/state/payment_state.dart';
import 'package:pet_connect/features/user/payment/presentation/view/screens/payment_details_screen.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentViewModelProvider.notifier).loadUserPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Payment History', style: AppStyles.headline3),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textBlack,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PaymentState state) {
    if (state.paymentStatus == PaymentStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (state.paymentStatus == PaymentStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message ?? 'Error loading payments',
              style: AppStyles.subtitle,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(paymentViewModelProvider.notifier)
                  .loadUserPayments(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
              ),
              child: Text('Retry', style: AppStyles.button),
            ),
          ],
        ),
      );
    }

    if (state.userPayments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history_rounded,
              size: 80,
              color: AppColors.backgroundGrey,
            ),
            const SizedBox(height: 16),
            Text('No payments yet', style: AppStyles.headline3),
            Text(
              'Your adoption transactions will appear here.',
              style: AppStyles.small,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      onRefresh: () async =>
          ref.read(paymentViewModelProvider.notifier).loadUserPayments(),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: state.userPayments.length,
        itemBuilder: (context, index) =>
            _buildPaymentCard(state.userPayments[index]),
      ),
    );
  }

  Widget _buildPaymentCard(PaymentModel payment) {
    final statusColor = _getStatusColor(payment.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () {
          if (payment.id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PaymentDetailsScreen(paymentId: payment.id!),
              ),
            );
          } else {
            showSnackBar(
              context: context,
              message: "Invalid Payment ID",
              isSuccess: false,
            );
          }
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(payment.status),
            color: statusColor,
            size: 24,
          ),
        ),
        title: Text(
          'Pet Adoption',
          style: AppStyles.body.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              payment.createdAt != null
                  ? DateFormat(
                      'dd MMM yyyy • hh:mm a',
                    ).format(payment.createdAt!)
                  : 'Date N/A',
              style: AppStyles.small,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                payment.statusText.toUpperCase(),
                style: AppStyles.small.copyWith(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'NPR ${payment.amount.toStringAsFixed(0)}',
              style: AppStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.backgroundGrey,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.successGreen;
      case 'pending':
        return AppColors.warningYellow;
      case 'failed':
        return AppColors.errorRed;
      default:
        return AppColors.textLightGrey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_rounded;
      case 'failed':
        return Icons.close_rounded;
      default:
        return Icons.access_time_filled_rounded;
    }
  }
}
