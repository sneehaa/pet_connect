import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How much time can you dedicate daily?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Estimates for exercise, training, and care.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildOption(
          context,
          '⏱️ Limited (1-2 hours)',
          'Basic care, short walks',
          'limited',
          Icons.timer,
          Colors.red,
        ),
        _buildOption(
          context,
          '🕐 Moderate (2-4 hours)',
          'Regular exercise, some training',
          'moderate',
          Icons.access_time,
          Colors.orange,
        ),
        _buildOption(
          context,
          '⭐ Extensive (4+ hours)',
          'Lots of attention, training, activities',
          'extensive',
          Icons.star,
          Colors.green,
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
    Color color,
  ) {
    final isSelected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected ? color.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? color : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
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
                          color: isSelected ? color : Colors.black,
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
                if (isSelected) Icon(Icons.check_circle, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
