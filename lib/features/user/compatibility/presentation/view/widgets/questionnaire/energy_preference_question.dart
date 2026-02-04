import 'package:flutter/material.dart';

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
        const Text(
          'What energy level do you prefer in a pet?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the pet energy level that best matches your preference.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildOption(
          context,
          '😌 Calm',
          'Relaxed, low-energy companion',
          'calm',
          Colors.blue,
        ),
        _buildOption(
          context,
          '😊 Moderate',
          'Balanced energy, adaptable',
          'moderate',
          Colors.green,
        ),
        _buildOption(
          context,
          '⚡ Energetic',
          'High-energy, playful companion',
          'energetic',
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String description,
    String value,
    Color color,
  ) {
    final isSelected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
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
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSelected ? 'Selected' : 'Select',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
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
