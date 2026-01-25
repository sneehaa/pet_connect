import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

import 'user_pet_adopt_button.dart';
import 'user_pet_detail_card.dart';
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
                              value: pet.available ? 'Available' : 'Adopted',
                              color: pet.available
                                  ? AppColors.successGreen
                                  : AppColors.errorRed,
                            ),
                          ],
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
        UserPetAdoptButton(pet: pet),
      ],
    );
  }
}
