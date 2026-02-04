import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class WorkScheduleQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const WorkScheduleQuestion({
    super.key,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTimelineOption(
            title: 'Home All Day',
            description: 'Remote work or stay-at-home lifestyle',
            value: 'home_all_day',
            icon: Icons.wb_sunny_rounded,
            accentColor: AppColors.successGreen,
          ),
          _buildTimelineOption(
            title: 'Part-time Away',
            description: 'Out of home for 4-6 hours daily',
            value: 'part_time_away',
            icon: Icons.wb_twilight_rounded,
            accentColor: AppColors.warningYellow,
          ),
          _buildTimelineOption(
            title: 'Full-time Away',
            description: 'Standard 8+ hour workday away',
            value: 'full_time_away',
            icon: Icons.nightlight_round,
            accentColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineOption({
    required String title,
    required String description,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    final isSelected = selectedValue == value;

    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline Indicator Column
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : AppColors.backgroundGrey,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accentColor.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.textLightGrey,
                  size: 20,
                ),
              ),
              Expanded(
                child: Container(width: 2, color: AppColors.backgroundGrey),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? accentColor : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => onChanged(value),
                  borderRadius: BorderRadius.circular(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? accentColor
                                    : AppColors.textBlack,
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
          ),
        ],
      ),
    );
  }
}
