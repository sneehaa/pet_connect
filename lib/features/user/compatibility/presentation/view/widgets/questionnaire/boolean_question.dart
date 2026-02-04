import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class BooleanQuestion extends StatelessWidget {
  final String question;
  final bool? value;
  final ValueChanged<bool> onChanged;

  const BooleanQuestion({
    super.key,
    required this.question,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: AppStyles.body.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildChoiceCard(
                context: context,
                label: 'Yes',
                optionValue: true,
                icon: Icons.check_circle_outline_rounded,
                activeColor: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChoiceCard(
                context: context,
                label: 'No',
                optionValue: false,
                icon: Icons.highlight_off_rounded,
                activeColor: AppColors.textDarkGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required String label,
    required bool optionValue,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = value == optionValue;

    return AnimatedScale(
      scale: isSelected ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: () => onChanged(optionValue),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.backgroundGrey,
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: activeColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : AppColors.textLightGrey,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: AppStyles.button.copyWith(
                  color: isSelected ? Colors.white : AppColors.textBlack,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
