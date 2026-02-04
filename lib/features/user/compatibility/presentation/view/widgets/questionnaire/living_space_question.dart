import 'package:flutter/material.dart';

class LivingSpaceQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const LivingSpaceQuestion({
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
          'What type of living space do you have?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'This helps us find pets that will be comfortable in your home.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildOption(
          context,
          '🏢 Apartment',
          'Compact living, shared walls',
          'apartment',
        ),
        _buildOption(
          context,
          '🏠 Small House',
          'Single-family home with limited space',
          'house_small',
        ),
        _buildOption(
          context,
          '🏡 Large House',
          'Spacious home with room to roam',
          'house_large',
        ),
        _buildOption(
          context,
          '🌾 Farm/Rural',
          'Large property, plenty of outdoor space',
          'farm',
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String description,
    String value,
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
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
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
