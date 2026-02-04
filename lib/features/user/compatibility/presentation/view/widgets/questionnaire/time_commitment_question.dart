import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class TimeCommitmentQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const TimeCommitmentQuestion({
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
            title: 'Limited (1-2 hours)',
            description: 'Basic care and quick strolls',
            value: 'limited',
            icon: Icons.timer_outlined,
            accentColor: Colors.cyan,
            percentage: 0.25,
          ),
          _buildOption(
            title: 'Moderate (2-4 hours)',
            description: 'Regular play, training, and exercise',
            value: 'moderate',
            icon: Icons.schedule_rounded,
            accentColor: AppColors.primaryOrange,
            percentage: 0.55,
          ),
          _buildOption(
            title: 'Extensive (4+ hours)',
            description: 'Active lifestyle and constant companionship',
            value: 'extensive',
            icon: Icons.history_edu_outlined,
            accentColor: Colors.deepPurpleAccent,
            percentage: 0.90,
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
    required Color accentColor,
    required double percentage,
  }) {
    final isSelected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? accentColor.withOpacity(0.2)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isSelected ? accentColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Circular Progress Indicator around Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(
                        value: percentage,
                        strokeWidth: 4,
                        color: isSelected
                            ? accentColor
                            : accentColor.withOpacity(0.2),
                        backgroundColor: AppColors.backgroundGrey,
                      ),
                    ),
                    Icon(
                      icon,
                      color: isSelected ? accentColor : AppColors.textLightGrey,
                      size: 26,
                    ),
                  ],
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
                          fontSize: 17,
                          color: isSelected ? accentColor : AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppStyles.small.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: accentColor)
                else
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.backgroundGrey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
