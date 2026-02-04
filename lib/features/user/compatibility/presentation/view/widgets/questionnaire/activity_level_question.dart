import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How active is your lifestyle?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'This helps match pets with similar energy levels.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildOption(
          context,
          '🚶 Sedentary',
          'Mostly indoors, minimal exercise',
          'sedentary',
          Icons.directions_walk,
        ),
        _buildOption(
          context,
          '🏃 Moderate',
          'Regular walks, some outdoor activities',
          'moderate',
          Icons.directions_run,
        ),
        _buildOption(
          context,
          '🏋️ Active',
          'Daily exercise, frequent outdoor activities',
          'active',
          Icons.fitness_center,
        ),
        _buildOption(
          context,
          '⚡ Very Active',
          'Intense daily exercise, sports enthusiast',
          'very_active',
          Icons.bolt,
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String description,
    String value,
    IconData icon,
  ) {
    final isSelected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
