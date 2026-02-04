import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class EnergyPreferenceQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const EnergyPreferenceQuestion({
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
          title: 'Calm',
          description: 'Relaxed, low-energy companion',
          value: 'calm',
          icon: Icons.self_improvement_rounded,
          baseColor: Colors.blueAccent,
        ),
        _buildOption(
          title: 'Moderate',
          description: 'Balanced energy, adaptable',
          value: 'moderate',
          icon: Icons.sentiment_satisfied_alt_rounded,
          baseColor: AppColors.successGreen,
        ),
        _buildOption(
          title: 'Energetic',
          description: 'High-energy, playful companion',
          value: 'energetic',
          icon: Icons.flash_on_rounded,
          baseColor: AppColors.primaryOrange,
        ),
      ],
    );
  }

  Widget _buildOption({
    required String title,
    required String description,
    required String value,
    required IconData icon,
    required Color baseColor,
  }) {
    final isSelected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? baseColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? baseColor : AppColors.backgroundGrey,
              width: 1.5,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: baseColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : baseColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isSelected ? Colors.white : AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppStyles.small.copyWith(
                        color: isSelected
                            ? Colors.white.withOpacity(0.9)
                            : AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Animated Check Indicator
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
