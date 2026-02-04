import 'package:flutter/material.dart';

class QuestionnaireProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const QuestionnaireProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${((currentStep / totalSteps) * 100).round()}% Complete',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 8,
                width:
                    MediaQuery.of(context).size.width *
                    0.9 *
                    (currentStep / totalSteps),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onBack != null)
                ElevatedButton.icon(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[700],
                  ),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back'),
                ),
              const Spacer(),
              if (onNext != null)
                ElevatedButton.icon(
                  onPressed: onNext,
                  icon: Text(currentStep == totalSteps ? 'Submit' : 'Next'),
                  label: const Icon(Icons.arrow_forward, size: 16),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
