import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

class ContactOptionsSheet extends StatelessWidget {
  final BusinessEntity business;

  const ContactOptionsSheet({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Contact ${business.businessName}',
            style: AppStyles.headline3.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          _buildContactOption(
            icon: Icons.phone,
            label: 'Call',
            value: business.phoneNumber,
            onTap: () {
              // Implement phone call
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _buildContactOption(
            icon: Icons.email,
            label: 'Email',
            value: business.email,
            onTap: () {
              // Implement email
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryOrange, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppStyles.small.copyWith(
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textLightGrey,
            ),
          ],
        ),
      ),
    );
  }
}
