import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class ActivityLevelQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const ActivityLevelQuestion({
    super.key,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOption(
            title: 'Sedentary',
            description: 'Mostly indoors, minimal exercise',
            value: 'sedentary',
            icon: Icons.chair_rounded,
            accentColor: Colors.blueAccent,
          ),
          _buildOption(
            title: 'Moderate',
            description: 'Regular walks, some outdoor activities',
            value: 'moderate',
            icon: Icons.directions_walk_rounded,
            accentColor: AppColors.successGreen,
          ),
          _buildOption(
            title: 'Active',
            description: 'Daily exercise, frequent outdoor activities',
            value: 'active',
            icon: Icons.directions_run_rounded,
            accentColor: AppColors.primaryOrange,
          ),
          _buildOption(
            title: 'Very Active',
            description: 'Intense daily exercise, sports enthusiast',
            value: 'very_active',
            icon: Icons.bolt_rounded,
            accentColor: AppColors.warningYellow,
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
  }) {
    final isSelected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryWhite
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: accentColor.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withOpacity(0.1)
                        : AppColors.backgroundGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? accentColor : AppColors.textLightGrey,
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
                          color: isSelected ? accentColor : AppColors.textBlack,
                          fontSize: 18,
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
                    Icons.circle_outlined,
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
