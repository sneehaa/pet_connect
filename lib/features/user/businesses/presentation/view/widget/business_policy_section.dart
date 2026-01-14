import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

class BusinessPolicySection extends StatelessWidget {
  final BusinessEntity business;

  const BusinessPolicySection({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.policy, color: AppColors.primaryOrange, size: 24),
              const SizedBox(width: 12),
              Text(
                'Adoption Policy',
                style: AppStyles.headline3.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            business.adoptionPolicy!,
            style: AppStyles.body.copyWith(
              color: AppColors.textDarkGrey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
