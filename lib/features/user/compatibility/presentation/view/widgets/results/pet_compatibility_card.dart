import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

class PetCompatibilityCard extends StatelessWidget {
  final int score;
  final UserPetEntity? pet;
  final Map<String, dynamic> breakdown;
  final VoidCallback onTap;

  const PetCompatibilityCard({
    super.key,
    required this.score,
    this.pet,
    required this.breakdown,
    required this.onTap,
  });

  Color _getScoreColor() {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 60) return AppColors.warningYellow;
    return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final Color scoreColor = _getScoreColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Pet Image with Status Overlay
                Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: pet?.photos.isNotEmpty == true
                            ? DecorationImage(
                                image: NetworkImage(pet!.photos.first),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: AppColors.backgroundGrey,
                      ),
                      child: pet?.photos.isEmpty == true
                          ? const Icon(
                              Icons.pets,
                              size: 30,
                              color: AppColors.textLightGrey,
                            )
                          : null,
                    ),
                    if (pet?.vaccinated == true)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            color: AppColors.primaryBlue,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Pet Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet?.name ?? 'Unknown Pet',
                        style: AppStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${pet?.breed ?? 'Mixed Breed'} • ${pet?.age}y',
                        style: AppStyles.small.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildTag(
                            pet?.gender == 'Female' ? Icons.female : Icons.male,
                            pet?.gender ?? '',
                            pet?.gender == 'Female'
                                ? Colors.pink
                                : AppColors.primaryBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Score Display
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$score%',
                        style: AppStyles.headline3.copyWith(
                          color: scoreColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'MATCH',
                        style: AppStyles.small.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.small.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
