import 'package:flutter/material.dart';

class BooleanQuestion extends StatelessWidget {
  final String question;
  final bool? value;
  final ValueChanged<bool> onChanged;

  const BooleanQuestion({
    super.key,
    required this.question,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildOption(context, 'Yes', true)),
            const SizedBox(width: 16),
            Expanded(child: _buildOption(context, 'No', false)),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String text, bool optionValue) {
    final isSelected = value == optionValue;

    return Material(
      color: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onChanged(optionValue),
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
