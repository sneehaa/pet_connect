import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';

class PetActionsBottomSheet extends StatelessWidget {
  final PetEntity pet;
  final Function(String) onUpdateStatus;
  final VoidCallback onViewAdoptionRequests;
  final VoidCallback onDelete;

  const PetActionsBottomSheet({
    super.key,
    required this.pet,
    required this.onUpdateStatus,
    required this.onViewAdoptionRequests,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = pet.status.toLowerCase() == 'available';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          Text(
            'Manage ${pet.name}',
            style: AppStyles.headline3.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 30),
          _buildActionTile(
            icon: isAvailable ? Icons.check_circle_outline : Icons.public,
            title: isAvailable ? 'Mark as Adopted' : 'Mark as Available',
            subtitle: isAvailable
                ? 'Change status to Adopted'
                : 'Change status to Available',
            color: isAvailable ? Colors.red.shade600 : AppColors.primaryOrange,
            onTap: () => onUpdateStatus(isAvailable ? 'adopted' : 'available'),
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            icon: Icons.assignment_outlined,
            title: 'View Adoption Requests',
            subtitle: 'Review incoming requests for this pet',
            color: Colors.blue.shade700,
            onTap: onViewAdoptionRequests,
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            icon: Icons.delete_forever_outlined,
            title: 'Delete Pet Listing',
            subtitle: 'Permanently remove this pet from the platform',
            color: Colors.red.shade900,
            onTap: onDelete,
          ),
          const SizedBox(height: 30),
          _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppStyles.small.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textLightGrey.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.backgroundGrey, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          'Dismiss',
          style: AppStyles.button.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}
