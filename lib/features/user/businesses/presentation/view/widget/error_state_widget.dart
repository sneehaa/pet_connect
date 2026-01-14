import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textLightGrey),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              'Go Back',
              style: AppStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
