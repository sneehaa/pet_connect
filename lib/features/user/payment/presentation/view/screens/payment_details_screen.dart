import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';
import 'package:pet_connect/features/user/payment/presentation/state/payment_state.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';

class PaymentDetailsScreen extends ConsumerStatefulWidget {
  final String paymentId;

  const PaymentDetailsScreen({super.key, required this.paymentId});

  @override
  ConsumerState<PaymentDetailsScreen> createState() =>
      _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends ConsumerState<PaymentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(paymentViewModelProvider.notifier)
          .loadPaymentDetails(widget.paymentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentViewModelProvider);
    final payment = state.currentPayment;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Transaction Detail', style: AppStyles.headline3),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textBlack,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(state, payment),
    );
  }

  Widget _buildBody(PaymentState state, PaymentModel? payment) {
    if (state.paymentStatus == PaymentStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (state.paymentStatus == PaymentStatus.error || payment == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: AppColors.iconGrey,
              ),
              const SizedBox(height: 16),
              Text(
                state.message ?? 'Oops! Record not found',
                style: AppStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => ref
                      .read(paymentViewModelProvider.notifier)
                      .loadPaymentDetails(widget.paymentId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                  ),
                  child: Text('Retry', style: AppStyles.button),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Receipt Container
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Status Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment.status).withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(payment.status),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStatusIcon(payment.status),
                          color: AppColors.primaryWhite,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        payment.statusText,
                        style: AppStyles.headline3.copyWith(
                          color: _getStatusColor(payment.status),
                        ),
                      ),
                      Text(
                        'ID: ${payment.transactionId ?? 'N/A'}',
                        style: AppStyles.small.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Text('Total Amount', style: AppStyles.subtitle),
                      const SizedBox(height: 4),
                      Text(
                        'NPR ${payment.amount.toStringAsFixed(2)}',
                        style: AppStyles.headline1.copyWith(
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dashed Line Separator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: List.generate(
                      30,
                      (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : AppColors.backgroundGrey,
                          height: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                // Detail Lists
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Payment Info'),
                      _buildDetailRow('Method', payment.paymentMethod),
                      _buildDetailRow(
                        'Date',
                        payment.createdAt != null
                            ? DateFormat(
                                'dd MMM yyyy, hh:mm a',
                              ).format(payment.createdAt!)
                            : 'N/A',
                      ),

                      const SizedBox(height: 20),
                      _buildSectionTitle('Reference'),
                      _buildDetailRow(
                        'Pet ID',
                        '#${payment.petId.substring(0, 8)}',
                      ),
                      _buildDetailRow(
                        'Adoption ID',
                        '#${payment.adoptionId.substring(0, 8)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Actions
          if (payment.isPending) _buildPendingActions() else _buildBackAction(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryOrange,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.small),
          Text(
            value,
            style: AppStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => ref
                .read(paymentViewModelProvider.notifier)
                .processPayment(paymentId: widget.paymentId),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text('Complete Payment Now', style: AppStyles.button),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PaymentDetailsScreen(paymentId: widget.paymentId),
              ),
            );
          },
          child: Text(
            'View Payment Summary',
            style: AppStyles.linkText.copyWith(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildBackAction() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryOrange),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Done',
          style: AppStyles.button.copyWith(color: AppColors.primaryOrange),
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
      case 'processing':
        return Colors.blueAccent;
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
      case 'processing':
        return Icons.sync_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }
}
