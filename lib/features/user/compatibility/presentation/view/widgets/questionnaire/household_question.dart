import 'package:flutter/material.dart';

class HouseholdQuestion extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const HouseholdQuestion({
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
          'What is your household situation?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Helps match pets that fit well with your living situation.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildOption(
          context,
          '👤 Living Alone',
          'Single person household',
          'single',
          Icons.person,
        ),
        _buildOption(
          context,
          '👫 Couple',
          'Living with a partner',
          'couple',
          Icons.favorite,
        ),
        _buildOption(
          context,
          '👨‍👩‍👧‍👦 Family with Kids',
          'Children in the household',
          'family_with_kids',
          Icons.family_restroom,
        ),
        _buildOption(
          context,
          '🏠 Roommates',
          'Sharing with roommates',
          'roommates',
          Icons.group,
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
                  padding: const EdgeInsets.all(8),
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
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
