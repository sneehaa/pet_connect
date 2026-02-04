import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textBlack,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Payment detail', style: AppStyles.headline3),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildMainHeader(payment),
            const SizedBox(height: 24),
            _buildInfoCard(
              title: 'Transaction Details',
              children: [
                _buildModernRow(
                  Icons.person_outline,
                  'Customer',
                  payment.userName ?? 'Unknown',
                ),
                _buildModernRow(
                  Icons.pets_outlined,
                  'Pet Name',
                  payment.petName ?? 'N/A',
                ),
                _buildModernRow(
                  Icons.fingerprint,
                  'Adoption ID',
                  '#${payment.adoptionId}',
                ),
                _buildModernRow(
                  Icons.receipt_long_outlined,
                  'Reference',
                  payment.transactionId ?? 'N/A',
                  showCopy: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Timeline',
              children: [
                _buildModernRow(
                  Icons.calendar_today_outlined,
                  'Initiated',
                  initiatedDate,
                ),
                _buildModernRow(
                  Icons.check_circle_outline,
                  'Completed',
                  completedDate,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHeader(PaymentModel payment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
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
          CircleAvatar(
            radius: 30,
            backgroundColor: _getStatusColor(payment.status).withOpacity(0.1),
            child: Icon(
              _getStatusIcon(payment.status),
              color: _getStatusColor(payment.status),
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Rs. ${payment.amount.toStringAsFixed(2)}',
            style: AppStyles.headline1.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(payment.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              payment.statusText.toUpperCase(),
              style: AppStyles.small.copyWith(
                color: _getStatusColor(payment.status),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textLightGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernRow(
    IconData icon,
    String label,
    String value, {
    bool showCopy = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.textLightGrey.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: AppStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        softWrap: true,
                      ),
                    ),
                    if (showCopy)
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: value));
                          HapticFeedback.mediumImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 6.0, top: 2),
                          child: Icon(
                            Icons.copy,
                            size: 14,
                            color: AppColors.primaryOrange,
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
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.verified_rounded;
      case 'failed':
        return Icons.error_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF27AE60);
      case 'failed':
        return const Color(0xFFEB5757);
      default:
        return const Color(0xFFF2994A);
    }
  }
}
