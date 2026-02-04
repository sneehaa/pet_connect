import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class HouseholdQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const HouseholdQuestion({
    super.key,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildOption(
            title: 'Living Alone',
            description: 'A peaceful single-person home',
            value: 'single',
            icon: Icons.person_outline_rounded,
          ),
          _buildOption(
            title: 'Couple',
            description: 'Two people sharing a life',
            value: 'couple',
            icon: Icons.favorite_border_rounded,
          ),
          _buildOption(
            title: 'Family with Kids',
            description: 'Energetic home with little ones',
            value: 'family_with_kids',
            icon: Icons.child_care_rounded,
          ),
          _buildOption(
            title: 'Roommates',
            description: 'Shared living with friends/peers',
            value: 'roommates',
            icon: Icons.groups_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required String description,
    required String value,
    required IconData icon,
  }) {
    final isSelected = selectedValue == value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.primaryOrange : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primaryOrange.withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryOrange.withOpacity(0.1)
                      : AppColors.primaryBlue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primaryOrange
                      : AppColors.textDarkGrey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.textBlack
                            : AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppStyles.small.copyWith(
                        color: AppColors.textLightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: selectedValue,
                activeColor: AppColors.primaryOrange,
                onChanged: (val) => onChanged(val!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
