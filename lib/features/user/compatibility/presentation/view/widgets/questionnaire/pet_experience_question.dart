import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class PetExperienceQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const PetExperienceQuestion({
    super.key,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption(
          title: 'First-time Owner',
          description: 'Ready to start a new journey with a best friend.',
          value: 'first_time',
          icon: Icons.auto_awesome_outlined,
          accentColor: AppColors.primaryBlue,
        ),
        _buildOption(
          title: 'Some Experience',
          description: 'I’ve shared my life with pets before.',
          value: 'some_experience',
          icon: Icons.pets_outlined,
          accentColor: AppColors.primaryOrange,
        ),
        _buildOption(
          title: 'Experienced Pro',
          description: 'Extensive knowledge of pet care and behavior.',
          value: 'experienced',
          icon: Icons.workspace_premium_outlined,
          accentColor: AppColors.successGreen,
        ),
      ],
    );
  }

  Widget _buildOption({
    required String title,
    required String description,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    final isSelected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? accentColor
                  : AppColors.backgroundGrey.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              // Badge Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.1),
                      accentColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: accentColor, size: 30),
              ),
              const SizedBox(width: 20),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isSelected ? accentColor : AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppStyles.small.copyWith(
                        color: AppColors.textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.verified_rounded, color: accentColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
