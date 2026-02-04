import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

class BusinessPaymentDetailScreen extends ConsumerStatefulWidget {
  final PaymentModel payment;
  const BusinessPaymentDetailScreen({super.key, required this.payment});

  @override
  ConsumerState<BusinessPaymentDetailScreen> createState() =>
      _BusinessPaymentDetailScreenState();
}

class _BusinessPaymentDetailScreenState
    extends ConsumerState<BusinessPaymentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    final String initiatedDate = payment.createdAt != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(payment.createdAt!)
        : 'N/A';
    final String completedDate = payment.completedAt != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(payment.completedAt!)
        : 'Pending';

    return Scaffold(
      backgroundColor: AppColors.primaryWhite, // Clean white background
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.textBlack,
          ), // "Close" feels better for detail modals
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Transaction Detail', style: AppStyles.headline3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- SECTION 1: TOP SUMMARY ---
            _buildCompactHeader(payment),
            const SizedBox(height: 32),

            // --- SECTION 2: TRANSACTION DETAILS ---
            _buildSectionTitle('Payment Information'),
            const SizedBox(height: 12),
            _buildDetailRow('Customer', payment.userName ?? 'Unknown User'),
            _buildDetailRow('Pet Name', payment.petName ?? 'N/A'),
            _buildDetailRow('Adoption ID', '#${payment.adoptionId}'),
            _buildDetailRow('Transaction ID', payment.transactionId ?? 'N/A'),

            const Divider(
              height: 40,
              thickness: 1,
              color: AppColors.background,
            ),

            // --- SECTION 3: DATES ---
            _buildSectionTitle('Timeline'),
            const SizedBox(height: 12),
            _buildDetailRow('Initiated', initiatedDate),
            _buildDetailRow('Completed', completedDate),

            const SizedBox(height: 40),
            if (payment.status == 'pending') _buildActionButtons(payment),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader(PaymentModel payment) {
    return Column(
      children: [
        Text(
          'Rs. ${payment.amount.toStringAsFixed(2)}',
          style: AppStyles.headline1.copyWith(
            fontSize: 40,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(payment.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            payment.statusText.toUpperCase(),
            style: AppStyles.small.copyWith(
              color: _getStatusColor(payment.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppStyles.body.copyWith(
          color: AppColors.textLightGrey,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppStyles.body.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.successGreen;
      case 'failed':
        return AppColors.errorRed;
      default:
        return AppColors.primaryOrange;
    }
  }

  Widget _buildActionButtons(PaymentModel payment) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textBlack,
              padding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Confirm Receipt',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Issue Refund',
            style: TextStyle(color: AppColors.errorRed),
          ),
        ),
      ],
    );
  }
}
