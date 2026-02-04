import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? action;
  final String actionText;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.pets_rounded,
    this.action,
    this.actionText = 'Get Started',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        // 1. Added ScrollView
        physics:
            const BouncingScrollPhysics(), // Optional: makes it feel more "premium"
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // 2. Important: Tells Column to take only needed space
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decorative Icon with Background
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    icon,
                    size: 60,
                    color: AppColors.primaryBlue.withOpacity(0.4),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                title,
                textAlign: TextAlign.center,
                style: AppStyles.headline2.copyWith(
                  color: AppColors.textBlack,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppStyles.body.copyWith(
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),

              if (action != null) ...[
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: action,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      actionText,
                      style: AppStyles.button.copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
