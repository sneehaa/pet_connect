import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class LivingSpaceQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const LivingSpaceQuestion({
    super.key,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildGridOption(
          title: 'Apartment',
          description: 'Compact & cozy',
          value: 'apartment',
          icon: Icons.apartment_rounded,
        ),
        _buildGridOption(
          title: 'Small House',
          description: 'Single-family living',
          value: 'house_small',
          icon: Icons.home_rounded,
        ),
        _buildGridOption(
          title: 'Large House',
          description: 'Plenty of room',
          value: 'house_large',
          icon: Icons.other_houses_rounded,
        ),
        _buildGridOption(
          title: 'Rural/Farm',
          description: 'Wide open spaces',
          value: 'farm',
          icon: Icons.landscape_rounded,
        ),
      ],
    );
  }

  Widget _buildGridOption({
    required String title,
    required String description,
    required String value,
    required IconData icon,
  }) {
    final isSelected = selectedValue == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange.withOpacity(0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryOrange.withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected
                    ? AppColors.primaryOrange
                    : AppColors.textDarkGrey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? AppColors.textBlack : AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppStyles.small.copyWith(
                fontSize: 11,
                color: isSelected
                    ? AppColors.textGrey
                    : AppColors.textLightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
