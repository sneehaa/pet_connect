import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class BreakdownChart extends StatelessWidget {
  final Map<String, dynamic> breakdown;

  const BreakdownChart({super.key, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, dynamic>> entries = breakdown.entries.toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text('Compatibility Breakdown', style: AppStyles.headline3),
            ],
          ),
          const SizedBox(height: 24),
          ...entries.map((entry) {
            final category = _formatCategory(entry.key);
            final data = entry.value as Map<String, dynamic>;
            final score = data['score'] as int? ?? 0;
            final detail = data['detail'] as String? ?? '';
            final weight = data['weight'] as String? ?? 'Normal';

            return _buildModernBar(category, score, detail, weight);
          }),
        ],
      ),
    );
  }

  Widget _buildModernBar(
    String category,
    int score,
    String detail,
    String weight,
  ) {
    final Color scoreColor = _getScoreColor(score);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category,
                style: AppStyles.body.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'W: $weight',
                  style: AppStyles.small.copyWith(
                    fontSize: 10,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$score%',
                style: AppStyles.headline3.copyWith(
                  color: scoreColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              // Track
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: 12,
                width: (score / 100) * 300, // Approximate width for visual flow
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [scoreColor, scoreColor.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: scoreColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (detail.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              detail,
              style: AppStyles.small.copyWith(
                color: AppColors.textLightGrey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const Divider(height: 32, color: AppColors.backgroundGrey),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 60) return AppColors.warningYellow;
    return AppColors.errorRed;
  }

  String _formatCategory(String key) {
    return key[0].toUpperCase() + key.substring(1).replaceAll('_', ' ');
  }
}
