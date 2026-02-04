import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/business/business_payment/presentation/state/business_payment_state.dart';
import 'package:pet_connect/features/business/business_payment/presentation/view/screens/business_payment_detail_screen.dart';
import 'package:pet_connect/features/business/business_payment/presentation/view/widgets/business_payment_widgets.dart';
import 'package:pet_connect/features/business/business_payment/presentation/viewmodel/business_payment_viewmodel.dart';
import 'package:pet_connect/features/user/payment/data/model/payment_model.dart';

class BusinessPaymentDashboardScreen extends ConsumerStatefulWidget {
  const BusinessPaymentDashboardScreen({super.key});

  @override
  ConsumerState<BusinessPaymentDashboardScreen> createState() =>
      _BusinessPaymentDashboardScreenState();
}

class _BusinessPaymentDashboardScreenState
    extends ConsumerState<BusinessPaymentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessPaymentViewModelProvider.notifier)
        ..loadBusinessWalletBalance()
        ..loadBusinessEarnings()
        ..loadBusinessTransactions();
    });
  }

  void _navigateToPaymentDetail(PaymentModel payment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessPaymentDetailScreen(payment: payment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessPaymentViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(businessPaymentViewModelProvider.notifier)
            ..loadBusinessWalletBalance()
            ..loadBusinessEarnings()
            ..loadBusinessTransactions();
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: AppColors.primaryWhite,
              elevation: 0,
              pinned: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: Text(
                  'Business Dashboard',
                  style: AppStyles.headline3.copyWith(
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ref.read(businessPaymentViewModelProvider.notifier)
                      ..loadBusinessWalletBalance()
                      ..loadBusinessEarnings()
                      ..loadBusinessTransactions();
                  },
                  icon: Icon(Icons.refresh, color: AppColors.primaryOrange),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Wallet Balance Section
            SliverToBoxAdapter(child: _buildWalletBalanceCard(state)),

            // Earnings Stats Section
            SliverToBoxAdapter(child: _buildEarningsStatsSection(state)),

            // Recent Transactions Section
            SliverToBoxAdapter(child: _buildRecentTransactionsSection(state)),

            // Payment History Section
            SliverToBoxAdapter(child: _buildPaymentHistorySection(state)),

            // Bottom Padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletBalanceCard(BusinessPaymentState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryOrange.withOpacity(0.9),
              AppColors.primaryOrange.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Balance',
                    style: AppStyles.headline3.copyWith(
                      color: AppColors.primaryWhite,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primaryWhite,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Rs. ',
                    style: AppStyles.headline1.copyWith(
                      color: AppColors.primaryWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    state.isLoadingWallet
                        ? '--.--'
                        : state.businessWalletBalance.toStringAsFixed(2),
                    style: AppStyles.headline1.copyWith(
                      color: AppColors.primaryWhite,
                      fontSize: 42,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (state.walletMessage != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryWhite,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.walletMessage!,
                          style: AppStyles.small.copyWith(
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsStatsSection(BusinessPaymentState state) {
    final stats = state.earnings?.stats;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Earnings Overview',
              style: AppStyles.headline3.copyWith(color: AppColors.textBlack),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildStatCard(
                icon: Icons.attach_money_rounded,
                title: 'Total Earnings',
                value: stats != null
                    ? 'Rs. ${stats.totalAmount.toStringAsFixed(2)}'
                    : state.isLoadingEarnings
                    ? 'Loading...'
                    : 'Rs. 0.00',
                isLoading: state.isLoadingEarnings,
              ),
              _buildStatCard(
                icon: Icons.receipt_long_rounded,
                title: 'Total Transactions',
                value: stats != null
                    ? stats.totalTransactions.toString()
                    : state.isLoadingEarnings
                    ? '...'
                    : '0',
                isLoading: state.isLoadingEarnings,
              ),
              _buildStatCard(
                icon: Icons.trending_up_rounded,
                title: 'Average Payment',
                value: stats != null
                    ? 'Rs. ${stats.averageAmount.toStringAsFixed(2)}'
                    : state.isLoadingEarnings
                    ? '...'
                    : 'Rs. 0.00',
                isLoading: state.isLoadingEarnings,
              ),
              _buildStatCard(
                icon: Icons.account_balance_wallet,
                title: 'Available Balance',
                value: state.isLoadingWallet
                    ? 'Loading...'
                    : 'Rs. ${state.businessWalletBalance.toStringAsFixed(2)}',
                isLoading: state.isLoadingWallet,
              ),
            ],
          ),
          if (state.earningsMessage != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.errorRed,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.earningsMessage!,
                      style: AppStyles.small.copyWith(
                        color: AppColors.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isLoading,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primaryOrange, size: 18),
                ),
                const Spacer(),
                if (isLoading)
                  const SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryOrange,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.small.copyWith(
                      color: AppColors.textLightGrey,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppStyles.small.copyWith(
                      fontSize: 14,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsSection(BusinessPaymentState state) {
    final transactions = state.recentTransactions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: AppStyles.headline3.copyWith(
                    color: AppColors.textBlack,
                  ),
                ),
                if (transactions.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      // Navigate to full transactions screen
                    },
                    child: Text(
                      'View All',
                      style: AppStyles.small.copyWith(
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (state.isLoadingTransactions)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryOrange,
                ),
              ),
            )
          else if (transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 64,
                    color: AppColors.textLightGrey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Transactions Yet',
                    style: AppStyles.body.copyWith(
                      color: AppColors.textLightGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your transactions will appear here',
                    style: AppStyles.small.copyWith(
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: transactions
                    .take(5)
                    .map(
                      (transaction) =>
                          TransactionListItem(transaction: transaction),
                    )
                    .toList(),
              ),
            ),
          if (state.transactionsMessage != null && !state.isLoadingTransactions)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warningYellow.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warningYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.transactionsMessage!,
                      style: AppStyles.small.copyWith(
                        color: AppColors.warningYellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistorySection(BusinessPaymentState state) {
    final payments = state.earnings?.history ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Payments',
                  style: AppStyles.headline3.copyWith(
                    color: AppColors.textBlack,
                  ),
                ),
                if (payments.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      // Navigate to full payment history
                    },
                    child: Text(
                      'View All',
                      style: AppStyles.small.copyWith(
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (payments.isEmpty && !state.isLoadingEarnings)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.payment_rounded,
                    size: 64,
                    color: AppColors.textLightGrey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Payments Yet',
                    style: AppStyles.body.copyWith(
                      color: AppColors.textLightGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your payment history will appear here',
                    style: AppStyles.small.copyWith(
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
            )
          else
            ...payments
                .take(3)
                .map(
                  (payment) => PaymentHistoryCard(
                    payment: payment,
                    onTap: () =>
                        _navigateToPaymentDetail(payment as PaymentModel),
                  ),
                ),
        ],
      ),
    );
  }
}
