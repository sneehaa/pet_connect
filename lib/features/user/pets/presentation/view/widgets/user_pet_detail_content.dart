import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/adoption/domain/entity/adoption_entity.dart';
import 'package:pet_connect/features/user/adoption/presentation/state/adoption_state.dart';
import 'package:pet_connect/features/user/adoption/presentation/viewmodel/adoption_viewmodel.dart';
import 'package:pet_connect/features/user/payment/presentation/state/payment_state.dart';
import 'package:pet_connect/features/user/payment/presentation/view/screens/payment_screen.dart';
import 'package:pet_connect/features/user/payment/presentation/view/screens/wallet_screen.dart';
import 'package:pet_connect/features/user/payment/presentation/viewmodel/payment_viewmodel.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/user/pets/presentation/view/widgets/user_pet_detail_card.dart';

import 'user_pet_adopt_button.dart';
import 'user_pet_image_carousel.dart';
import 'user_pet_info_chips.dart';
import 'user_pet_section_title.dart';

class UserPetDetailContent extends ConsumerStatefulWidget {
  final UserPetEntity pet;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const UserPetDetailContent({
    super.key,
    required this.pet,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'booked':
        return 'Booked';
      case 'adopted':
        return 'Adopted';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.successGreen;
      case 'booked':
        return AppColors.warningYellow;
      case 'adopted':
        return AppColors.errorRed;
      default:
        return AppColors.textLightGrey;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  bool _isAvailableForAdoption() {
    return pet.status.toLowerCase() == 'available';
  }

  bool _isBookedForPayment() {
    return pet.status.toLowerCase() == 'booked';
  }

  @override
  ConsumerState<UserPetDetailContent> createState() =>
      _UserPetDetailContentState();
}

class _UserPetDetailContentState extends ConsumerState<UserPetDetailContent> {
  @override
  void initState() {
    super.initState();
    if (widget.pet.status.toLowerCase() == 'booked') {
      Future.delayed(Duration.zero, () {
        ref
            .read(userAdoptionViewModelProvider.notifier)
            .getAdoptionStatus(widget.pet.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adoptionState = ref.watch(userAdoptionViewModelProvider);
    final currentAdoption = adoptionState.currentAdoption;

    ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
      if (next.paymentProcessingStatus == PaymentProcessingStatus.success) {
        final id = next.currentPayment?.id;
        if (id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PaymentScreen(paymentId: id)),
          );
          ref
              .read(paymentViewModelProvider.notifier)
              .clearPaymentProcessingStatus();
        }
      } else if (next.paymentProcessingStatus ==
          PaymentProcessingStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.paymentMessage ?? 'Payment Failed')),
        );
      }
    });

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                background: UserPetImageCarousel(
                  pet: widget.pet,
                  pageController: widget.pageController,
                  currentPage: widget.currentPage,
                  onPageChanged: widget.onPageChanged,
                ),
              ),
              pinned: true,
              floating: false,
              backgroundColor: AppColors.background,
              leading: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!widget._isAvailableForAdoption())
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget
                                            ._getStatusColor(widget.pet.status)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: widget
                                              ._getStatusColor(
                                                widget.pet.status,
                                              )
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        widget._getStatusText(
                                          widget.pet.status,
                                        ),
                                        style: AppStyles.small.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: widget._getStatusColor(
                                            widget.pet.status,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryOrange
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primaryOrange
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      widget.pet.breed,
                                      style: AppStyles.small.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryOrange,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.pet.name,
                                    style: AppStyles.headline1.copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  UserPetInfoChips(pet: widget.pet),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        if (widget.pet.description != null &&
                            widget.pet.description!.isNotEmpty) ...[
                          const UserPetSectionTitle(title: 'About'),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.textLightGrey.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              widget.pet.description!,
                              style: AppStyles.body.copyWith(
                                color: AppColors.textDarkGrey,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (widget.pet.personality != null &&
                            widget.pet.personality!.isNotEmpty) ...[
                          const UserPetSectionTitle(title: 'Personality'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: widget.pet.personality!
                                .split(',')
                                .map(
                                  (trait) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primaryOrange.withOpacity(
                                            0.15,
                                          ),
                                          AppColors.primaryOrange.withOpacity(
                                            0.08,
                                          ),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.primaryOrange
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      trait.trim(),
                                      style: AppStyles.small.copyWith(
                                        color: AppColors.primaryOrange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (widget.pet.medicalInfo != null &&
                            widget.pet.medicalInfo!.isNotEmpty) ...[
                          const UserPetSectionTitle(
                            title: 'Medical Information',
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryOrange.withOpacity(0.1),
                                  AppColors.primaryOrange.withOpacity(0.15),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primaryOrange.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.health_and_safety,
                                  color: AppColors.primaryOrange,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.pet.medicalInfo!,
                                    style: AppStyles.body.copyWith(
                                      color: AppColors.textDarkGrey,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        const UserPetSectionTitle(title: 'Details'),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: [
                            UserPetDetailCard(
                              icon: Icons.calendar_today,
                              title: 'Listed On',
                              value: widget.pet.createdAt != null
                                  ? widget._formatDate(widget.pet.createdAt!)
                                  : 'N/A',
                              color: Colors.purple,
                            ),
                            UserPetDetailCard(
                              icon: Icons.public,
                              title: 'Status',
                              value: widget._getStatusText(widget.pet.status),
                              color: widget._getStatusColor(widget.pet.status),
                            ),
                            UserPetDetailCard(
                              icon: Icons.attach_money,
                              title: 'Amount',
                              value: 'Rs. ${_getAdoptionFee(widget.pet)}',
                              color: Colors.green,
                            ),
                          ],
                        ),
                        if (widget._isBookedForPayment()) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warningYellow.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.warningYellow.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      color: AppColors.warningYellow,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Payment Required',
                                      style: AppStyles.body.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warningYellow,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'To complete the adoption process, please proceed with the payment. Your adoption request has been approved.',
                                  style: AppStyles.small.copyWith(
                                    color: AppColors.textDarkGrey.withOpacity(
                                      0.8,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.textLightGrey
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Adoption Fee',
                                        style: AppStyles.body.copyWith(
                                          color: AppColors.textDarkGrey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Rs. ${_getAdoptionFee(widget.pet)}',
                                        style: AppStyles.headline3.copyWith(
                                          color: AppColors.primaryOrange,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (!widget._isAvailableForAdoption()) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: widget
                                  ._getStatusColor(widget.pet.status)
                                  .withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: widget
                                    ._getStatusColor(widget.pet.status)
                                    .withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(widget.pet.status),
                                  color: widget._getStatusColor(
                                    widget.pet.status,
                                  ),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getStatusTitle(widget.pet.status),
                                        style: AppStyles.body.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: widget._getStatusColor(
                                            widget.pet.status,
                                          ),
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getStatusMessage(widget.pet.status),
                                        style: AppStyles.small.copyWith(
                                          color: AppColors.textDarkGrey
                                              .withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
        _buildBottomButton(context, ref, currentAdoption, adoptionState),
      ],
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    WidgetRef ref,
    UserAdoptionEntity? currentAdoption,
    UserAdoptionState adoptionState,
  ) {
    switch (widget.pet.status.toLowerCase()) {
      case 'available':
        return UserPetAdoptButton(pet: widget.pet);
      case 'booked':
        if (adoptionState.isLoading) {
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        if (adoptionState.status == UserAdoptionStatus.error) {
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                adoptionState.message ?? 'Failed to load adoption details.',
                style: AppStyles.body.copyWith(color: AppColors.errorRed),
              ),
            ),
          );
        }
        return _buildPaymentButton(context, ref, currentAdoption);
      case 'adopted':
        return _buildAdoptedInfo();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPaymentButton(
    BuildContext context,
    WidgetRef ref,
    UserAdoptionEntity? currentAdoption,
  ) {
    final isEnabled = currentAdoption != null;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.98),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: AppColors.textLightGrey.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: isEnabled
                ? () => _navigateToPayment(ref, currentAdoption)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled
                  ? AppColors.successGreen
                  : AppColors.textLightGrey,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.payment, size: 22),
                const SizedBox(width: 12),
                Text(
                  'Pay Rs. ${_getAdoptionFee(widget.pet)}',
                  style: AppStyles.button.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdoptedInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.errorRed.withOpacity(0.1),
              AppColors.errorRed.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: AppColors.errorRed.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.errorRed, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Successfully Adopted',
                    style: AppStyles.body.copyWith(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'This pet has found a loving home and is no longer available for adoption.',
                style: AppStyles.small.copyWith(
                  color: AppColors.textDarkGrey.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPayment(WidgetRef ref, UserAdoptionEntity? currentAdoption) {
    final businessId = widget.pet.businessId;
    final adoptionId = currentAdoption?.id;

    if (businessId.isEmpty || adoptionId == null || adoptionId.isEmpty) {
      debugPrint("❌ Payment Blocked: Missing IDs");
      debugPrint("Pet BusinessId: $businessId");
      debugPrint("Adoption Id: $adoptionId");

      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(
          content: Text('Error: Could not retrieve required ID information.'),
        ),
      );
      return;
    }

    // Check wallet first
    _checkWalletAndProceed(context, ref, currentAdoption!);
  }

  Future<void> _checkWalletAndProceed(
    BuildContext context,
    WidgetRef ref,
    UserAdoptionEntity currentAdoption,
  ) async {
    final amount = widget.pet.amount.toDouble();

    // Check wallet status first
    final paymentState = ref.read(paymentViewModelProvider);

    if (paymentState.walletStatus == WalletStatus.error) {
      _showWalletNotFoundDialog(context);
      return;
    }

    // Get wallet balance if not already loaded
    if (paymentState.walletStatus != WalletStatus.loaded) {
      await ref.read(paymentViewModelProvider.notifier).loadWalletBalance();
    }

    final currentBalance = ref.read(paymentViewModelProvider).walletBalance;
    final requiredAmount = widget.pet.amount.toDouble();

    if (currentBalance < requiredAmount) {
      _showInsufficientFundsDialog(context, currentBalance, requiredAmount);
      return;
    }

    // Wallet exists and has enough funds - proceed with payment
    ref
        .read(paymentViewModelProvider.notifier)
        .initiatePayment(
          petId: widget.pet.id,
          amount: requiredAmount,
          adoptionId: currentAdoption.id!,
          businessId: widget.pet.businessId,
          checkWalletFirst: false, // Already checked
        );
  }

  void _showWalletNotFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Wallet Required',
            style: AppStyles.headline3.copyWith(color: AppColors.textBlack),
          ),
          content: Text(
            'You need to set up a wallet before making payments. '
            'Would you like to create a wallet now?',
            style: AppStyles.body.copyWith(color: AppColors.textGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Not Now',
                style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                );
              },
              child: Text('Setup Wallet', style: AppStyles.button),
            ),
          ],
        );
      },
    );
  }

  void _showInsufficientFundsDialog(
    BuildContext context,
    double currentBalance,
    double requiredAmount,
  ) {
    final shortfall = requiredAmount - currentBalance;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Insufficient Funds',
            style: AppStyles.headline3.copyWith(color: AppColors.textBlack),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have Rs. $currentBalance in your wallet, '
                'but need Rs. $requiredAmount for this adoption.\n\n'
                'You are short by Rs. $shortfall.',
                style: AppStyles.body.copyWith(color: AppColors.textGrey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Required Amount:',
                      style: AppStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Rs. $requiredAmount',
                      style: AppStyles.headline3.copyWith(
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                );
              },
              child: Text('Add Funds', style: AppStyles.button),
            ),
          ],
        );
      },
    );
  }

  String _getAdoptionFee(UserPetEntity pet) {
    return pet.amount.toString();
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return Icons.schedule;
      case 'adopted':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusTitle(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return 'Adoption Pending';
      case 'adopted':
        return 'Successfully Adopted';
      default:
        return 'Status';
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return 'This pet has an approved adoption request. Payment is pending to finalize the adoption.';
      case 'adopted':
        return 'This pet has been successfully adopted and is no longer available.';
      default:
        return '';
    }
  }
}
