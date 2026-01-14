import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

class BusinessCard extends StatelessWidget {
  final BusinessEntity business;
  final VoidCallback onTap;

  const BusinessCard({super.key, required this.business, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
          children: [
            // Business Image (Placeholder)
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.business,
                  size: 50,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),

            // Business Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          business.businessName,
                          style: AppStyles.headline3.copyWith(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Username
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 14,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '@${business.username}',
                        style: AppStyles.body.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Contact Info
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 12,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          business.email,
                          style: AppStyles.small.copyWith(
                            color: AppColors.textLightGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 12,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        business.phoneNumber,
                        style: AppStyles.small.copyWith(
                          color: AppColors.textLightGrey,
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
