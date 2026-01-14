import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

class UserPetCard extends StatelessWidget {
  final UserPetEntity pet;
  final VoidCallback onTap;

  const UserPetCard({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Add this
          children: [
            // Pet Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                color: AppColors.textLightGrey,
                child: pet.photos.isNotEmpty
                    ? Image.network(
                        pet.photos[0],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(Icons.pets, size: 50, color: Colors.white),
                      ),
              ),
            ),

            // Pet Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  Text(
                    pet.name,
                    style: AppStyles.headline3.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // Add this
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet.breed,
                    style: AppStyles.small.copyWith(
                      color: AppColors.textLightGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // Add this
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min, // Add this
                    children: [
                      Icon(
                        Icons.cake,
                        size: 12,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        // Wrap with Flexible
                        child: Text(
                          '${pet.age} ${pet.age == 1 ? 'month' : 'months'}',
                          style: AppStyles.small.copyWith(
                            color: AppColors.textLightGrey,
                          ),
                          maxLines: 1, // Add this
                          overflow: TextOverflow.ellipsis, // Add this
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        pet.gender.toLowerCase() == 'male'
                            ? Icons.male
                            : Icons.female,
                        size: 12,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        // Wrap with Flexible
                        child: Text(
                          pet.gender,
                          style: AppStyles.small.copyWith(
                            color: AppColors.textLightGrey,
                          ),
                          maxLines: 1, // Add this
                          overflow: TextOverflow.ellipsis, // Add this
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
