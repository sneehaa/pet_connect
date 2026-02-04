import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class CompatibilityScoreCard extends StatelessWidget {
  final int score;
  final String petName;

  const CompatibilityScoreCard({
    super.key,
    required this.score,
    required this.petName,
  });

  Color _getScoreColor() {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 60) return AppColors.warningYellow;
    return AppColors.errorRed;
  }

  String _getScoreText() {
    if (score >= 80) return 'Excellent Match!';
    if (score >= 60) return 'Good Match';
    if (score >= 40) return 'Potential Match';
    return 'Low Compatibility';
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = _getScoreColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'LIFESTYLE MATCH',
            style: AppStyles.small.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              color: AppColors.textLightGrey,
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow/Halo
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: mainColor.withOpacity(0.05),
                    width: 20,
                  ),
                ),
              ),
              // The Progress Gauge
              SizedBox(
                width: 140,
                height: 140,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: score / 100),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 14,
                      strokeCap: StrokeCap.round,
                      backgroundColor: AppColors.backgroundGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                    );
                  },
                ),
              ),
              // Center Text Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score%',
                    style: AppStyles.headline1.copyWith(
                      fontSize: 42,
                      color: AppColors.textBlack,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getScoreText(),
                      style: AppStyles.small.copyWith(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppStyles.body.copyWith(color: AppColors.textGrey),
              children: [
                const TextSpan(text: 'You and '),
                TextSpan(
                  text: petName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const TextSpan(text: ' are a great fit!'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
