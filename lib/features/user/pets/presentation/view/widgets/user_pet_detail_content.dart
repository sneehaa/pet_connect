import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/user/pets/presentation/view/widgets/user_pet_detail_card.dart';

import 'user_pet_adopt_button.dart';
import 'user_pet_image_carousel.dart';
import 'user_pet_info_chips.dart';
import 'user_pet_section_title.dart';

class UserPetDetailContent extends StatelessWidget {
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

  // Helper method to get status display text
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

  // Helper method to get status color
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

  // Helper method to format date
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

  // Helper method to check if pet is available for adoption
  bool _isAvailableForAdoption() {
    return pet.status.toLowerCase() == 'available';
  }

  // Helper method to check if pet is booked (pending payment)
  bool _isBookedForPayment() {
    return pet.status.toLowerCase() == 'booked';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                background: UserPetImageCarousel(
                  pet: pet,
                  pageController: pageController,
                  currentPage: currentPage,
                  onPageChanged: onPageChanged,
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
                        // Pet name and basic info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Status badge (if not available)
                                  if (!_isAvailableForAdoption())
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          pet.status,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getStatusColor(
                                            pet.status,
                                          ).withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        _getStatusText(pet.status),
                                        style: AppStyles.small.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(pet.status),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),

                                  // Breed badge
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
                                      pet.breed,
                                      style: AppStyles.small.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryOrange,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Pet name
                                  Text(
                                    pet.name,
                                    style: AppStyles.headline1.copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Info chips
                                  UserPetInfoChips(pet: pet),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // About section
                        if (pet.description != null &&
                            pet.description!.isNotEmpty) ...[
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
                              pet.description!,
                              style: AppStyles.body.copyWith(
                                color: AppColors.textDarkGrey,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Personality section
                        if (pet.personality != null &&
                            pet.personality!.isNotEmpty) ...[
                          const UserPetSectionTitle(title: 'Personality'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: pet.personality!
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

                        // Medical Information section
                        if (pet.medicalInfo != null &&
                            pet.medicalInfo!.isNotEmpty) ...[
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
                                    pet.medicalInfo!,
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

                        // Details section
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
                              value: pet.createdAt != null
                                  ? _formatDate(pet.createdAt!)
                                  : 'N/A',
                              color: Colors.purple,
                            ),
                            UserPetDetailCard(
                              icon: Icons.public,
                              title: 'Status',
                              value: _getStatusText(pet.status),
                              color: _getStatusColor(pet.status),
                            ),
                          ],
                        ),

                        // Payment Information (if booked)
                        if (_isBookedForPayment()) ...[
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
                                        'Rs. ${_getAdoptionFee(pet)}',
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

                        // Adoption Status Info (if not available)
                        if (!_isAvailableForAdoption()) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                pet.status,
                              ).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _getStatusColor(
                                  pet.status,
                                ).withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(pet.status),
                                  color: _getStatusColor(pet.status),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getStatusTitle(pet.status),
                                        style: AppStyles.body.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: _getStatusColor(pet.status),
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getStatusMessage(pet.status),
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
        // Show different bottom buttons based on status
        _buildBottomButton(context),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    switch (pet.status.toLowerCase()) {
      case 'available':
        return UserPetAdoptButton(pet: pet);
      case 'booked':
        return _buildPaymentButton(context);
      case 'adopted':
        return _buildAdoptedInfo();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPaymentButton(BuildContext context) {
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
            onPressed: () {
              // Navigate to payment screen
              _navigateToPayment(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
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
                  'Pay Rs. ${_getAdoptionFee(pet)}',
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

  void _navigateToPayment(BuildContext context) {
    // Navigate to payment screen
    // You'll need to implement this based on your payment flow
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          petId: pet.id,
          petName: pet.name,
          amount: _getAdoptionFee(pet),
        ),
      ),
    );
    */
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to payment for ${pet.name}'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  // Helper method to get adoption fee
  // Note: You'll need to add an 'amount' field to your UserPetEntity
  // or get it from another source (like adoption record)
  String _getAdoptionFee(UserPetEntity pet) {
    // If your UserPetEntity has amount field:
    // return pet.amount?.toStringAsFixed(0) ?? '0';

    // Temporary placeholder - update based on your data structure
    return '20000'; // Example amount
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
