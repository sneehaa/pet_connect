// widgets/pet_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';

class PetCard extends ConsumerWidget {
  final PetEntity pet;
  final VoidCallback onEdit;
  final VoidCallback onManage;
  final VoidCallback onDelete;

  const PetCard({
    super.key,
    required this.pet,
    required this.onEdit,
    required this.onManage,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 4, right: 4, top: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildPetImage(), _buildPetDetails(context)],
      ),
    );
  }

  Widget _buildPetImage() {
    final hasPhotos = pet.photos != null && pet.photos!.isNotEmpty;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 11,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: hasPhotos
                    ? DecorationImage(
                        image: NetworkImage(pet.photos!.first),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/default_pet.png'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // Updated Gradient Overlay (Darker at the bottom for text readability)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Pet Name and Age Overlay
            Positioned(
              left: 20,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    // Use headline style for prominence, override color to white
                    style: AppStyles.headline2.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryWhite,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        color: AppColors.primaryWhite.withOpacity(0.9),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${pet.age} months old',
                        // Use a smaller style, override color to white
                        style: AppStyles.small.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status Tag
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: pet.available
                      ? Colors.lightGreen.shade600
                      : Colors.red.shade600,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  pet.available ? 'AVAILABLE' : 'ADOPTED',
                  style: AppStyles.small.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Breed and Gender Tags
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoTag(
                icon: Icons.category_outlined,
                label: pet.breed,
                color: AppColors.primaryOrange,
              ),
              _buildInfoTag(
                icon: pet.gender.toLowerCase() == 'male'
                    ? Icons.male
                    : Icons.female,
                label: pet.gender,
                color: Colors.blue.shade700,
              ),
            ],
          ),
          const SizedBox(height: 24), // Increased spacing before buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildInfoTag({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12), // Slightly bolder background color
        borderRadius: BorderRadius.circular(
          15,
        ), // Slightly more rounded corners
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18), // Slightly larger icon
          const SizedBox(width: 8),
          Text(
            label,
            style: AppStyles.small.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700, // Bolder text
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // EDIT Button (Secondary)
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.primaryOrange.withOpacity(
                    0.5,
                  ), // Use orange for secondary outline
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                foregroundColor: AppColors.primaryOrange,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryOrange,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Edit Pet',
                    style: AppStyles.button.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        // MANAGE Button (Primary)
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onManage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                elevation: 5,
                shadowColor: AppColors.primaryOrange.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.manage_accounts_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Manage',
                    style: AppStyles.button.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
