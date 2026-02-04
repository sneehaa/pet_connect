import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class NoiseToleranceQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const NoiseToleranceQuestion({
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
          title: 'Low Tolerance',
          description: 'Prefer quiet pets, sensitive to noise',
          value: 'low',
          icon: Icons.volume_mute_rounded,
          intensityBars: 1,
          accentColor: Colors.blueAccent,
        ),
        _buildOption(
          title: 'Moderate Tolerance',
          description: 'Occasional barking or meowing is okay',
          value: 'moderate',
          icon: Icons.volume_down_rounded,
          intensityBars: 2,
          accentColor: AppColors.warningYellow,
        ),
        _buildOption(
          title: 'High Tolerance',
          description: "Vocal pets don't bother me at all",
          value: 'high',
          icon: Icons.volume_up_rounded,
          intensityBars: 3,
          accentColor: AppColors.errorRed,
        ),
      ],
    );
  }

  Widget _buildOption({
    required String title,
    required String description,
    required String value,
    required IconData icon,
    required int intensityBars,
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
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? accentColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? accentColor.withOpacity(0.15)
                    : Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with circular backdrop
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withOpacity(0.1)
                      : AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? accentColor : AppColors.textLightGrey,
                  size: 28,
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
              // Intensity Meter Visual
              _buildIntensityMeter(
                intensityBars,
                isSelected ? accentColor : AppColors.backgroundGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntensityMeter(int bars, Color color) {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          width: 6,
          height: 12.0 + (index * 6), // Bars get taller
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: index < bars
                ? color
                : AppColors.backgroundGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
