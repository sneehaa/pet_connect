import 'package:flutter/material.dart';

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
        const Text(
          'What is your pet ownership experience?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Helps recommend pets suitable for your experience level.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildOption(
          context,
          '👶 First-time Owner',
          'Never owned a pet before',
          'first_time',
          Icons.child_care,
        ),
        _buildOption(
          context,
          '👍 Some Experience',
          'Owned pets in the past',
          'some_experience',
          Icons.thumb_up,
        ),
        _buildOption(
          context,
          '🏆 Experienced',
          'Currently own pets or extensive experience',
          'experienced',
          Icons.emoji_events,
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
